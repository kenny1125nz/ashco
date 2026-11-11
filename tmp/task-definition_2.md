# Event-Driven Workflow Execution — Task Definition v2

## Background

Ash workflows today are triggered exclusively by a user running the `ash` CLI with a directory path, script file, or REPL command. This supports interactive use but blocks automated, unattended execution. The idea document `ideas/event-driven.md` calls event-triggered execution "a must for enterprise level orchestration" and lists five event source categories: folder watchers, message streams (MQ/Kafka/cloud messaging), webhooks, chat-based applications, and cron-like schedulers.

The project already has:
- **A working telemetry pipeline** (`ash/src/telemetry/pipeline.rs`) that writes events to a local JSONL file and spawns an in-process remote-consumer thread whose `deliver_remote()` is a no-op stub. Config structures already define Kafka and Splunk adapters (`telemetry/config.rs:11–13`), but actual delivery is not implemented.
- **A config system** (`ash/src/config.rs`) built around `ash.yml` with YAML-deserialized structs for agents and telemetry.
- **Two existing crates** under `ash/`: the `ash` binary/library crate and `ash-wasm` (a `cdylib`). There is no Cargo workspace — the crates use path dependencies independently. A new sibling crate follows the same pattern.
- **A prioritization** in `ideas/prioritized-ideas.md` that ranks event-driven execution at Priority 2 (after DSL improvements and workflow state) and flags it as "a large architectural expansion (new daemon application)."

The idea document asks a key architectural question: should event-listening logic live inside Ash, or as a separate application? It leans toward a separate daemon that can also serve as the relay layer between async applications and the telemetry data store.

This v2 task definition builds on v1, incorporating all findings from `tmp/assessment-report.md`.

### Scope gap analysis: five event source types → MVP covers three

The idea document lists five source types. This MVP covers only folder watcher, cron scheduler, and webhook listener. The other two are **explicitly deferred**:

| Source type | MVP? | Rationale |
|---|---|---|
| **Folder watcher** | Yes | Lowest complexity, immediate use case (drop-folder automation). |
| **Cron scheduler** | Yes | Required for scheduled jobs (the idea doc explicitly calls for it on line 18). |
| **Webhook listener** | Yes | Covers the most common enterprise trigger (CI/CD, chat outbound webhooks, platform callbacks). |
| **Message streams** (MQ/Kafka/cloud messaging) | Deferred | These are pull-based, long-lived connections that require protocol-specific clients and backpressure handling. The webhook listener already covers the push-based subset. When message streams are needed, the event source abstraction (common trait + channel) makes them a drop-in addition. |
| **Chat-based applications** | Deferred | Chat platform integrations are effectively webhooks or polling loops in disguise. The webhook source handles outbound-webhook patterns (Slack, Teams). Direct API polling loops are deferred until a real integration is prioritized. |

This scope discipline keeps the MVP focused on the three sources that provide the broadest coverage with the least complexity.

---

## Intended Solution

### Core decision: a separate daemon binary (`ash-eventd`)

The event trigger layer will be a **new sibling crate** at `ash/ash-eventd/` alongside `ash/ash/` and `ash/ash-wasm/`. It will not be embedded in the `ash` CLI.

**There is no Cargo workspace** in this repository. `ash-wasm` depends on `ash` via `ash = { path = "../ash", default-features = false }` in its own `Cargo.toml`. `ash-eventd` will follow the exact same path-dependency pattern. A Cargo workspace is not introduced — it would be a separate change with build-system implications (shared `Cargo.lock`, resolver unification) that belong in their own task.

**Rationale for a separate binary:**
- The `ash` CLI is short-lived and user-invoked; a daemon is long-lived and signal-driven. Conflating them would complicate the CLI's lifecycle and muddy error handling.
- The daemon's dependency set (filesystem watchers, an HTTP server, a cron parser, Kafka client) differs from the CLI's. None of these belong in a command-line orchestrator.
- Independent lifecycle management: operators can start, stop, or restart the daemon without affecting in-progress workflow runs.
- The idea document itself proposes a separate application (line 7). The daemon also serves the telemetry relay role without coupling telemetry concerns further into the main binary.

