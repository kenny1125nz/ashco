# Solo Founder Process — Minimalizing the Strategic Cycle

This document captures our thinking on adapting the full-company process model (`cycles/`) to a **one-person company** where the founder is CEO, product manager, designer, developer, tester, marketer, and support — all at once.

---

## 1. The Original Model (`cycles/`)

The `cycles/` documents model a full software company's end-to-end activities as nested cycles:

```
Strategic Cycle (quarterly)
├── Product Cycle (monthly)
│   ├── Discover → Define → Design → Execute → Observe
│   └── Development Cycle (weekly sprints, inside Execute)
│       ├── Tech Design → Build → Test → Deploy → Observe
├── Launch & Marketing Cycle (per release)
│   └── Plan → Execute → Measure
└── Operations / Support Cycle (continuous)
    └── Triage → Resolve → Feed Back
```

**~20 phases** across 5 cycles. Each phase has defined: participants, inputs/outputs, AI suitability, methodology, KPIs, key decisions, human input requirements, and cross-cycle I/O signals.

This is the **ideal** — a fully-staffed company with role specialization, governance, and formal process.

---

## 2. Why the Original Model Doesn't Fit One Person

When all roles collapse to one founder:

| Dimension | Full Company | Solo Founder |
|---|---|---|
| Decision-making | Multi-stakeholder deliberation | One person decides |
| Role separation | Director ≠ PM ≠ Dev ≠ Tester | All roles = same person |
| Implementation speed | Weeks per feature (coordination) | Hours/days with AI |
| Process overhead | High (sign-offs, handoffs) | Everything costs founder time |
| Key risk | Misalignment between roles | Skipping non-dev activities (learning, marketing, ops) |
| Quality gates | Formal reviews, evaluate blocks | Founder's own judgment |

The current `strategic-cycle/` implementation (~40 files, 18 virtual role profiles, 5 evaluate quality gates) assumes multiple AI agents role-playing distinct personalities. For a one-person company, this is pure overhead.

---

## 3. The Five Principles for a Solo Founder Process

### 3.1 Direction is the Gate

Direction is the **start of the strategic cycle**. It's guided by:
- **Vision** — what problem are we solving and why
- **Market feedback** — what users say (from marketing cycle)
- **Competition context** — what others are doing
- **Founder's judgment** — intuition, taste, conviction

It decides **what we do and what we don't do**. Every activity downstream (product, marketing, operations) is guided by this direction. Without explicit direction setting, a solo founder drifts — building whatever seems interesting rather than what needs to be built.

Direction setting **IS** the review. It reads accumulated outputs from the previous cycle's marketing and operations to inform the next set of priorities. There is no separate review phase — the next direction setting absorbs it.

### 3.2 Product/Dev, Marketing, Operations Are Continuous

These are not one-time phases. They are **continuous (in theory infinite) running cycles** toward the vision.

- **Product/Dev** does not end after one feature. It builds features continuously, releasing as each one is ready.
- **Marketing** is not a one-time launch. It's continuously posting information to communities, collecting feedback, and tracking metrics.
- **Operations** is not a periodic cleanup. It's continuously monitoring systems, processing issues, and providing input back into the product cycle.

Each run of `ash strategic-cycle/` produces **one pulse** of these continuous cycles. They can be run on any cadence — daily, weekly, per-feature, per-incident. The frequency is up to the founder.

### 3.3 Launch Is Continuous Releases, Not an Event

There is no separate "launch phase." Launching is simply shipping — each completed feature is released when it's ready. Marketing is the continuous activity of telling the world what exists and collecting feedback. There is no "launch day" — there are only release cadences.

### 3.4 Operations Is Metrics-Driven and Feeds Product

Operations is guided by key metrics (availability, error rates, response times). It continuously:
- Monitors system health against those metrics
- Processes issues: triage, fix, escalate
- Provides input into the product cycle: recurring bugs are feature gaps, usage friction is UX debt

### 3.5 AI Makes Implementation Fast; Direction and Judgment Matter Most

With AI-assisted development, implementation speed can be **very fast** — especially for a one-person maintained codebase where the same person writes, tests, and ships. What becomes vital:

- **Product direction** — is this the right thing to build? (from direction setting + research)
- **Judgment** — trade-offs, priorities, scope decisions
- **User experience** — does this actually solve the problem for real people?
- **Market awareness** — is anyone finding and using this?

These are **inputs to the product cycle**, not afterthoughts. The product cycle starts with research that considers UX, user needs, market feedback, and operational insights — then builds.

---

## 4. The Refined Model

