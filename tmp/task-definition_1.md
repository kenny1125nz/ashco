# Event-Driven Workflow Execution — Task Definition

## Background

Ash workflows today are triggered exclusively by a user running the `ash` CLI with a directory path, script file, or REPL command. This is fine for interactive use, but it means there is no path to automated, unattended workflow execution. The idea document `ideas/event-driven.md` identifies this gap and calls event-triggered execution "a must for enterprise level orchestration."

The project already has:

- **A telemetry pipeline** (`ash/ash/src/telemetry/pipeline.rs`) that writes events to a local JSONL file and spawns a remote-consumer background thread with a placeholder `deliver_remote()` function. The config structures already define Kafka and Splunk adapters (`telemetry/config.rs:11–13`), but delivery is stubbed.
- **A config system** (`ash/ash/src/config.rs`) built around `ash.yml` with YAML-deserialized structs for agents and telemetry.
- **Two existing crates** in the `ash/` directory: the `ash` binary/library and `ash-wasm`. A new sibling crate is a natural fit.
- **A prioritization** in `ideas/prioritized-ideas.md` that ranks event-driven execution at Priority 2 (after DSL improvements and workflow state) and flags it as "a large architectural expansion (new daemon application)."

The idea document itself asks the key architectural question: should the event-listening logic be inside Ash, or should it be a separate application? It leans toward a separate daemon that can also serve as the relay layer between async applications and the telemetry data store.

This task definition answers that question and designs the solution.

---

## Intended Solution

### Core decision: a separate daemon binary (`ash-eventd`)

The event trigger layer will be a **new binary** — not embedded in the `ash` CLI. It will be a sibling crate at `ash/ash-eventd/` living alongside `ash/ash/` and `ash/ash-wasm/`.

**Rationale for separation:**

- The `ash` CLI is a short-lived, user-invoked process. A daemon has opposite characteristics: long-lived, signal-driven, never exits unless explicitly stopped. Conflating them would complicate the CLI's lifecycle (every `ash` invocation would need to check whether it's "the daemon" or "a workflow run") and muddy error handling.
- The daemon's dependency set differs from the CLI. It needs filesystem watchers, an HTTP server, and a cron parser — none of which belong in a command-line orchestrator.
- A separate process enables independent lifecycle management: operators can start, stop, or restart the daemon without affecting workflow runs already in progress.
- The idea doc itself proposes this. The tool also can serve the telemetry relay role without coupling telemetry concerns further into the main binary.

### How it works at a high level

```
                +------------------+
                |   ash-eventd     |
                |   (daemon)       |
                |                  |
 file-system  -->  folder watcher --+
   webhook   -->  http listener  --+--> spawn "ash <workflow>" --> ash CLI
 cron tick   -->  scheduler      --+
                |                  |
 telemetry   <--  relay thread   <-- reads ash-telemetry.jsonl --> kafka/splunk
                +------------------+
```

The daemon has three responsibilities:

1. **Listen for external events** from configured sources.
2. **Invoke workflow runs** by spawning the `ash` binary with the configured workflow path and options.
3. **Ship telemetry** to remote sinks by consuming the local JSONL file that the `ash` CLI's telemetry pipeline appends to.

### Event source abstraction

Event sources are configured declaratively in YAML. Each source type (folder, webhook, cron) implements a common trait that:
- Starts listening on daemon startup.
- Sends triggered events through a shared channel (e.g., `crossbeam::channel` or `std::sync::mpsc`).
- Is independently cancellable (each gets its own shutdown signal).

The daemon main loop receives events from the shared channel and dispatches them to workflow spawns.

### Event source types — MVP scope

**Folder watcher (`folder`)**

- Watches a directory (recursively or not, configurable per source).
- Emits an event when a file matching a glob pattern is created, modified, or deleted.
- Each event carries the file path and the change kind.
- Uses `notify` crate (cross-platform, well-maintained, 5+ years of maturity).
- Suitable for: watch a drop folder for new data files, then run a processing workflow.

**Cron scheduler (`cron`)**