### Architecture overview

```
                +----------------------+
                |   ash-eventd         |
                |   (daemon)           |
                |                      |
  file-system  -->  folder watcher  ---+
    webhook    -->  http listener   ---+--> spawn "ash <path>" subprocess --> ash CLI binary
  cron tick    -->  scheduler       ---+
                |                      |
  ash-telemetry.jsonl --read--> relay thread --> kafka / splunk
                +----------------------+
```

The daemon has three responsibilities:
1. **Listen for external events** from configured sources.
2. **Invoke workflow runs** by spawning the `ash` binary with the configured workflow path and options, passing event context via environment variables.
3. **Ship telemetry** to remote sinks by consuming the local JSONL file that the `ash` CLI writes to.

### Event source abstraction

Event sources implement a common trait:

```rust
pub trait EventSource: Send {
    /// Start listening. Sends triggered events through the provided channel.
    /// Returns immediately (does not block) — listening runs on internal threads/loops.
    fn start(&mut self, sender: Sender<TriggerEvent>, shutdown: Arc<AtomicBool>) -> Result<(), Error>;

    /// Human-readable name for logging and diagnostics.
    fn name(&self) -> &str;
}
```

Each source type receives:
- A shared `Sender<TriggerEvent>` to push events into the daemon's dispatch loop.
- An `Arc<AtomicBool>` shutdown flag it must check per-iteration to terminate cleanly.

The daemon main loop receives from the channel and spawns workflow subprocesses. Each source is independently cancellable via its own shutdown signal.

### Event source types — MVP scope

#### Folder watcher (`folder`)

- Library: `notify` crate (v7, cross-platform, event-driven, no polling).
- Watches a directory path.
- Configuration: `recursive` (bool), `patterns` (list of glob patterns to match filenames), `events` (subset of `[create, modify, delete]` — defaults to `[create]`).
- Each event carries the file path and change kind.
- Events are debounced: within a 500ms window, duplicate events for the same file path are collapsed into one. This avoids spawning multiple workflows when an editor does a write-and-rename sequence.

#### Cron scheduler (`cron`)

- Library: `cron` crate (v0.13).
- **Tick resolution: 1 second.** The scheduler re-evaluates all cron expressions every second. At one-second granularity, standard cron expressions are fully supported and CPU usage is negligible (simple arithmetic per tick).
- When an expression matches the current time, emits an event.
- A source can define multiple cron entries under one scheduler block to reduce config verbosity.
- Multiple workflows can be bound to the same cron schedule (they are spawned concurrently).

#### Webhook listener (`webhook`)

- Library: `tiny_http` (v0.12). Minimally-threaded, synchronous, no async runtime overhead. The webhook listener is a thin passthrough — it receives a request and emits an event. An async framework adds complexity with no benefit.
- Runs a lightweight HTTP server on a configurable port.
- Exposes a configurable path and **required HTTP method** (defaults to `POST`).
- **HMAC signature verification**: each webhook source config block accepts an optional `secret` key. When set, the daemon expects a `X-Hub-Signature-256` header and validates the SHA-256 HMAC of the request body. Requests with missing or invalid signatures are rejected with `401 Unauthorized` and an error-level log entry. This supports GitHub, GitLab, Slack, and any platform using the same scheme.
- No TLS in MVP — operators place a reverse proxy (nginx, Caddy) in front for production TLS termination.
- Rejects wrong HTTP methods (405), unknown paths (404), and unauthenticated requests (401). All rejections include a descriptive log message.

### Event-to-workflow mapping and event context passing

