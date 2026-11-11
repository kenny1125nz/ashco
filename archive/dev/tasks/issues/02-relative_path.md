# Task Definition: Script-Relative Path Resolution for `include` and `@file` (v2)

## Background

Both `include "path"` and `@file` (the `@"path"` syntax) resolve paths against the **process current working directory**, not the directory of the script containing the directive. A workflow script at `workflows/release/release.ash` must spell out absolute or repo-root-relative paths like `workflows/release/prepare.ash` — it leaks knowledge of the parent directory chain into the script source.

From a workflow perspective, a script should be self-contained within its directory. Includes and prompt files within the same directory should resolve relative to the script itself: `include "prepare.ash"` or `include "./prepare.ash"`.

The `Evaluator` struct currently carries no notion of the source file being executed. Both `eval_include` at `ash/src/eval/control.rs:119` and `eval_fp` at `ash/src/eval/expr.rs:263` read files via `fs::read_to_string(&path)` where `path` is the raw evaluated string expression — resolved by the OS against CWD. The script's source file path is never threaded through the evaluator.

**Previous version (v1):** `tmp/task-definition_1.md` laid out a `source_path: Option<PathBuf>` field on the evaluator. The assessment report (`tmp/assessment-report.md`) identified several issues with v1, all addressed here.

## Intended Solution

### Core Design

Add a `source_path: Option<PathBuf>` field to the `Evaluator` struct. When `Some`, it represents the filesystem path of the currently executing script. This path is set at entry points (CLI file load, tree-walker task execution) and looked up during `include` / `@file` to resolve relative paths against the script's parent directory.

When `source_path` is `None` (stdin, REPL, programmatic evaluation), relative paths continue to resolve against process CWD — no behavior change for those contexts.

### Path Resolution

A private method on `Evaluator` resolves a user-provided path string:

```
fn resolve_include_path(&self, path: &str) -> PathBuf
```

- If `path` is absolute (per `Path::is_absolute()`), return it unchanged.
- If `self.source_path` is `Some(sp)`, resolve relative to `sp.parent().join(path)`. `parent()` never returns `None` for a valid `Path` — it returns `Some("")` for paths without a parent component, and `Path::join` handles empty parents correctly, so unwrap is safe.
- Otherwise (no `source_path`), return `path` unchanged — existing CWD-relative behavior.

Both `eval_include` and `eval_fp` call this helper. For `eval_fp`, note that non-string path expressions are already rejected by a type check before the path string is obtained (line 266–271 of `expr.rs`), so the helper only receives string paths. For `eval_include`, non-strings are coerced via `format!("{}", other)` first, which is the existing behavior and is not changed.

### Nested Include Support

When `eval_include` loads an included file, it must temporarily set `self.source_path` to the resolved path of the included file so that nested `include` and `@file` directives within that file resolve relative to *it*. After the included body finishes executing, `source_path` is restored to its previous value.

This follows the save/restore pattern already used by `eval_dir_block` at `eval/mod.rs:353–375` (CWD save/restore) and `eval_session_block` at line 390–402 (session_depth increment/decrement). No stack is needed — nested includes naturally nest call frames since evaluation is synchronous and single-threaded.

### Where source_path Is Set

1. **CLI file argument** — `main.rs:run()`: When a file path is provided as a positional argument and loaded via `get_input()` (i.e., `!positional.is_empty()` and the path is not a directory), set `eval.source_path = Some(PathBuf::from(&positional[0]))` after creating the evaluator (after line 387) and before `eval.eval_script()`. **Must be guarded by `if !positional.is_empty()`** — when stdin is piped, `positional` is empty and indexing into it would panic.

2. **Tree walker task execution** — `tree.rs:execute_ash_task()` at line 445: Before calling `eval.eval_script()`, set `source_path` to `Some(task.path.clone())` so `.ash` task files resolve includes relative to their own location. After `eval.eval_script()` returns, reset `source_path` to `None` to prevent stale state leaking into subsequent tasks on the same evaluator (see "State Leak Mitigation" below).