- Evaluates a cron expression on a timer tick.
- When the expression matches the current time, emits an event.
- Uses a cron-parsing crate (the `cron` crate is the standard choice in Rust).
- Suitable for: nightly report generation, periodic health checks, scheduled deployments.

**Webhook listener (`webhook`)**

- Runs a lightweight HTTP server on a configurable port.
- Exposes a configurable endpoint path (e.g., `POST /hooks/github-push`).
- On receiving a request, emits an event with the request body, headers, and query parameters passed through as event context.
- Uses `tiny_http` or `actix-web` — preference for `tiny_http` (minimal dependencies, synchronous, fits the daemon use case).
- No TLS in MVP; operators place a reverse proxy in front for production use.
- Suitable for: GitHub webhooks, CI/CD pipeline triggers, chat-ops bots (via outbound webhook from chat platforms).

### Event-to-workflow mapping

Each event source config block includes one or more `workflows` entries. A workflow entry specifies:
- `path` — the workflow directory or .ash script to pass to the `ash` command.
- `flags` — optional CLI flags passed through to `ash` (e.g., `--agent opencode:sonnet`, `--yes`).

When an event fires from a source, the daemon spawns `ash <path> <flags>` as a child process. The daemon does **not** parse the workflow, inject variables into it, or make decisions based on event payload. Those concerns belong to the workflow itself (which handles conditional logic via DSL flow control, when that feature is available).

### Telemetry relay

