## workflow config need be hardened
We have following spec when spawning new ash process:
Each event source config block specifies one or more `workflows` entries. When an event fires, the daemon spawns `ash <path> <flags>` as a child process with env vars for event context:

| Variable              | Contents                                                       |
| --------------------- | -------------------------------------------------------------- |
| `ASH_EVENT_SOURCE`    | source name from config                                        |
| `ASH_EVENT_PATH`      | path to the event content folder (always a directory)          |
| `ASH_EVENT_ID`        | unique event id (for dedup and idempotency)                    |
| `ASH_EVENT_TIMESTAMP` | ISO 8601 timestamp of event receipt                            |
| `ASHD_WS_URL`         | ashd's WebSocket address for telemetry (fast path, skips mDNS) |



Current workflow config looks like this:
```yaml
sources:
  - type: folder
    name: watch-invoices
    path: /tmp/ashd-test/incoming
    concurrency: parallel
    workflows:
      - path: ./workflows/process-invoice
        flags: ["--agent", "opencode", "--yes"]
```

the workflow could just be one command  of 
```yaml
    workflows:
      - command: ash --agent opencode $ASH_EVENT_PATH  # the ASH_EVENT_PATH is the task content, each file is a task prompt?  seems lost the meaning of workflow, it is expecting the "workflow" sent as unit into the listening path
      # or 
      - command: ash --agent opencode --yes /xxx/xxx/process_invoice.ash  
      # or 
      - command: ash --agent opencode --yes /xxx/xxx/process-invoice   
```

These are all valid scenarios, while ash is more ready for the first scenario. the later two requires will rely on those implicity env vars  .