Each event source config block includes one or more `workflows` entries. A workflow entry specifies:
- `path` — the workflow directory or `.ash` script passed to the `ash` CLI.
- `flags` — optional CLI flags passed through (e.g., `--agent opencode:sonnet`, `--yes`).

When an event fires, the daemon spawns `ash <path> <flags>` as a child process. **Event context is passed as environment variables**, not injected into the workflow script:

| Variable | Source type | Value |
|---|---|---|
| `ASH_EVENT_SOURCE` | All | Source type (`folder`, `cron`, `webhook`) |
| `ASH_EVENT_SOURCE_NAME` | All | Configured `name` of the source |
| `ASH_EVENT_FILE` | `folder` | Absolute path of the triggering file |
| `ASH_EVENT_CHANGE` | `folder` | `create`, `modify`, or `delete` |
| `ASH_EVENT_SCHEDULE` | `cron` | The cron expression that matched |
| `ASH_EVENT_REQUEST_BODY` | `webhook` | Full request body as a UTF-8 string (truncated to 64KB; logged as warning if exceeded) |
| `ASH_EVENT_REQUEST_HEADERS` | `webhook` | Key-value headers in `KEY: value\n` format |
| `ASH_EVENT_REQUEST_PATH` | `webhook` | The matched webhook path |
| `ASH_EVENT_TIMESTAMP` | All | ISO 8601 UTC timestamp of the trigger |

Workflows access these via standard env-var reads (e.g., `$ASH_EVENT_FILE` in a shell step). This couples the daemon to nothing — the workflow author chooses whether to use the variables. If the workflow ignores them, it still runs.

### Telemetry relay — resolving the conflicting-consumer problem

**Current state:** The `ash` CLI's telemetry pipeline spawns an in-process remote-consumer thread (`pipeline.rs:116–202`) that calls the no-op `deliver_remote()` (line 205–207). This thread reads from the telemetry JSONL file and maintains an offset marker.

**Problem:** If the daemon also reads the same JSONL file for relay delivery, two processes compete on the same file and the same offset markers, leading to duplicate or missed deliveries.

**Resolution:** The daemon **takes over** the remote delivery role entirely. The CLI's in-process remote consumer thread is left as-is (it is harmless — it runs a no-op loop) because modifying the CLI is out of scope. However, the daemon uses a **separate offset-tracking file** (`<event_path>.offset.daemon.<N>`) that is namespaced from the CLI's markers. This avoids the two processes stepping on each other's offsets.

The daemon config includes a `telemetry.file_path` key that points to the JSONL file (the same one configured in `ash.yml`). When this key is present, the daemon starts a relay thread that:
- Opens the JSONL file and seeks to the last delivered offset.
- Reads new lines, batches them (up to `batch_size`), and delivers to the configured remote adapter.
- Saves the offset on successful delivery.
- Sleeps `flush_interval_ms` between read cycles when there is no new data.

The relay is optional — if no `telemetry` block or no adapter is enabled, the daemon skips it entirely.

### Configuration format

A new YAML file, resolved by convention: `./ash-eventd.yml`, then `~/.ash/ash-eventd.yml`, then `/etc/ash/ash-eventd.yml`. Structure:

```yaml
daemon:
  log_level: info
  ash_bin: ash
  pid_file: /var/run/ash-eventd.pid

sources:
  - type: folder
    name: watch-invoices
    path: /data/incoming
    patterns: ["*.pdf", "*.csv"]
    recursive: true
    events: [create]
    debounce_ms: 500
    workflows:
      - path: ./workflows/process-invoice
        flags: ["--agent", "opencode:sonnet", "--yes"]

  - type: cron
    name: nightly-report
    schedules:
      - "0 2 * * *"       # 2:00 AM daily
    workflows:
      - path: ./workflows/generate-report
        flags: ["--yes"]

  - type: webhook
    name: github-push
    port: 9090
    path: /hooks/github
    method: POST
    secret: "${GITHUB_WEBHOOK_SECRET}"
    workflows:
      - path: ./workflows/ci-pipeline
        flags: ["--yes"]

telemetry:
  file_path: /var/lib/ash/telemetry.jsonl
  kafka:
    enabled: true
    brokers: ["localhost:9092"]
    topic: ash-events
    batch_size: 100
    flush_interval_ms: 5000
```

