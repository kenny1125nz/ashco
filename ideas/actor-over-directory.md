# Actor-over-Directory

Actors introduce a multi-pass pipeline on top of ash's directory mode. Instead of a single one-shot request per leaf task, each task runs through a sequence of specialized passes — implement, assess, rework — each handled by a separate "actor" with its own instructions, model, and agent. The result is higher-quality output through deliberate iteration.

## Problem

Today, `ash tasks/` walks a directory tree, and for each `.md` leaf, calls `execute_md_task()` — one `eng.execute(&req)` call, one response, no built-in iteration. If the agent produces something subpar, you re-run the whole tree or manually redo the task.

## Concept

An **actor** is a set of instructions (a markdown prompt) that targets a specific phase of work on a leaf task. Multiple actors form a **pipeline** applied to each leaf node in sequence.

```
Leaf node "build-login.md"
  → Actor: implement   (coding agent, generates the code)
  → Actor: assess      (review agent, scores against acceptance criteria)
  → Actor: rework      (coding agent, applies fixes from the assessment)
```

Each actor receives an **assembled prompt** built from:
1. The **actor's own instructions** — a reusable, project-neutral prompt describing the phase's goal (e.g. "You are implementing. Write code to satisfy the goal and design below.")
2. **Selected sections** from the leaf node's markdown file — the actor definition declares which sections it needs (e.g. `implement` needs `Goal` and `Design`; `assess` needs `Acceptance Criteria` and `Test Coverage`).

This keeps leaf node files as the single source of truth while actors are reusable across projects.

## Leaf Node Format

A leaf node file (`.md` in the target directory tree) uses named sections:

```markdown
---
model: sonnet
on_fail: skip
---

## Goal
Build a login endpoint that accepts email/password and returns a JWT.

## Design
- POST /auth/login
- Validate inputs, bcrypt compare, sign JWT with RS256
- Return { token, expires_in }

## Acceptance Criteria
- [ ] Returns 401 on invalid credentials
- [ ] Returns 429 after 5 failed attempts
- [ ] Token expires in 1 hour

## Test Coverage
- [ ] Unit tests for validation and hashing
- [ ] Integration test for the full login flow
```

Existing frontmatter keys (`agent`, `model`, `compact`, `on_fail`, `role`) continue to work as overrides on the leaf node. An actor's own frontmatter takes precedence unless the leaf node explicitly sets something different.

## Actor Definition Format

Actor files are markdown with YAML frontmatter declaring metadata and section selection:

```markdown
---
model: sonnet
agent: opencode
read: Goal, Design
---

You are implementing a feature. Use the sections below as your specification.

Start from a clean working directory. Write production-quality code and create all necessary files.
When done, stage all changes with `git add -A`. Do not commit.
```

```markdown
---
model: sonnet
agent: claude-code
read: Acceptance Criteria, Test Coverage
---

You are assessing an implementation. Review only the staged changes (`git diff --cached`) against the sections below.
For each criterion, produce a finding rated as **critical**, **major**, **minor**, or **pass**.
Rank findings by severity. Write the full assessment report to `assessment.md`.
```

```markdown
---
model: sonnet
agent: opencode
read: Goal, Design
---

You are reworking an implementation based on the assessment report at `assessment.md`.
Read that report and address all **critical** and **major** findings. Skip minor findings unless trivially fixed.
Apply fixes, then finalize with `git add -A && git commit -m "<message>"`.
Finally, remove `assessment.md`.
```

### Frontmatter Keys

| Key | Required | Description |
|---|---|---|
| `model` | no | Model name, overrides leaf node and walk config |
| `agent` | no | Agent name (opencode, claude-code, aider, etc.) |
| `role` | no | Role name resolved via `roles:` in ash.yml (mutually exclusive with `agent`) |
| `read` | no | Comma-separated section names to extract from the leaf node. If omitted, the full leaf node content is forwarded. |

### Section Assembly

When `read` is specified, ash extracts the named sections from the leaf node (matching `##` heading text exactly) and appends them to the actor's instructions when assembling the final prompt. The actor file itself only contains the instructions — the app handles reassembly automatically.

If `read` is omitted, the entire leaf node content (minus its own frontmatter) is appended to the actor instructions.

## Pipeline Execution

For each leaf node in the directory tree:

