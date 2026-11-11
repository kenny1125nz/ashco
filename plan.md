# Plan: `teams/` — Ash-Orchestrated Company Model

## Concept

The `cycles/` folder defines 5 nested cycles modeling a software company's operation. `teams/` turns these into an **executable Ash task tree** — runnable with `ash teams/`.

Each cycle → numbered sub-directory. Each phase → numbered file. `.ash` scripts handle orchestration (parallelism, conditionals). `.md` files are agent prompts for each phase.

## Proposed Structure

```
teams/
├── ash.yml                              # Ash config
├── 01-strategic-cycle/
│   ├── 01-direction-setting.md          # Vision, OKRs, budget
│   ├── 02-orchestrate-sub-cycles.ash    # Runs 02/04/05 in parallel
│   └── 03-review.md                     # Outcomes vs OKRs
├── 02-product-cycle/
│   ├── 01-discover.md                   # Research, interviews
│   ├── 02-define.md                     # PRD, roadmap, metrics
│   ├── 03-design.md                     # Wireframes, prototypes
│   ├── 04-execute.ash                   # Delegates to dev cycle
│   └── 05-observe.md                    # Analytics, outcomes
├── 03-development-cycle/
│   ├── 01-tech-design.md                # Architecture, ADR
│   ├── 02-build.md                      # Code, review, tests
│   ├── 03-test.md                       # Integration, security
│   ├── 04-deploy.md                     # Staging, production
│   └── 05-observe.md                    # Velocity, incidents
├── 04-launch-marketing-cycle/
│   ├── 01-plan.md                       # Strategy, messaging
│   ├── 02-execute.md                    # Content, outreach
│   └── 03-measure.md                    # Attribution, ROI
├── 05-operations-cycle/
│   ├── 01-triage.md                     # Categorize, prioritize
│   ├── 02-resolve.md                    # Troubleshoot, hotfix
│   └── 03-feed-back.md                  # Insights to Product
└── full-cycle.ash                       # Top-level runner
```

## Orchestration Logic

- **`full-cycle.ash`** → runs `do @"01-strategic-cycle/"`
- **`01/02-orchestrate-sub-cycles.ash`** → `wait { do @"02-product-cycle/" do @"04-launch-marketing-cycle/" do @"05-operations-cycle/" }`
- **`02/04-execute.ash`** → `do @"../03-development-cycle/"`

## Ash Features Used

| Feature | Usage |
|---|---|
| Directory mode (`ash teams/`) | Walks entire task tree |
| Numeric prefix | Phase ordering within cycles |
| `.md` task files | Phase prompts with YAML frontmatter |
| `.ash` script files | Orchestration, control flow |
| `wait { }` | Parallel sub-cycle execution |
| `do @"path/"` | Delegate to sub-cycle directory |
| `evaluate { } by ...` | Quality gates between phases |

## Implementation Order

1. `ash.yml` — config
2. `03-development-cycle/` — linear, no sub-delegation
3. `02-product-cycle/` — delegates to dev
4. `04-launch-marketing-cycle/` — standalone
5. `05-operations-cycle/` — standalone
6. `01-strategic-cycle/` — orchestrates all sub-cycles
7. `full-cycle.ash` — top-level entry point