**Changes from v1 config format:**
- Added `daemon.pid_file` for duplicate-instance detection.
- Added `folder.debounce_ms` (default 500) for file-event deduplication.
- `cron.schedules` is a list (multiple expressions per source).
- Added `webhook.method` (default POST) and `webhook.secret` (optional, for HMAC verification).
- Added `telemetry.file_path` — was missing in v1, making the config unusable without guessing the file location.
- `telemetry_relay` renamed to `telemetry` for brevity.
- Removed `kafka.filter` and `splunk.filter` from the daemon config — the daemon relays all events; filtering is the CLI's responsibility at write time.

### Process lifecycle

- On start: validate config (all sources, all fields). If any source is misconfigured, log all errors and exit non-zero. No partial startup.
- Write PID file before starting sources. If the PID file already exists and the referenced process is still running, log "daemon already running (pid <N>)" and exit with code 2.
- Initialize all sources, join their internal threads/blocks, and run the dispatch loop.
- On SIGTERM/SIGINT: set the shutdown flag (`AtomicBool`), stop accepting new events. Wait for in-flight workflow spawns to complete, with a hard timeout of **30 seconds** (configurable via `daemon.shutdown_timeout_sec`). Flush the telemetry relay batch, unlink the PID file, and exit 0.
- A systemd unit file template is provided but not installed by the build — operators add it to their systemd configuration.

### Language and dependencies

The daemon is written in Rust, matching the existing codebase. New dependencies:

| Crate | Version | Purpose |
|---|---|---|
| `ash` | path = `../ash` | Telemetry types, error types |
| `serde` | 1 | Config deserialization |
| `serde_yaml` | 0.9 | YAML config parsing |
| `log` | 0.4 | Logging facade |
| `env_logger` | 0.11 | Log subscriber |
| `notify` | 7 | Filesystem event watching |
| `cron` | 0.13 | Cron expression parsing |
| `tiny_http` | 0.12 | Lightweight HTTP server |
| `thiserror` | 1 | Error type derivation |

The `rdkafka` or `kafka` crate is deferred until the relay implementation is written — `serde` + `serde_json` alone suffice for the initial relay skeleton, with the actual Kafka delivery call implemented when the adapter is built.

### Trade-offs acknowledged

| Choice | Trade-off |
|---|---|
| Separate binary, not embedded | Higher deploy complexity (two binaries). Worth it for clean separation of concerns and lifecycle independence. |
| Path dependencies, no Cargo workspace | Each crate manages its own `Cargo.lock`. Simpler to introduce, avoids workspace-wide resolver unification that could break existing builds. A workspace can be introduced later as its own task. |
| Event context via env vars, not script injection | Env vars are universal, stateless, and impose zero format requirements on workflows. The trade-off is that values >64KB are truncated (a warning is logged) and binary payloads are not supported. For the MVP, this covers the vast majority of triggers. |
| Daemon takes over telemetry relay, CLI's thread stays as no-op | Clean separation: the CLI's code is untouched, the daemon has a single source of responsibility. The no-op thread in the CLI is a small cost (one thread, sleeps most of the time). A future task can add a config flag to disable the CLI's consumer entirely. |
| `tiny_http` over `actix-web` | No async runtime overhead. The webhook listener is a thin passthrough. |
| No GUI | The idea doc mentions GUI for configuration, but that is a separate project. The config file is declarative YAML; a GUI can layer on top later. |
| Message streams and chat sources deferred | Reduces complexity and dependency surface. The event source abstraction makes adding them later a drop-in. |