The daemon consumes the local telemetry JSONL file (same path configured in `ash.yml`'s telemetry section) and delivers events to remote sinks. This replaces the in-process `deliver_remote()` placeholder in `pipeline.rs:205–207` with a real implementation that lives in the daemon.

The existing telemetry pipeline in the `ash` CLI continues to write to the file — no changes needed there. The daemon picks up from where the in-process consumer left off:

- Uses the same offset-tracking mechanism already defined in `telemetry/offset.rs`.
- Reads new lines from the JSONL file, batches them, and delivers to Kafka or Splunk as configured.
- Batch size and flush interval are configurable per remote adapter (these config keys already exist in `telemetry/config.rs:28–39`).

### Configuration format

A new YAML file, resolved by convention: `./ash-eventd.yml`, then `~/.ash/ash-eventd.yml`. Structure:

```yaml
daemon:
  log_level: info          # trace/debug/info/warn/error
  ash_bin: ash             # path or command name to invoke workflows

sources:
  - type: folder
    name: watch-invoices
    path: /data/incoming
    patterns: ["*.pdf", "*.csv"]
    recursive: true
    events: [create]
    workflows:
      - path: ./workflows/process-invoice
        flags: ["--agent", "opencode:sonnet", "--yes"]

  - type: cron
    name: nightly-report
    schedule: "0 2 * * *"  # 2:00 AM daily
    workflows:
      - path: ./workflows/generate-report
        flags: ["--yes"]

  - type: webhook
    name: github-push
    port: 9090
    path: /hooks/github
    workflows:
      - path: ./workflows/ci-pipeline
        flags: ["--yes"]

telemetry_relay:
  kafka:
    enabled: true
    brokers: ["localhost:9092"]
    topic: ash-events
    batch_size: 100
    flush_interval_ms: 5000
```

The daemon config is **separate from** `ash.yml` because it governs a different process with different concerns. The only coupling point is the telemetry JSONL file path, which the operator must ensure matches between both configs.

### Process lifecycle

- The daemon starts, reads its config, initializes all event sources, and runs until it receives SIGTERM or SIGINT.
- On shutdown, it stops accepting new events, waits for in-flight workflow spawns to complete (with a configurable grace-period timeout), then flushes the telemetry relay batch and exits.
- A PID file is written on startup to prevent duplicate instances and to support init scripts / systemd integration.

### Language and dependencies

The daemon is written in Rust, matching the existing codebase. New dependencies required (approximate):
- `notify` — filesystem events
- `cron` — cron expression parsing and scheduling
- `tiny_http` — lightweight HTTP server for webhooks
- `serde`, `serde_yaml` — config parsing (already in the workspace)
- `log` + `env_logger` — structured logging (log already in the workspace)
- `rdkafka` or `kafka` crate — for Kafka delivery (telemetry relay)

The daemon can (and should) share the `ash` library crate for the telemetry types (`TelemetryEvent`, `FileStore`, offset tracking) and error types. No changes are required to the `ash` library for this sharing to work — the relevant modules are already `pub` and the crate is already a dependency of `ash-wasm`.

### Trade-offs acknowledged

| Choice | Trade-off |
|--------|-----------|
| Separate binary, not embedded | Slightly higher deploy complexity (two binaries). Worth it for cleaner separation of concerns and lifecycle independence. |
| File-based config, not centralized store | Idea doc mentions "centralized store for configs" as future work. File-based is sufficient for MVP and avoids building a database-backed config service before knowing the shape of the problem. |
| No event payload injection into workflows | Event data (file path, webhook body) is logged by the daemon but not passed to the workflow. The workflow can read the source (file, HTTP endpoint) independently. This avoids coupling the daemon to workflow internals. A future iteration could inject event context as environment variables or a temp file. |
| `tiny_http` over `actix-web` | No async runtime overhead. The webhook listener is a thin passthrough — it takes a request and emits an event. An async framework would add complexity with no benefit. |
| No GUI | The idea doc mentions GUI for configuration, but that is a separate project (Priority 4 or unprioritized). The config file is declarative YAML; a GUI can layer on top later. |

### Dependencies on prior work

The `ideas/prioritized-ideas.md` document correctly notes that event-driven execution depends on:
- **DSL flow control (Priority 1)** — event-triggered workflows will often need conditional branching based on context (e.g., "if this is a push to `main`, run the deploy workflow; otherwise, just run tests"). Without DSL flow control, this logic must be embedded in opaque agent prompts.
- **Workflow state (Priority 1)** — long-running event-triggered workflows that crash mid-execution must be resumable, not restartable from scratch.

These are hard prerequisites. The daemon itself can be built and tested independently, but it will be most valuable after those features land.

---

## Acceptance Criteria

1. **Binary exists** — `ash-eventd` compiles and produces a standalone binary from `ash/ash-eventd/`.

2. **Daemon starts and stops cleanly** — starting the daemon with a valid config file initializes all configured sources. Sending SIGTERM performs a graceful shutdown (waits for in-flight spawns, flushes telemetry, exits 0). Running a second instance while one is active is detected (PID file) and fails immediately with a clear error message.

3. **Folder watcher triggers workflows** — when a file matching a configured pattern appears in a watched directory, the daemon spawns `ash <configured-path> <configured-flags>` as a child process. The daemon logs the event (source name, file path, spawned PID).

4. **Cron scheduler triggers workflows** — a source configured with a cron expression spawns the workflow at the scheduled times. The daemon logs each scheduled trigger.

5. **Webhook triggers workflows** — an HTTP POST to the configured endpoint spawns the configured workflow. The daemon logs the request method, source IP, and spawned PID. Invalid HTTP methods or paths are rejected with appropriate status codes (e.g., 404 for unknown paths, 405 for wrong method).

6. **Configuration is validated at startup** — missing required fields, invalid cron expressions, non-existent watch directories, or port conflicts are detected at startup and the daemon exits with a descriptive error message. No partial startup (all sources or nothing).

7. **Telemetry relay delivers to Kafka** — when a `kafka` remote adapter is configured and enabled, the daemon reads new events from the local JSONL file and delivers them to the configured Kafka broker/topic. Offset tracking resumes from the last delivered position on restart.

8. **Telemetry relay delivers to Splunk** — when a `splunk` remote adapter is configured and enabled, events are delivered to the configured Splunk HEC endpoint (or equivalent). Same offset-tracking behavior as Kafka.

9. **Workflow spawn failures are surfaced** — if the `ash` binary cannot be found or the spawned workflow exits with a non-zero code, the daemon logs an error-level message including the source name, workflow path, and exit status. The daemon itself does not crash or exit on a single workflow failure.

10. **Does not touch the `ash` CLI code** — no changes are required in `ash/ash/src/main.rs`, the evaluator, the engine, the runtime tree, or the existing telemetry pipeline (except possibly making internal types `pub` if they aren't already — and only when a new use case demands it).

---

## Implementation Hints

### Project context

- Existing workspace: `ash/ash/` (main CLI + library), `ash/ash-wasm/` (WASM binding). The new crate goes at `ash/ash-eventd/`.
- Config loading follows the pattern in `ash/ash/src/config.rs:82–101` — read file, YAML-deserialize into a struct, return a domain object.
- Telemetry types live in `ash/ash/src/telemetry/` — `event.rs` (TelemetryEvent), `store.rs` (FileStore, reader), `offset.rs` (offset save/load), `config.rs` (TelemetryConfig, RemoteAdapterConfig). These are already `pub` and can be imported by the daemon crate via `ash = { path = "../ash" }`.
- The `AshError` type (`ash/ash/src/error.rs`) is the standard error wrapper. The daemon should define its own error type for daemon-specific failures (config validation, source initialization, etc.).

### What NOT to touch

- **Do not modify the `ash` CLI entry point** (`ash/ash/src/main.rs`) or any evaluator/engine/runtime module. The daemon is an external consumer of the `ash` binary via subprocess, and an external consumer of the telemetry file via the store reader. It does not link against the CLI or call `main()`.
- **Do not modify the telemetry pipeline** (`ash/ash/src/telemetry/pipeline.rs`) beyond possibly making fields or methods `pub` if needed for the daemon to read the store. The existing in-process remote consumer thread can remain as-is; the daemon replaces its role rather than extending it.
- **Do not modify `ash.yml`** configuration format or the `ConfigFile` struct in `ash/ash/src/config.rs`. The daemon has its own separate config.
- **Do not build a GUI.** The idea doc mentions "manual configuration can be tedious that we might need a gui" — this is out of scope for this task. A GUI is a separate project and can be built on top of the YAML config format.

### Existing patterns to follow

- **Crate layout** — follow `ash-wasm`'s pattern of depending on the `ash` library via path dependency. The daemon's `Cargo.toml` should look like:
  ```toml
  [package]
  name = "ash-eventd"
  version = "0.1.0"
  edition = "2021"

  [dependencies]
  ash = { path = "../ash", default-features = false }
  serde = { version = "1", features = ["derive"] }
  serde_yaml = "0.9"
  log = "0.4"
  env_logger = "0.11"
  notify = "7"
  cron = "0.13"
  tiny_http = "0.12"
  ```

- **Error handling** — the `ash` library uses `thiserror` for `AshError`. The daemon should define its own error enum using `thiserror` as well. Config validation errors should be `thiserror` variants with descriptive messages.
- **Logging** — the `ash` library uses the `log` crate facade. The daemon should use `env_logger` (or a similar simple subscriber) and log to stdout, controlled by a `RUST_LOG` environment variable and/or the `log_level` config key.
- **Signal handling** — use `ctrlc` crate or raw `signal_hook` for SIGTERM/SIGINT. The shutdown path should set an `AtomicBool` that all source threads check on each loop iteration.
- **Tests** — the `ash` library uses inline `#[cfg(test)] mod tests` with temporary files. Follow the same pattern. Integration tests can test config parsing, cron expression evaluation, and telemetry relay offset behavior. End-to-end workflow spawn tests require an `ash` binary on PATH and should be marked with `#[ignore]` or behind a feature flag.

### Key architectural notes

- **Event channel** — use `std::sync::mpsc` for the event channel (synchronous, already in std, avoids an extra dependency). The daemon main loop blocks on `rx.recv()` and spawns workflows from a thread pool to keep the loop responsive.
- **Thread pool for workflow spawns** — the `ash` library already depends on `threadpool`. The daemon can reuse it (or use `rayon` if preferred, but `threadpool` keeps the dependency footprint smaller).
- **Config validation at startup** — validate all source configurations before starting any listener. If any source is misconfigured, log the errors and exit. Do not start some sources while others fail — this is the "Surface, Don't Hide" principle in action.
- **Telemetry relay is optional** — the daemon must function correctly when no remote telemetry adapter is configured (i.e., no `telemetry_relay` section in the config). The relay is a bonus feature, not the reason the daemon exists.
