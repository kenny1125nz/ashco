# Assessment Report: Event-Driven Workflow Execution Task Definition

**Document reviewed:** `tmp/task-definition_1.md` (261 lines)

---

## Findings

### Critical

1. **Original requirement lists 5 event source types; MVP covers only 3 with no gap analysis.** The idea document (`ideas/event-driven.md:11–17`) explicitly calls out folder, message streams (MQ/Kafka/cloud messaging), webhook, chat-based applications, and cron. The task definition covers folder, cron, and webhook — but **message streams and chat-based sources are dropped entirely with no acknowledgment or rationale**. This is a meaningful scope gap. If they are deferred, the document must state that and explain why. A developer reading both documents would reasonably assume message streams are in scope.

2. **No Cargo workspace exists, contradicting the document's framing.** The task definition refers repeatedly to a "workspace" (line 219: "Existing workspace: `ash/ash/` ... `ash/ash-wasm/`"), but the codebase has no `[workspace]` manifest. `ash-wasm` is an independent crate using a path dependency. This matters because adding `ash-eventd` requires either creating a workspace for the first time or following the `ash-wasm` path-dependency pattern — two different approaches with different build implications. The document should specify which one.

### Major

3. **Telemetry relay design has a conflicting-consumer problem.** The `ash` CLI already runs a background remote-consumer thread (`pipeline.rs:172, 189`) that calls `deliver_remote()`. The task definition says (line 227): "The existing in-process remote consumer thread can remain as-is; the daemon replaces its role rather than extending it." These two statements contradict each other. If the daemon takes over delivery, the CLI's in-process thread is wasted work (spinning, reading the same file, calling a no-op stub). If the CLI's thread is left running, there are two readers competing on the same JSONL file. The document needs to resolve this — either disable the CLI's remote consumer when the daemon is present, or acknowledge the duplication and provide a coordination mechanism.

4. **Event data is discarded — this undermines the human-in-the-loop use case.** The original idea mentions "add human steps in the process" (line 4) and lists event sources like chat-based apps that imply the event payload matters. The task definition explicitly (line 177) states: "Event data (file path, webhook body) is logged by the daemon but not passed to the workflow." For a webhook from GitHub or a chat platform, the event payload (branch name, PR number, chat message) is essential for the workflow to do anything useful. The trade-off table frames this as avoiding coupling, but for webhooks and message streams it's a capability gap that makes the feature significantly less useful. A future-env-var injection note is not enough — this should be in the MVP design or explicitly called out as a hard limitation with a concrete mitigation plan.

5. **Acceptance criteria are not independently testable.** Criteria like "Daemon starts and stops cleanly" (AC #2) and "Workflow spawn failures are surfaced" (AC #9) describe desired behavior but lack concrete pass/fail conditions. For example: what constitutes "graceful shutdown"? How long is the grace period (mentioned on line 156 but never specified)? How is "clear error message" defined for duplicate instance detection? ACs should be specific enough that a reviewer can determine pass/fail without interpretation.

6. **Offset tracking design assumes single-reader access.** The daemon reads the telemetry JSONL file using the same offset-tracking mechanism as the in-process consumer (`offset.rs`). But offsets are stored as sidecar marker files, and two processes reading the same file independently will step on each other's offsets. The task definition does not address whether the CLI's remote consumer should be disabled or how to coordinate.

### Minor

7. **Cron timing resolution is unspecified.** The document says "evaluates a cron expression on a timer tick" but never specifies the tick interval. One-second resolution vs. 30-second resolution has very different implications for scheduling precision and CPU usage. This is an implementation detail a developer would have to guess.

8. **No authentication or secret management discussed for webhooks.** Line 86 says "No TLS in MVP; operators place a reverse proxy in front." Fair. But there is no discussion of HMAC signature verification (which GitHub, Slack, and most platforms require), no shared-secret configuration key, no mechanism to reject unauthenticated requests. Without this, the webhook listener is either insecure or unusable with real platforms — neither is acceptable for an "enterprise" feature.

9. **Config file format lacks a `telemetry_relay.file_path` key.** The daemon config (lines 142–148) defines Kafka/Splunk adapter settings but never specifies where the telemetry JSONL file lives. The document says (line 151) "the operator must ensure [the file path] matches between both configs," but the daemon config has no field for the file path. This gap means the daemon must either hardcode the path or assume it's the same as `ash.yml`'s — both fragile approaches.

10. **The `ash-wasm` crate layout reference is incomplete.** The Implementation Hints (line 233) say "follow `ash-wasm`'s pattern," but `ash-wasm` is a `cdylib` with WASM-specific build configuration (`crate-type`, `wasm-bindgen`). A daemon binary would use `crate-type = ["bin"]` and has none of those concerns. The Cargo.toml template (lines 234–249) correctly shows `ash-eventd` as a binary, but the guidance to "follow `ash-wasm`'s pattern" is misleading.

---

## Strengths

1. **Architectural rationale is clear and honest.** The core decision to build a separate daemon is well-argued with specific trade-offs (lifecycle independence, dependency isolation, operator control). The trade-off table (lines 173–179) is excellent — it acknowledges downsides rather than pretending every choice is optimal. This is the kind of design thinking the rubric demands.

2. **Codebase references are accurate and specific.** Line numbers, file paths, and type names all match the actual codebase (verified against `pipeline.rs:204–207`, `config.rs:11–13/28–39/82–101`, `error.rs`, `telemetry/` module structure, `main.rs`). The document demonstrates genuine familiarity with the existing code.

3. **"What NOT to touch" section is precise and valuable.** Lines 224–229 enumerate exactly which modules are off-limits and why. This is the most actionable part of the document and the kind of guardrail that prevents scope creep during implementation.

4. **Dependencies on prior work are honestly acknowledged.** The document correctly calls out that DSL flow control and workflow state are hard prerequisites (lines 183–187) and doesn't try to hide or downplay this dependency. This prevents an implementer from building something that can't be used.

5. **Event source abstraction is well-designed.** The common trait approach with independent cancellation per source (lines 56–61) is clean and extensible. It naturally accommodates future source types without restructuring. The use of `std::sync::mpsc` over an external crate avoids unnecessary dependencies.

6. **Config validation philosophy is correct.** "All sources or nothing" (line 260) and "Surface, Don't Hide" are the right principles for a daemon. Partial startup would be a debugging nightmare.

7. **Document structure is excellent.** Background → Intended Solution → Acceptance Criteria → Implementation Hints is the logical flow. Each section builds on the previous one. The configuration example (lines 111–149) is concrete and immediately useful.

---

## Score Breakdown

| Dimension | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Scope discipline | 5/10 | 25% | 12.5 |
| Design quality | 7/10 | 25% | 17.5 |
| Actionability | 7/10 | 20% | 14.0 |
| Context awareness | 8/10 | 15% | 12.0 |
| Implementation Hints | 9/10 | 15% | 13.5 |
| **Total** | | | **69.5** |

**SCORE: 70**

The document is strong on codebase awareness, has a solid core architecture, and provides genuinely useful implementation guardrails. It is undermined by an unacknowledged scope gap (missing two of five event source types from the original idea), a contradictory telemetry relay design (two consumers competing on one file), and the puzzling decision to discard webhook/event payloads which makes the feature far less useful for the enterprise orchestration use case it targets. Addressing the three critical findings would bring this into the 85+ range.