```
strategic-cycle/
│                                  ←─ vision.md (static reference)
│                                  ←─ competition.md (static reference)
│
├── 01-direction.md                # Periodic: review + set direction
│                                  #   Reads: workspace/02-marketing/feedback.md
│                                  #   Reads: workspace/02-operations/issues.md
│                                  #   Reads: workspace/02-product/shipped/release-log.md
│                                  #   Decides: what to build this cycle, what to skip
│                                  #   Writes: workspace/01-direction/focus.md
│
├── 02-product/                    # Continuous: build features (parallel with marketing + ops)
│   ├── 01-research.md             #   Research + UX + direction input → feature briefs
│   │                              #   Reads: workspace/01-direction/focus.md
│   │                              #   Reads: workspace/02-marketing/feedback.md
│   │                              #   Reads: workspace/02-operations/issues.md
│   │                              #   Writes: workspace/02-product/01-research/
│   │                              #   Writes: workspace/02-product/01-research/feature-briefs/*.md
│   │
│   ├── 02-spec.md                 #   Define what to build + success criteria
│   │                              #   Writes: workspace/02-product/02-spec/spec.md
│   │
│   ├── 03-execute.ash             #   Loop over feature-briefs/*.md → run dev/ for each
│   │                              #   For each feature: code + test + ship
│   │
│   └── dev/                       #   Per-feature build (no prefix — invoked by execute.ash)
│       ├── 01-build.md            #     Implement with AI, write tests
│       └── 02-ship.md             #     Deploy to production, update release log
│
├── 02-marketing/                  # Continuous: tell the world, collect feedback
│   ├── 01-post.md                 #   Post content to communities
│   │                              #   Writes: workspace/02-marketing/post-log.md
│   │
│   └── 02-collect.md              #   Gather feedback, metrics, community responses
│                                  #   Writes: workspace/02-marketing/feedback.md
│
├── 02-operations/                 # Continuous: monitor, fix, feed back
│   ├── 01-monitor.md              #   Check system health against key metrics
│   │                              #   Writes: workspace/02-operations/health.md
│   │
│   └── 02-resolve.md              #   Triage + fix issues, escalate to product if recurring
│                                  #   Writes: workspace/02-operations/issues.md
│
└── 03-direction.md                → absorbed into 01-direction.md (no separate review)
```

### Key Design Decisions

**No separate review phase.** `01-direction.md` IS the review. Each time it runs, it reads the accumulated outputs from the previous cycle's marketing, operations, and product activities. It adjusts priorities based on what happened. The next cycle starts fresh.

**Launch is `dev/02-ship.md` + `marketing/01-post.md`.** Shipping a feature (dev/ship) and telling people about it (marketing/post) are distinct but continuous activities. No big launch event — just steady releases and steady community presence.

**Marketing and operations feed product.** Both write outputs that `02-product/01-research.md` reads. This closes the loop: what users say → what to build next, what breaks → what to fix or redesign.

**Product research starts with direction, UX, and external signals.** Research doesn't happen in a vacuum — it reads the direction (what are we focusing on?), marketing feedback (what do users want?), and operational issues (what's broken?). Then it produces feature briefs.

### Workspace Data Flow

```
workspace/
├── 01-direction/
│   └── focus.md                        # ← 01-direction.md: what to build this cycle
│
├── 02-product/
│   ├── 01-research/
│   │   ├── research-notes.md           # ← 01-research.md: findings
│   │   └── feature-briefs/             # ← 01-research.md: one .md per feature
│   │       ├── feature-login.md        #     ← looped by 03-execute.ash
│   │       └── feature-dashboard.md
│   ├── 02-spec/
│   │   └── spec.md                     # ← 02-spec.md: what to build + criteria
│   └── shipped/
│       └── release-log.md              # ← dev/02-ship.md: what was deployed
│
├── 02-marketing/
│   ├── post-log.md                     # ← 01-post.md: what was posted where
│   └── feedback.md                     # ← 02-collect.md: community responses, metrics
│
├── 02-operations/
│   ├── health.md                       # ← 01-monitor.md: system metrics
│   └── issues.md                       # ← 02-resolve.md: bugs found, fixes applied
│
├── vision.md                           # Static: company vision (read by 01-direction)
└── competition.md                      # Static: competitive landscape notes
```

### How It Runs

```
$ ash strategic-cycle/
```

Each run produces one pulse of the continuous cycles:

1. `01-direction.md` reviews previous outputs, sets focus for this cycle
2. `02-product/`, `02-marketing/`, `02-operations/` run in parallel (tree walker)
3. Product research reads direction + marketing + ops → produces feature briefs
4. Product spec refines briefs into specs
5. Product execute loops over features → builds + ships each one
6. Marketing posts content, collects feedback
7. Operations monitors health, resolves issues