1. **Resolve actors** — determine which actor definitions apply to this leaf (see Actor Discovery below).
2. **For each actor in sequence**:
   a. Assemble the prompt: actor body + extracted leaf sections.
   b. Resolve the agent and model (actor frontmatter > leaf frontmatter > walk config defaults).
   c. Execute `eng.execute(&req)` — a standard one-shot call, same as current directory mode.
3. The **last actor's result** becomes the task result for logging/telemetry.
4. Continue to the next leaf node.

### Inter-actor Context

Actors are independent — each receives only its own instructions and the leaf node sections. The implement/assess/rework loop works because the coding agent modifies the actual codebase, so subsequent actors observe the changed filesystem. For explicit handoff (e.g. assess → rework), the upstream actor writes its report to a known file that the downstream actor reads and cleans up. Git staging (`git add -A`) carves a review boundary: implement stages, assess reviews `git diff --cached`, rework commits.

## Actor Discovery and Resolution

Actors can be sourced from three places, resolved in the following order:

### 1. `actors/` folder in the target directory tree (nearest wins)

```
tasks/
├── 01-plan/
│   ├── actors/
│   │   ├── 01-implement.md
│   │   └── 02-assess.md
│   ├── 01-research.md
│   └── 02-architecture.md
├── 02-build/
│   ├── actors/
│   │   └── 01-implement.md       # overrides parent's implement actor
│   └── 01-login.md
└── actors/
    ├── 01-implement.md
    ├── 02-assess.md
    └── 03-rework.md
```

A leaf node inherits from the **nearest** `actors/` directory found by walking up its ancestor chain. Sub-`actors/` override parent `actors/` on a **per-file basis** (keyed by numeric prefix). An `actors/` folder at the target root acts as the default pipeline.

Actors within a folder execute in numeric prefix order. If all files start with `0`, execution order is lexicographic.

### 2. `--actors <dir>` CLI flag

```bash
ash --actors ./shared-actors tasks/
```

Specifies an external directory of actor definitions. The directory follows the same numbered-file convention. Applied to all leaf nodes in the walk.

### 3. `--actor <file>` CLI flag

```bash
ash --actor ./quick-review.md tasks/
```

Specifies a single actor file (no numeric prefix required). Applied to all leaf nodes. Useful for one-off passes like a global review sweep.

### Conflict Rules

- `--actors` and `--actor` are mutually exclusive. Passing both is an error.
- If both an `actors/` folder **and** `--actors`/`--actor` are present, ash prompts for confirmation (unless `--force`). When confirmed or forced, the **CLI argument wins** — the `actors/` folder is ignored entirely.
- If no actors are found anywhere, ash falls back to **standard one-shot directory mode** — fully backward compatible.

### Per-Leaf Override

A leaf node's frontmatter can opt out of actors entirely:

```markdown
---
actors: false
---
```

This runs the leaf as a classic one-shot task, bypassing the actor pipeline for that specific file.

## Integration with Existing Concepts

### Role Mapping

Actor definitions use `role` alongside `agent` (see [agent-role-mapping.md](./agent-role-mapping.md)). An actor can declare `role: coding` instead of `agent: opencode`, making actor pipelines portable across different agent setups.

### Workflow State

Actor execution produces natural pause points (see [work-flow-state.md](./work-flow-state.md)). If `03-rework.md` fails, the user could resume from that actor at that leaf, or skip it and continue. Each actor's per-leaf result is a granular checkpoint.

### Parallel Groups

When leaf nodes are grouped for parallel execution (same numeric prefix), each leaf runs its own actor pipeline independently on its own thread. The actor pipeline is per-leaf, not per-group — parallelism is preserved.

## CLI Summary

```
ash [--actors <dir> | --actor <file>] [--force] <target-dir>
```

| Flag | Effect |
|---|---|
| `--actors <dir>` | Use actor definitions from this directory |
| `--actor <file>` | Use a single actor definition file |
| `--force` | Skip confirmation when both actors/ folder and CLI args are present |
| (none, auto-detect) | Use nearest `actors/` folder in the target tree; fall back to one-shot mode |

All existing flags (`--dry-run`, `--continue-on-error`, `--yes`, `--agent`, `--model`, `--session`) continue to work.

## Example: Full Pipeline Walkthrough