### Dependencies on prior work

The `ideas/prioritized-ideas.md` document correctly notes that event-driven execution depends on:
- **DSL flow control (Priority 1)** — event-triggered workflows often need conditional branching based on context. Without DSL flow control, this logic must be embedded in opaque agent prompts.
- **Workflow state (Priority 1)** — long-running event-triggered workflows that crash mid-execution must be resumable, not restartable from scratch.

These are hard prerequisites for full utility. The daemon itself can be built and tested independently, but it will be most valuable after those features land.

---

## Acceptance Criteria

1. **Binary compiles and is standalone.** Running `cargo build` in `ash/ash-eventd/` produces a single binary `ash-eventd` (no shared libraries beyond the system libc). The binary does not depend on any files outside itself except its config file and the `ash` binary on PATH.

2. **Daemon starts cleanly with valid config.** Given a valid `ash-eventd.yml` with at least one source, the daemon starts, logs each initialized source at info level, and writes the PID file. Running `ps` confirms the process is alive. The daemon logs its PID to stdout on startup.

3. **Duplicate instance detection prevents conflicts.** Starting a second `ash-eventd` instance while the first is running produces a single error message on stderr: `"ash-eventd is already running (pid <N>)"` and exits with code 2. The PID file is checked at startup, and the referenced process is verified to still exist (write a 0-byte signal; if the process is dead, stale PID file, proceed normally).

4. **Graceful shutdown on SIGTERM.** Sending `kill -TERM <pid>` causes the daemon to:
   - Log "shutting down" at info level.
   - Stop accepting new events (the channel sender half is dropped by each source).
   - Wait up to 30 seconds for in-flight workflow subprocesses to complete.
   - Log any workflows that failed to complete within the timeout.
   - Exit with code 0.
   - Remove its PID file.

5. **Folder watcher triggers workflows.** When a file matching a configured pattern appears in a watched directory:
   - The daemon logs: `"trigger [watch-invoices] file created: /data/incoming/report.pdf"`.
   - An `ash <path> <flags>` subprocess is spawned.
   - The subprocess inherits `ASH_EVENT_FILE`, `ASH_EVENT_CHANGE`, `ASH_EVENT_SOURCE`, `ASH_EVENT_SOURCE_NAME`, and `ASH_EVENT_TIMESTAMP` in its environment.
   - The daemon logs: `"spawned workflow [./workflows/process-invoice] pid=12345"`.
   - File modification events for the same path within `debounce_ms` (default 500ms) do not produce additional triggers.

6. **Cron scheduler triggers workflows at scheduled times.** Given a source with `schedules: ["* * * * *"]` (every minute), the workflow is spawned within one second of each minute boundary. The daemon logs each trigger with the cron expression and spawned PID. An invalid cron expression in the config causes the daemon to exit during startup validation with a message like: `"source [nightly-report]: invalid cron expression 'bad expr': <crate error message>"`.

7. **Webhook triggers workflows with authentication.** An HTTP POST to the configured endpoint with a valid `X-Hub-Signature-256: sha256=<hex-digest>` header spawns the configured workflow. The daemon logs the request method, source IP, matched path, and spawned PID.
   - A POST to an unknown path returns `404 Not Found` (body: `"no webhook at this path"`).
   - A GET to a POST-only endpoint returns `405 Method Not Allowed` (body: `"method not allowed"`).
   - A POST with an invalid or missing signature when `secret` is configured returns `401 Unauthorized` (body: `"invalid signature"`). The daemon logs an error with the source IP.
   - `ASH_EVENT_REQUEST_BODY` is set to the request body (up to 64KB; truncation logged at warn level).
   - `ASH_EVENT_REQUEST_HEADERS` contains all request headers.

8. **Config validation at startup is atomic.** If any source is misconfigured (missing required field, invalid cron, nonexistent watch directory, port already in use), the daemon logs **all** errors and exits non-zero **before** starting any source. No source is started unless all pass validation. This is the "Surface, Don't Hide" principle — bad config fails fast and visibly.