3. **Evaluator fork** — `eval/mod.rs:fork()` at line 130: The `fork()` method copies `source_path` so that isolated task execution (`execute_task_isolated` at `tree.rs:490`) preserves the source-path context. This is needed for parallel execution (`execute_group_parallel` at line 569). Since the forked evaluator in `execute_task_isolated` gets `set_source_path` called before `execute_task`, the forked copy just provides a default.

### How source_path Reaches the Task Executor

The tree walker functions (`execute_ash_task`, `run_tree` sequential path, `execute_groups_isolated`, etc.) operate on `&mut dyn TaskExecutor`. To set `source_path` through this trait boundary, add a `set_source_path(&mut self, path: Option<PathBuf>)` method to the `TaskExecutor` trait at `tree.rs:91–97`, following the exact same pattern as `set_default_agent` and `set_default_model`. Implement it on `Evaluator` at `eval/mod.rs:465–488` by setting `self.source_path = path`.

### State Leak Mitigation in Shared Evaluators

In `execute_groups_isolated` (`tree.rs:598–621`), a single forked evaluator runs multiple tasks sequentially via `execute_task`. If an ash task sets `source_path` and the next task is a markdown task, the stale `source_path` would remain set. Mitigation: `execute_ash_task` resets `source_path` to `None` after `eval_script` returns (save before, restore to `None` after). This ensures no accidental state leak from ash tasks to downstream tasks on the same evaluator instance.

### Trade-offs and Rationale

- **Why `Option<PathBuf>` and not a `Vec<PathBuf>` stack?** Save/restore in `eval_include` is sufficient because evaluation runs synchronously on a single thread. Nested includes naturally use the call stack — each `eval_include` call pushes and pops. The codebase already uses this blunt save/restore pattern for CWD changes and session depth.

- **Why not change the parser or AST?** The AST nodes (`Include`, `FilePath`) are post-parse; the path expression is evaluated at runtime. The runtime just needs to know *where the current script lives* to adjust the resolved string. No AST or parser change is needed.

- **Why not canonicalize paths?** The current behavior uses OS-native `fs::read_to_string` which accepts both relative and absolute paths. Canonicalizing would change error messages (resolved symlinks appear instead of user-provided paths) and could break symlink-based setups. The parent directory of `source_path` provides sufficient context without canonicalization. Paths like `"./script.ash"` produce resolved includes like `"./sibling.ash"` which `fs::read_to_string` handles correctly.

- **Why not change other file operations (compact, executor, tree walker)?** Those operations are unrelated to script-relative includes. The requirement is scoped to `include` and `@file`.

- **Why add `set_source_path` to the trait rather than using direct field access at call sites?** The tree walker code operates through the `TaskExecutor` trait boundary. Adding a setter method to the trait follows the existing pattern (`set_default_agent`, `set_default_model`) and avoids either leaking the concrete `Evaluator` type into `tree.rs` or adding an error-prone helper function that downcasts. This is a standard trait-segregation pattern already established in the codebase.

### Interaction with `within_stack`