Run it again next cycle. `01-direction.md` picks up what changed.

### What Was Removed

| Removed | Why |
|---|---|
| 18 role profiles (directors/, researchers/, developers/, reviewers/) | One person, no multi-agent role-play |
| 5 evaluate quality gates | Founder decides done-ness |
| Multi-agent .ash scripts (for-loops over profiles) | Replaced with single-prompt .md files |
| `01-direction-setting/` (multi-agent board session) | → `01-direction.md` (single prompt) |
| `02-launch-marketing/` (3-phase campaign cycle) | → `02-marketing/` (2-phase continuous) |
| `03-review/` (multi-agent review) | Absorbed into `01-direction.md` |
| `development/01-tech-design/` (multi-agent ADR) | → merged into `dev/01-build.md` |
| `development/03-test.md`, `04-deploy.md`, `05-observe.md` | → merged into `dev/01-build.md` + `02-ship.md` |

### What Was Kept

| Kept | Why |
|---|---|
| Numbered phase ordering via tree walker | Deterministic, no scripting for flow |
| Workspace data flow between cycles | Outputs are explicit, traceable |
| Feature briefs + execute loop pattern | Discover → spec → build per feature |
| Parallel execution of product/marketing/ops | All continuous, all always-on |
| Concise prompts with clear inputs/outputs | Each file declares what it reads and writes |

---

## 5. How Cycles Interact — Event-Driven with Human Staging

### The Problem with Tree-Walker Orchestration

The current model uses the Ash tree walker (`ash strategic-cycle/`) to run phases in sequence: direction → product ∥ marketing ∥ ops. This works as a batch run, but has drawbacks:

1. **Parent calls child** — direction knows about product, product knows about dev. Tight coupling. If a cycle changes, its parent must change too.
2. **All-or-nothing runs** — one `ash` invocation runs everything. You can't run just "marketing" independently.
3. **No human gating** — outputs flow automatically from one phase to the next. The founder never gets a chance to review, refine, or veto before the next phase consumes the output.
4. **Sequential lockstep** — even "parallel" phases must finish before the run ends. Real work is asynchronous: you post to a community, responses come back over days. You ship a feature, usage data accumulates over time.

### The Alternative: Listen, Not Call

Instead of parents orchestrating children through the tree walker:

```
direction → calls → product → calls → dev
              ‖
              calls → marketing
              ‖
              calls → operations
```

Each activity **listens to its input sources** and **produces to its output locations**. Parents don't call children — they just drop outputs where children are listening.

```
direction ──drops──→ workspace/01-direction/confirmed/focus.md
                          ↑
product/research ──reads──┘

product/research ──drops──→ workspace/02-product/01-research/confirmed/feature-briefs/*.md
                                 ↑
product/execute ──reads──────────┘

marketing ──drops──→ workspace/02-marketing/confirmed/feedback.md
                         ↑
product/research ──reads──┘

operations ──drops──→ workspace/02-operations/confirmed/issues.md
                           ↑
product/research ──reads──┘
```

Each activity is **independently invocable**:
```bash
ash strategic-cycle/01-direction.md        # just set direction
ash strategic-cycle/02-product/             # just run product (reads direction, executes)
ash strategic-cycle/02-marketing/           # just collect feedback
ash strategic-cycle/02-operations/          # just monitor and fix
```

The coordination is **through the workspace folders**, not through script calls.

### The Staging / Confirmed Pattern

Every output passes through two folders:

```
workspace/.../some-activity/
├── staging/           # Agent writes here — un-reviewed, draft
└── confirmed/         # Human reviews staging, moves approved files here
                        # Downstream activities only read from confirmed/
```

**Why staging matters:**

| Without staging | With staging |
|---|---|
| Agent output flows directly to downstream | Human reviews first |
| Bad AI output pollutes next phase | Human catches and fixes before it propagates |
| No difference between draft and final | Draft → review → approved = clear state |
| AI runs unchecked | AI is a tool under human judgment |

**The human's role is the gate.** The AI produces, the human confirms. The confirmed folder is the source of truth for all downstream activities.

### What Each Activity Listens To and Produces