9. **Telemetry relay delivers to Kafka.** Given a `telemetry` config block with `kafka.enabled: true` and valid `file_path`:
   - The daemon reads new JSONL lines from the file since the last delivered offset.
   - Batches of up to `batch_size` events are serialized and sent to the configured Kafka broker/topic.
   - On successful delivery, the daemon writes a namespaced offset marker (`<file_path>.offset.daemon.<offset>`) that does not conflict with the CLI's markers.
   - On restart, the daemon resumes from the last saved daemon offset.
   - The daemon logs each batch delivery at debug level: `"relay: delivered <N> events to kafka [topic]"`.

10. **Telemetry relay delivers to Splunk.** Same behavior as Kafka, targeting the Splunk HEC endpoint.

11. **Workflow spawn failures do not crash the daemon.** If the `ash` binary cannot be found, the daemon logs: `"spawn failed [watch-invoices]: ash binary not found on PATH"`. If the spawned process exits non-zero, the daemon logs: `"workflow [./workflows/bad-script] pid=12345 exited with status 1"`. In both cases, the daemon continues running and handling subsequent events.

12. **The ash CLI code is not modified.** No changes to `ash/src/main.rs`, the evaluator, the engine, the runtime tree, or any file under `ash/ash/src/`. The daemon is an external consumer of the `ash` binary (via subprocess) and the `ash` library (via cargo dependency for telemetry types only).

---

## Implementation Hints

### Project context

- **No Cargo workspace** — the two existing crates (`ash/ash/`, `ash/ash-wasm/`) are independent, linked by path dependencies. `ash-eventd` follows the same pattern. Its `Cargo.toml` declares `ash = { path = "../ash", default-features = false }` and no `[workspace]` member entry is needed.
- The `ash-wasm` crate uses `crate-type = ["cdylib"]` and depends on `wasm-bindgen`. **Do not copy this pattern** for `ash-eventd`. `ash-eventd` is a standard binary crate with an implicit `crate-type = ["bin"]` (no `[lib]` section needed). The "follow ash-wasm's pattern" guidance from v1 meant the path-dependency approach only — v2 makes this explicit.
- Config loading follows the pattern in `ash/src/config.rs:82–101` — read file, YAML-deserialize into a struct, return a domain object. The daemon's config structs should be separate from `ash.yml`'s `ConfigFile` struct.
- Telemetry types live in `ash/src/telemetry/` — `event.rs` (TelemetryEvent), `store.rs` (FileStore, reader), `offset.rs` (offset save/load), `config.rs` (TelemetryConfig, RemoteAdapterConfig). These are already `pub` and can be imported by `ash-eventd` via the `ash` crate dependency.
- The `AshError` type (`ash/src/error.rs`) is the standard error wrapper for the `ash` library. The daemon should define its own error type using `thiserror` for daemon-specific failures (config validation, source initialization, subprocess errors).

### What NOT to touch

- **Do not modify the `ash` CLI entry point** (`ash/src/main.rs`) or any evaluator/engine/runtime module. The daemon spawns `ash` as a subprocess; it does not link against `main()`.
- **Do not modify the telemetry pipeline** (`ash/src/telemetry/pipeline.rs`). The CLI's in-process remote consumer thread stays as-is (it runs a no-op loop). The daemon uses its own offset file (`<path>.offset.daemon.<N>`) to avoid conflicts with the CLI's markers.
- **Do not modify `ash.yml`** configuration format or `ConfigFile` struct in `ash/src/config.rs`. The daemon has its own separate config file and config structs.
- **Do not create a Cargo workspace.** Adding `[workspace]` to `ash/Cargo.toml` or adding a workspace-level `Cargo.toml` would change build behavior for all crates. This belongs in its own task with its own validation.
- **Do not build a GUI.** The idea doc mentions a GUI for configuration — this is out of scope. A GUI is a separate project that can be built on top of the YAML config format.
- **Do not implement message stream sources (Kafka consumer, MQ listener) or chat-specific integrations.** These are explicitly deferred.
- **Do not modify the `ash-wasm` crate.**