Given:
```
tasks/01-build/01-login.md   (the leaf node with Goal, Design, Acceptance Criteria)
tasks/actors/
  ├── 01-implement.md         (role: coding, read: Goal, Design)
  ├── 02-assess.md            (role: review, read: Acceptance Criteria)
  └── 03-rework.md            (role: coding, read: Goal, Design)
```

Running `ash tasks/`:

1. Walker reaches `tasks/01-build/01-login.md`
2. Resolves actors: nearest `actors/` is `tasks/actors/` → pipeline = [implement, assess, rework]
3. **Implement**: Assembles `01-implement.md` body + `## Goal` / `## Design` from login.md → dispatches to coding agent. Agent creates `auth/login.ts`.
4. **Assess**: Assembles `02-assess.md` body + `## Acceptance Criteria` from login.md → dispatches to review agent. Agent checks `auth/login.ts` against criteria, produces a report.
5. **Rework**: Assembles `03-rework.md` body + `## Goal` / `## Design` from login.md → dispatches to coding agent. Agent reads the assessment and fixes issues.
6. Walker proceeds to the next leaf.

Output:
```
[1/3] 01-build/01-login.md  →  implement  ... ✓
                                assess     ... ✓ (2/4 criteria passed)
                                rework     ... ✓ (4/4 criteria passed)
```

## Implementation Plan

The work splits into 5 independent chunks, each a suitable one-shot coding agent task.

### 1. Actor file parsing

**Scope**: Read all files in an `actors/` directory, parse frontmatter and body from each, produce a `Vec<Actor>`.

```
struct Actor {
    model: Option<String>,
    agent: Option<String>,
    role: Option<String>,
    read: Vec<String>,
    body: String,
}
```

No integration with the tree walker. Input is a directory path, output is validated structs. Sorting by numeric prefix happens here.

### 2. Section extraction

**Scope**: Given a leaf node `.md` file path and a set of section names (the `read` list), extract the matching `##` headings and their content.

```
fn extract_sections(path: &Path, read: &[String]) -> HashMap<String, String>
```

Pure parsing — no IO beyond reading the file. Each section maps heading text → content (excluding the heading line itself).

### 3. Prompt assembly

**Scope**: Given an `Actor` and the extracted sections, produce the final prompt string sent to the agent.

```
fn assemble_prompt(actor: &Actor, sections: &HashMap<String, String>, leaf_node: &Path) -> String
```

Assembly order: actor body, then each `read` section appended with its original `##` heading. If `read` is empty, append the full leaf node content instead.

### 4. Pipeline executor

**Scope**: The core loop — for a given leaf node `Task`, run the resolved actor pipeline sequentially.

```
fn run_actor_pipeline(task: &Task, actors: &[Actor], config: &WalkConfig, eval: &mut Evaluator) -> Result
```

Wraps the existing `execute_md_task` pattern. For each actor: assemble prompt, resolve agent/model (actor > leaf > walk config), call `eng.execute()`, capture result. The last actor's result is the task result. Depends on chunks 1–3.

### 5. Actor discovery, CLI, and integration

**Scope**:

- `actors/` folder discovery with nearest-wins walking up the directory tree
- Per-file override (`actors: false` in leaf frontmatter)
- `--actors <dir>` and `--actor <file>` CLI flags (mutually exclusive)
- Conflict detection and confirmation prompt when both `actors/` and CLI args are present, `--force` to skip
- Wire into `run_tree` — if actors are resolved for a leaf, call the pipeline executor instead of `execute_md_task`
- Fallback to standard one-shot mode when no actors are found anywhere

Covers `main.rs` (CLI), `tree.rs` (walk integration), and a new actor resolution module.

## Future Directions

- **Section requirement**: `read:` frontmatter key could support `!name` syntax to mark a section as required (error if missing from leaf node).
- **Conditional actors**: An actor could declare a `condition:` expression (e.g. `condition: "${assess.passed} < ${assess.total}"`) to skip rework when all criteria pass.
- **Actor result caching**: If a leaf node hasn't changed and a prior actor's result is cached, skip re-running that actor (requires content hashing of leaf + actor definition).
- **Interactive actor loop**: Instead of a fixed implement→assess→rework pipeline, support a loop actor that runs implement→assess→rework→assess→rework... until all criteria pass or a max iteration limit is reached.