The `within_stack: Vec<PathBuf>` field on `Evaluator` (line 102) tracks the directory stack for `within` / `end` blocks (CWD changes at `eval_within_toggle`, line 423). The `source_path` field handles a completely separate concern: include/`@file` path resolution. They do not interact — `include` / `@file` resolution should use `source_path` (the script's home directory), not the current working directory. No conflict.

### Edge Cases

- **Stdin/REPL (no source file):** `source_path` is `None`. Relative paths resolve against CWD. No behavior change.
- **Piped stdin with `positional` empty:** Guard the CLI assignment with `if !positional.is_empty()`. Not guarding would panic on `positional[0]` access.
- **Absolute include/`@file` paths:** Pass through unchanged regardless of `source_path`.
- **Included file using `include` itself:** The included file's resolved path becomes `source_path`, so nested includes resolve relative to it. Correct.
- **Tree-walker task file:** `task.path` (from `WalkConfig::walk_dir`) carries the filesystem path of the `.ash` task. Set as `source_path` before execution, reset to `None` after.
- **Parallel tree tasks:** `fork()` copies `source_path`; then the forked evaluator receives its own `task.path` via `set_source_path`. No race conditions — each thread has its own evaluator.
- **Dry-run:** Irrelevant — no file I/O happens during dry-run.
- **Missing file:** `fs::read_to_string` fails with an OS error. The resolved path (i.e., parent-joined path) appears naturally in the error message since it's the path passed to `fs::read_to_string`.
- **Bare filename in `source_path`:** `parent()` returns `Some("")` and `Path::new("").join("sibling.ash")` is `"sibling.ash"` — works correctly.
- **`../` traversal:** `parent().join("../other.ash")` resolves correctly via `Path::join`.

### What Changes

| File | Change |
|---|---|
| `ash/src/eval/mod.rs` | Add `source_path: Option<PathBuf>` to `Evaluator` struct (after line 102). Initialize to `None` in `Evaluator::new()` (after line 123). Copy from self in `fork()` (after line 143). Add private method `resolve_include_path(&self, path: &str) -> PathBuf`. Add `set_source_path(&mut self, path: Option<PathBuf>)` public method. Implement `set_source_path` on `TaskExecutor for Evaluator` (after line 483). |
| `ash/src/eval/control.rs` | In `eval_include` (line 119): resolve path via `resolve_include_path`, save/restore `source_path` around execution, use resolved path for `fs::read_to_string` and error messages. |
| `ash/src/eval/expr.rs` | In `eval_fp` (line 263): resolve path via `resolve_include_path`, use resolved path for `fs::read_to_string` and error messages. |
| `ash/src/main.rs` | In `run()` (after line 387): set `eval.source_path = Some(PathBuf::from(&positional[0]))` guarded by `if !positional.is_empty()`, before `eval.eval_script()`. |
| `ash/src/runtime/tree.rs` | Add `fn set_source_path(&mut self, path: Option<PathBuf>)` to the `TaskExecutor` trait (after line 96). In `execute_ash_task` (line 445): save previous source_path, call `eval.set_source_path(Some(task.path.clone()))`, run `eval.eval_script()`, restore to `None`. |
| Test files | New tests in `control.rs` and `expr.rs`. |

## Acceptance Criteria

1. When `ash path/to/script.ash` is run and the script contains `include "sibling.ash"`, the file `path/to/sibling.ash` is loaded (not `./sibling.ash` relative to CWD).

2. When `ash path/to/script.ash` is run and the script contains `@"sibling-prompt.md"`, the file `path/to/sibling-prompt.md` is read (not `./sibling-prompt.md` relative to CWD).

3. When `ash path/to/script.ash` is run and the script contains `include "/absolute/path/to/file.ash"`, the absolute path is used unchanged.

4. When a script loaded via `include` contains its own `include "nested.ash"`, the nested include resolves relative to the *included* script's directory, not the original script's directory.

5. When `ash` is invoked with a script piped via stdin (`echo 'include "x.ash"' \| ash`) or via REPL, `include` and `@file` continue to resolve relative to process CWD (no regression). The `positional` vector is empty; `source_path` remains `None`.

6. When a `.ash` task file in a directory tree (`ash path/to/tasks/`) contains `include "sibling.ash"`, the sibling resolves relative to that task file's directory.

7. The existing `test_include_file` unit test in `control.rs` continues to pass without modification.

8. The master integration test (`ash ash/testdata/test_all.ash`) continues to pass when run from the repository root.

9. Error messages when a file is not found include the fully resolved path (the path actually passed to `fs::read_to_string`), not just the raw user-provided string.

10. `eval_fp` rejects non-string path expressions with the same type error as before (no change in type checking at line 266–271 of `expr.rs`).

11. **New — CLI panic prevention:** Running `echo 'include "x.ash"' | ash` (stdin input, no positional file argument) does not panic. `source_path` remains `None` and relative includes resolve against CWD.

12. **New — State cleanup:** A markdown task that follows an ash task in the same evaluator instance (sequential group or `execute_groups_isolated`) does not inherit the ash task's `source_path`.

13. **New — Deep nesting:** A chain of 3+ nested includes (`a.ash` includes `b.ash` includes `c.ash`) correctly resolves each level's includes relative to its own directory, and the deepest include's `source_path` is restored after return at each level.

## Implementation Hints

### Relevant Modules and File Paths

| Area | Path | Key Lines |
|---|---|---|
| Evaluator struct | `ash/src/eval/mod.rs` | 90–106 (struct fields) |
| Evaluator::new() | `ash/src/eval/mod.rs` | 109–128 |
| Evaluator::fork() | `ash/src/eval/mod.rs` | 130–148 |
| TaskExecutor impl for Evaluator | `ash/src/eval/mod.rs` | 465–488 |
| eval_include | `ash/src/eval/control.rs` | 119–139 |
| eval_fp | `ash/src/eval/expr.rs` | 263–278 |
| CLI entry point (run) | `ash/src/main.rs` | 291–407 |
| get_input | `ash/src/main.rs` | 409+ |
| execute_ash_task | `ash/src/runtime/tree.rs` | 445–479 |
| execute_task | `ash/src/runtime/tree.rs` | 481–488 |
| execute_task_isolated | `ash/src/runtime/tree.rs` | 490–493 |
| execute_groups_isolated | `ash/src/runtime/tree.rs` | 598–621 |
| execute_group_parallel | `ash/src/runtime/tree.rs` | 569–596 |
| run_tree (sequential path) | `ash/src/runtime/tree.rs` | 674–693 |
| TaskExecutor trait | `ash/src/runtime/tree.rs` | 91–97 |
| Task struct | `ash/src/runtime/tree.rs` | 22–31 (has `path: PathBuf`) |
| Include AST node | `ash/src/lang/ast.rs` | 71 |
| FilePath AST node | `ash/src/lang/ast.rs` | 285–288 |
| Existing include test | `ash/src/eval/control.rs` | 384–403 |
| Existing fp test fixture | `ash/src/eval/agent.rs` | 1273–1303 |
| Integration test runner | `ash/testdata/test_all.ash` | 17–18 |
| Language integration tests | `ash/testdata/lang_tests.ash` | full file |
| Agent integration tests | `ash/testdata/agent_tests.ash` | 423–439 (uses `@"testdata/prompt.md"`) |
| Test prompt fixture | `ash/testdata/prompt.md` | interpolation fixture |

### Existing Patterns to Follow

- **Save/restore for mutable state:** `eval_dir_block` at `eval/mod.rs:353–375` saves and restores CWD via `std::env::current_dir()` / `set_current_dir`. `eval_session_block` at lines 390–402 increments/decrements `session_depth`. Follow this blunt push-pop pattern for `source_path` in `eval_include`.
- **Trait method addition:** `set_default_agent` and `set_default_model` are defined on both `Evaluator` (public methods, lines 150–156) and `TaskExecutor` trait (lines 93–94) with delegation in the trait impl (lines 477–483). Add `set_source_path` the same way: a public method on `Evaluator`, a signature in the `TaskExecutor` trait, and delegation in `impl TaskExecutor for Evaluator`.
- **Path joining:** Use `Path::is_absolute()`, `Path::parent()`, and `Path::join()` — all in `std::path`. `PathBuf` is already imported at `mod.rs:9`.
- **Unit test style:** The `test_include_file` test at `control.rs:384` creates a temp directory with `tempfile::Builder`, writes script files, evaluates them, and asserts on captured stdout. The test helper `include_node` at line 173 constructs an `Include` AST node from a path expression. The test helper `make_evaluator()` at line 151 returns a fresh `Evaluator::new()`. Follow this pattern: set `ev.source_path` on a fresh evaluator, create a tempdir with sibling files, call `ev.eval_include`, assert via captured stdout or returned value.
- **Debug logging:** Use `debug!("eval — include file {}", resolved_path)` — the `debug!` macro (from `log`) is already in scope in `control.rs`.

### Test Specifications

- **In `control.rs` tests module (line 142+):** Add a test that creates a temp directory with `main.ash` and `sibling.ash`, sets `eval.source_path = Some(tempdir.path().join("main.ash"))`, constructs and evaluates `include "sibling.ash"`, and asserts the included file executed (capture stdout from the sibling script). Add a test that verifies nested includes resolve correctly (tempdir with `main.ash` → `sub/included.ash` → `sub/sibling.ash`). Add a test that verifies `source_path` is restored after `eval_include` returns (set source_path to main, include sub/file, assert source_path back to main).

- **In `expr.rs` tests module:** Add a test that creates a temp directory with a script file and a sibling `.md` file, sets `eval.source_path` to the script's path, calls `eval_fp` (or the expression eval path that triggers it) with `@"sibling.md"`, and asserts the file content is read. Add a test that non-string path expressions still produce the existing type error (not a path-resolution error).

- **Note on existing tests:** The existing `test_include_file` at `control.rs:384` uses `include_node(string_lit("/absolute/path"))` with a temp file written to an absolute path. With the new resolution logic, absolute paths are passed through unchanged, so this test will continue to pass without modification, **provided the test evaluator's `source_path` remains `None`** (it does, because `make_evaluator()` returns `Evaluator::new()` which has `source_path: None`).

### What NOT to Touch

- **Parser** (`ash/src/lang/parser.rs`) — no changes needed. Path resolution is a runtime concern.
- **Lexer** (`ash/src/lang/lexer.rs`) — no changes needed.
- **AST definitions** (`ash/src/lang/ast.rs`) — `Include` and `FilePath` nodes are sufficient as-is.
- **Compact config** (`ash/src/runtime/compact.rs`) — no file I/O changes.
- **Interpolation** (`ash/src/runtime/interpolation.rs`) — unrelated.
- **Executor** (`ash/src/runtime/executor.rs`) — bash subprocesses are unrelated.
- **Agent adapters, driver, discovery** (`ash/src/engine/`) — unrelated.
- **Telemetry** (`ash/src/telemetry/`) — unrelated.
- **REPL** (`ash/src/repl.rs`) — `source_path` remains `None` (CWD-relative), no changes needed.
- **CI configuration** — tests run via `cargo test` from repo root, existing behavior preserved.
- **The `include` integration test scripts** (`testdata/test_all.ash`, `lang_tests.ash`, `agent_tests.ash`) — these use repo-root-relative paths that should continue to work. They can optionally be updated later to use script-relative paths.
- **The test prompt file** (`testdata/prompt.md`) — unchanged.
- **Error types** (`ash/src/error.rs`, `EvalError`) — no new error variants needed. Existing `EvalError::Msg` is sufficient.
- **`within` / `end` block logic** (`eval_within_toggle`) — completely separate feature; no changes needed.
- **`dir` block logic** (`eval_dir_block`) — completely separate feature; no changes needed.

### Key Differences from v1 (task-definition_1.md)

This section summarizes changes made in response to the assessment report findings:

1. **CLI panic fix (assessment #1):** The v1 doc said to set `source_path` unconditionally at line 387. This v2 doc explicitly requires guarding with `if !positional.is_empty()` and adds Acceptance Criterion 11 for stdin panic prevention.

2. **Trait method decided (assessment #2):** v1 said "add `set_source_path` to `TaskExecutor` trait, **or** setting it at call sites." v2 definitively chooses the trait approach, following the `set_default_agent`/`set_default_model` pattern, and explains the rationale.

3. **State leak addressed (assessment #3):** v1 did not acknowledge the stale-source-path problem in `execute_groups_isolated`. v2 adds a "State Leak Mitigation" subsection and Acceptance Criterion 12 requiring cleanup after ash task execution.

4. **Test specifications elaborated (assessment #4):** v1 said "New unit test" without detail. v2 adds a "Test Specifications" subsection naming specific test scenarios: sibling include, nested includes, source_path restoration, and non-string path errors.

5. **within_stack interaction clarified (assessment #5):** v1 never mentioned `within_stack`. v2 adds an "Interaction with `within_stack`" subsection explaining they are independent features that do not interact.

6. **parent().unwrap() justified (assessment #6):** v2 includes rationale for why `parent().unwrap()` is safe.

7. **Type-check asymmetry acknowledged (assessment #8):** v2's Path Resolution section notes that `eval_fp` rejects non-strings before reaching the resolution helper, so the helper only receives string paths.

8. **Relative CLI paths mentioned (assessment #9):** v2's Trade-offs section acknowledges that paths like `"./script.ash"` produce `"./sibling.ash"` correctly.

9. **Deep nesting added as acceptance criterion (new):** Acceptance Criterion 13 covers chains of 3+ nested includes with restoration at each level.

10. **Existing-test compatibility explained:** The Implementation Hints note that `test_include_file` continues to work because `make_evaluator()` returns an evaluator with `source_path: None`, so absolute paths pass through unchanged.