### Existing patterns to follow

- **Crate layout** — the daemon is a flat binary crate (no `[lib]` section unless shared utility modules are needed), structured as:

  ```
  ash/ash-eventd/
    Cargo.toml
    src/
      main.rs           # entry point: parse args, load config, start daemon
      config.rs         # DaemonConfig, SourceConfig, TelemetryRelayConfig, etc.
      error.rs          # DaemonError enum (thiserror)
      sources/
        mod.rs          # EventSource trait, TriggerEvent struct
        folder.rs       # Folder watcher implementation
        cron.rs         # Cron scheduler implementation
        webhook.rs      # HTTP webhook listener implementation
      relay/
        mod.rs          # Telemetry relay orchestrator
        kafka.rs        # Kafka delivery adapter
        splunk.rs       # Splunk delivery adapter
  ```

- **Error handling** — define a `DaemonError` enum using `thiserror`. Config validation errors should be `DaemonError` variants with descriptive messages. The main loop should `use log::error!` for non-fatal errors (workflow spawn failures) and return `DaemonError` for fatal errors (config failures, port conflicts).

- **Logging** — use the `log` crate facade with `env_logger`. Log to stdout. Control via `RUST_LOG` env var and/or the `log_level` config key. Prefix all daemon log messages with the source name in brackets (e.g., `[watch-invoices] file created: ...`).

- **Signal handling** — use the `ctrlc` crate for SIGINT and a raw `libc::signal` registration for SIGTERM (or `signal-hook` if preferred). Set an `Arc<AtomicBool>` that all source threads check on each iteration.

- **Subprocess spawning** — use `std::process::Command` to spawn `ash`. Set env vars via `.env("ASH_EVENT_FILE", path)`. Do not wait on the child — use `.spawn()` and store the `Child` handle. The shutdown phase should check `.try_wait()` on stale handles and `.kill()` + `.wait()` on children that exceed the shutdown timeout.

- **Tests** — the `ash` library uses inline `#[cfg(test)] mod tests`. Follow the same pattern:
  - Unit tests: config parsing (valid/invalid YAML), cron expression parsing, event context env-var construction.
  - Integration tests: end-to-end with real subprocess spawns. These require an `ash` binary on PATH and should be marked `#[ignore]` or gated behind a feature flag `integration`.

### Key architectural notes

- **Event channel** — use `std::sync::mpsc::channel::<TriggerEvent>()`. It is synchronous, in std, and avoids an extra dependency. The main loop calls `rx.recv()` and dispatches to a thread pool for workflow spawning.

- **Thread pool for workflow spawns** — use `std::thread::spawn` for each subprocess. The number of concurrent spawns is naturally bounded by the event rate — if needed, a semaphore or bounded thread pool can be added later, but the MVP can use `thread::spawn` directly (the OS handles process limits).

- **Config validation at startup** — validate all source configurations in a single pass before starting any listener. Collect all errors into a `Vec<String>` and report them together. If the vector is non-empty, print all errors and exit. This is "Surface, Don't Hide."

- **Telemetry relay is optional** — the daemon must function correctly when no `telemetry` block is present or when all adapters are disabled. If a `telemetry` block exists but the `file_path` is missing, log an error and continue without relay (relay is not the daemon's primary function).

- **Offset file namespacing** — the daemon writes offset markers as `<file_path>.offset.daemon.<offset>`. This is a different prefix from the CLI's `<file_path>.offset.<offset>`, ensuring no collisions. An alternative (disabling the CLI's consumer thread) was rejected because it would require modifying the CLI code, which is out of scope.