| Activity | Listens To (reads from) | Produces To (writes to) |
|---|---|---|
| `01-direction.md` | `workspace/02-marketing/confirmed/feedback.md`, `workspace/02-operations/confirmed/issues.md`, `workspace/02-product/shipped/release-log.md`, `vision.md`, `competition.md` | `workspace/01-direction/staging/focus.md` |
| `02-product/01-research.md` | `workspace/01-direction/confirmed/focus.md`, `workspace/02-marketing/confirmed/feedback.md`, `workspace/02-operations/confirmed/issues.md` | `workspace/02-product/01-research/staging/research-notes.md`, `workspace/02-product/01-research/staging/feature-briefs/*.md` |
| `02-product/02-spec.md` | `workspace/02-product/01-research/confirmed/research-notes.md`, `workspace/02-product/01-research/confirmed/feature-briefs/*.md` | `workspace/02-product/02-spec/staging/spec.md` |
| `02-product/03-execute.ash` | `workspace/02-product/02-spec/confirmed/spec.md`, `workspace/02-product/01-research/confirmed/feature-briefs/*.md` | `workspace/02-product/shipped/release-log.md` (per feature) |
| `dev/01-build.md` | `workspace/02-product/02-spec/confirmed/spec.md` | (code committed to repo) |
| `dev/02-ship.md` | (code from repo) | `workspace/02-product/shipped/release-log.md` |
| `02-marketing/01-post.md` | `workspace/02-product/shipped/release-log.md` | `workspace/02-marketing/staging/post-log.md` |
| `02-marketing/02-collect.md` | Community responses, analytics | `workspace/02-marketing/staging/feedback.md` |
| `02-operations/01-monitor.md` | System metrics | `workspace/02-operations/staging/health.md` |
| `02-operations/02-resolve.md` | Monitoring alerts, user reports | `workspace/02-operations/staging/issues.md` |

### Example: A Feature's Journey Through Staging

```
1. Founder runs:  ash strategic-cycle/01-direction.md
   → writes workspace/01-direction/staging/focus.md
   
2. Human reviews focus.md in staging:
   "Actually we shouldn't build the dashboard yet — users need auth first."
   Edits focus.md, moves it to workspace/01-direction/confirmed/

3. Founder runs:  ash strategic-cycle/02-product/
   → 01-research.md reads confirmed/focus.md
   → writes workspace/02-product/01-research/staging/feature-briefs/feature-auth.md
   
4. Human reviews feature-auth.md:
   "Good, but add: must support OAuth with Google and GitHub."
   Edits, moves to workspace/02-product/01-research/confirmed/feature-briefs/

5. Founder runs:  ash strategic-cycle/02-product/
   → 02-spec.md reads confirmed feature briefs
   → writes workspace/02-product/02-spec/staging/spec.md
   
6. Human reviews spec.md, moves to confirmed/

7. Founder runs:  ash strategic-cycle/02-product/
   → 03-execute.ash reads confirmed/spec.md + confirmed/feature-briefs/
   → dev/01-build.md implements
   → dev/02-ship.md deploys
   → writes workspace/02-product/shipped/release-log.md

8. Founder runs:  ash strategic-cycle/02-marketing/
   → reads shipped/release-log.md
   → writes post to community
   → collects responses back over next few days
```

### Why This Pattern

**Cycles are independent.** Marketing can run while product is building. Operations can run at any time. Each activity reads whatever is in its confirmed input folders and produces its output. No parent script coordinates them.

**Human judgment is the gate.** The AI agent produces drafts into staging. The founder reviews, refines, and moves to confirmed. Nothing downstream reads from staging — confirmed is the only source of truth.

**Decoupled cadence.** Direction might run monthly. Product research might run weekly. Dev might run daily. Marketing might run after each release. Each runs on its own schedule — the workspace folders are the buffer.

**Traceable data flow.** Every file lives in a numbered path that shows where it came from and what it feeds. The staging vs. confirmed distinction shows whether it's been human-reviewed.

---

## 6. Open Questions

1. **Should `01-research.md` and `02-spec.md` be one step?** Research (user needs, market feedback, ops signals) and spec (deciding what to build) are distinct cognitive tasks. But for a fast-moving solo founder building with AI, they might be done in one sitting. Keeping them separate ensures research doesn't get skipped.

2. **Where does "Design" live?** For UI-heavy products, design (wireframes, prototypes, visual spec) might be a third step between spec and build. For API/CLI products, design is implicit in the spec. Should we add a `design/` folder inside dev/ that's optional?

3. **How does the founder handle multiple features in parallel?** The current model loops features sequentially (one at a time). A solo founder might want to work on 2-3 features in parallel (e.g., one in dev, one in spec, one in research). Should the process support parallel feature pipelines?

4. **What's the smallest viable cadence?** Running `ash strategic-cycle/` once per day? Per feature? Per week? The process should support any cadence — the founder just runs it whenever a pulse is needed.
