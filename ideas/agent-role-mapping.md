# Agent-to-Role Mapping

Allow tasks to declare the *kind* of work they need (`strategic`, `design`, `coding`, `review`) instead of pinning a specific agent. Ash resolves the role to an actual agent via a mapping config, keeping prompts portable and letting users swap agents per role without touching task files.

## Motivation

Tasks in `teams/` model a full company cycle — from board-level strategy down to deployment. Different phases suit different agents (or different models within the same agent). Hardcoding `agent: opencode` or `#!opencode` in every file couples the task tree to a specific runtime.

With role-based resolution:
- Task files declare intent (`role: coding`)
- A mapping file in the project (or user config) decides which agent handles each role
- Users can mix and match: `opencode` for coding, `claude-code` for review, a future "strategic" agent for planning

## Proposal

### 1. Frontmatter `role` field (`.md` files)

Tasks in directory mode get a new optional frontmatter key:

```markdown
---
role: coding
---

Implement the login endpoint...
```

### 2. Role shebang (`.ash` files)

Shebangs accept a role in place of an agent name:

```ash
#!role:coding

do "Fix the bug in auth.ts"
```

A `#!role:NAME` prefixed shebang delegates to the agent mapped to that role. Regular `#!agent` shebangs continue to work as before.

### 3. Mapping config (`ash.yml`)

```yaml
roles:
  strategic: opencode:sonnet
  design: opencode:sonnet
  coding: opencode
  review: claude-code:sonnet
  assess: claude-code
```

Resolution order:
1. Shebang or `with` clause specifies an agent explicitly → use it directly
2. Shebang or frontmatter specifies a `role:` → resolve via config
3. No role and no agent → fall back to `default_agent` from config

### 4. Resolution in `do` statements

```ash
do "Review auth module" with review   # role name without quotes resolves to agent
do "Write tests" with coding          # same
do "Debug this" with opencode         # explicit agent still works
```

The `with` clause accepts either an agent name or a role name. Ash checks the roles map first; if no match, treats it as an agent name.

### 5. CLI override

```bash
ash --role coding:aider teams/
```

Override one or more role bindings at runtime without editing config.

## Roles Used in `teams/` So Far

| Role | Typical Phase | Intended Capability |
|---|---|---|
| `strategic` | Direction setting, Define, Plan | Long-context synthesis, ambiguity handling, decision output |
| `design` | Tech design, Wireframes | Architecture reasoning, structured output, creative + tech |
| `coding` | Build, Deploy, Resolve | Code generation, debugging, shell commands |
| `review` | Observe, Review, Measure, Feed Back | Critical analysis, gap detection, metric interpretation |
| `assess` | Evaluate blocks (quality gates) | Scoring against criteria, structured feedback |

## Backward Compatibility

- Missing `role` field → current behaviour (uses default agent or explicit `agent:`)
- Undefined role name → warning, fallback to default agent
- No `roles:` block in config → warning, fallback to default agent
- Explicit `agent:` in frontmatter still takes highest priority

## Implementation Sketch

1. Add `role` to the set of recognised frontmatter keys (parsed alongside `agent`, `model`, etc.)
2. Parse `#!role:NAME` shebang prefix in ash scripts
3. Add `roles:` config block to `ash.yml` config model
4. Add `--role` CLI flag accepting `key:value` pairs
5. In the task runner / evaluator: resolve role → agent before dispatching
6. Extend `do` statement parser to accept role names in `with` clause
