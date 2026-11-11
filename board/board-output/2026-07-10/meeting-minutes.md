# Board Meeting Minutes — 2026-07-10

**Vision:** To be the definitive orchestration layer for human-AI collaboration, where every automated decision is legible, testable, and completely governed.

## 1. Administrative

**Attendance confirmed:**
- Marcus Thorne — Executive Director, Co-Founder & CEO
- Priya Nair — Investor Director, Partner at Orchestra Ventures
- Sarah Chen — Open-Source / Community Veteran
- James Okonkwo — Independent Director, DevTools Go-to-Market (GTM) Expert
- Dr. Elena Vasquez — Independent Director, Enterprise Architecture Leader

**Conflicts of interest:** None declared.

**Previous meeting minutes:** Approved as circulated.

**Today's agenda:** Adopted as presented.

---

The CEO will now present the business update.

## 2. CEO Business Update

- Adopted workflows: 0. Growth rate: undefined — this quarter sets the floor from zero.
- $0 revenue, $100 token cost, near-zero burn (founder-only). Runway is adequate at current spend but zero revenue indefinitely is not sustainable.
- Headcount: 1 FTE (me) plus intermittent fractional help.
- Right: shipped ash-lang.com, npm package, and VS Code extension in one week — fast execution with minimal resources.
- Right: EU AI Act enforcement in Jan 2027 directly validates our governance and audit trail roadmap.
- Right: product focus narrowed to simplicity and event-triggered workflows — strategic clarity we lacked last quarter.
- Wrong: zero adoption — no signal that anyone needs Ash. We have not proven problem-solution fit.
- Wrong: testing and UX are not production-ready. Onboarding users now would damage credibility before we have a chance to build it.
- Surprise: TaskWeaver launched a near-identical .md-based format and hit 1.2K GitHub stars in two weeks while we have zero.
- Surprise: GitHub Copilot's agent workflow beta validates the category but threatens our open-standard differentiation with a bundled alternative.
- Ask: push me to a monetization decision before next meeting — free-tier boundaries, pricing model, and implementation timeline.
- Ask: guidance on SOC 2 Type II investment — pursue now to close enterprise evaluations, or defer until we have product-market fit?

I'm open to questions.

## Board Questions — Dr. Elena Vasquez

- All six enterprise evaluations have asked about SOC 2 Type II — what is our committed timeline and budget to achieve certification, and are we willing to delay feature work until this is funded?
- EU AI Act enforcement is seven months out — what specific audit-trail schema, provenance chain, and rollback architecture decisions have we made to guarantee an Ash workflow passes a regulatory inspection?
- The CEO says the product focus is simplicity and event-triggered workflows, but enterprise buyers cannot deploy without RBAC, SSO, and procurement-friendly deployment SKUs — where does governance infrastructure rank against developer experience on the actual roadmap?

## Board Questions — Sarah Chen

- We have shipped an npm package and VS Code extension but have zero stars, zero forks, and zero downloads — what is our specific, week-by-week community launch plan to convert our silent launch into actual developer engagement before TaskWeaver owns the mindshare?
- The CEO update acknowledges testing and UX aren't production-ready, so what concrete maintainer pathway, contributor ladder, and governance model are we committing to before we start onboarding contributors, and by what date will those be published?
- TaskWeaver got 1,200 GitHub stars in two weeks with a three-person team using a format nearly identical to ours — what one thing did they do to signal to developers that we are not doing, and why are we not doing it starting today?

## Board Questions — James Okonkwo

- We shipped an npm package and VS Code extension to zero downloads and zero stars — what is the specific activation metric we are optimizing for in the next 30 days, and how do we measure whether an engineer who lands on ash-lang.com converts to writing their first workflow?
- You asked me to push you on monetization, but with zero adoption and no problem-solution fit validated, what concrete funnel milestone (e.g., 100 active workflows, 10 teams, 1 enterprise eval) must we hit before we even draft pricing, and what happens if we miss it this quarter?
- TaskWeaver got 1,200 GitHub stars in two weeks with a nearly identical format — what is their one GTM move we are not making (show up where they aren't, target a different persona, or ship a template library) and by what date will we execute it?

## Board Questions — Priya Nair

- What is our actual cash balance and fully-loaded monthly burn rate inclusive of fractional help, and at what month does that runway expire at zero revenue?
- You asked for a monetization decision — what are the price per seat, number of seats, and payback period assumptions required to reach break-even under a $320K annual burn, and do those numbers hold up to basic LTV/CAC math?
- TaskWeaver reached 1,200 GitHub stars in two weeks while we remain at zero — what concrete resource reallocation or adoption-velocity target are you committing to this quarter to avoid losing the category window entirely?

## CEO Response

### Dr. Elena Vasquez

SOC 2 Type II is a Q2 2027 target — I'll commit to a budget after auditor quotes and yes, I will defer event-triggered features to fund it, because mission pillar three demands enterprise governance before flash. Our provenance chain uses a deterministic DAG with per-node state capture that maps directly to EU AI Act audit requirements — this is the legible, governed architecture our vision requires. Governance infrastructure ranks as priority two behind only adoption, because pillar three is what differentiates Ash from every bundled competitor in this space.

### Sarah Chen

My community plan: publish three reference workflows this week, open GitHub Discussions next week, submit Ash to MCP the week after — converting zero engagement into developer traction for an open standard. I commit to publishing a CONTRIBUTING.md with maintainer ladder by July 31, because mission pillar one — an open standard — fails without a contributor pathway. TaskWeaver shipped a one-command quickstart template; I am shipping ours this week instead of polishing an unused VS Code extension.

### James Okonkwo

My activation metric for the next 30 days is 10 developers completing the Hello Ash tutorial and pushing a `.ash` file to a public repo — the first signal that our open standard has a pulse. We will not draft pricing until we have 10 active workflows across 3 distinct teams, because our mission makes us an open standard first; if we miss that this quarter, we cut all non-essential spend to extend runway. I am launching three opinionated workflow templates by July 17 targeting infrastructure engineers who need a build system for AI agents — the persona TaskWeaver is ignoring.

### Priya Nair

I don't have the precise cash balance or fully-loaded burn rate — I'll follow up after reconciling accounts. I don't have the unit economics for LTV/CAT under a $320K burn — I'll follow up with a pricing model once we have adoption data to anchor it. I am committing to 10 active developers as our adoption target this quarter, reallocating 100% of my time from features to onboarding, because an open standard with zero users is no standard at all.

Let's transition to strategic discussions.

## 3. Strategic Discussion — Monetization

**Positions:** Marcus Thorne recommends usage-based consumption with 500 free steps/month, Team at $50/user/month, and Enterprise at $5K–$25K/month, with pricing-as-code and weekly iteration. Priya Nair recommends per-seat pricing with a 200-step free tier, Team at $50/user/month (min 3 seats), and Enterprise at $125/user/month, arguing usage-based models disincentivize adoption and unsettle enterprise procurement. Sarah Chen recommends no paid tier for 90 days and unlimited free cloud for teams under 10, then a single Enterprise tier, insisting pricing before community kills developer trust. Dr. Elena Vasquez recommends per-seat annual prepaid with a local-only free tier, Team Cloud at $75/user/month, Enterprise Cloud at $150/user/month, and On-Prem/VPC at $350/user/month, stressing the product lacks procurement-ready features (VPC, SOC 2, DPA, SLA). James Okonkwo recommends metered usage at $0.10/execution after 100 free/month with enterprise annual committed volume contracts, arguing metered pricing generates the fastest data feedback loop.

**Agreement:** All directors aligned that the local CLI must remain free under MIT license with no registration, that instrumentation for usage data must ship from day one, and that enterprise governance features (SOC 2, RBAC, SSO) justify premium pricing.

**Trade-off:** The central tension is between maximizing adoption generosity (Sarah's unlimited 90-day free cloud, Marcus's 500 steps) and maintaining fiscal discipline and procurement predictability (Priya's per-seat model, Elena's local-only tier, James's 100-step cap).

**Resolution:** RESOLVED THAT the board adopts a usage-based consumption pricing model for Ash Cloud with 500 free execution steps per user per month, a Team tier at $50/user/month for unlimited steps, and an Enterprise tier at $5K–$25K/month, with all parameters implemented as configuration and subject to revision within 30 days of receiving data from 100 active users.

**Mission check:** This advances Pillar 1 (Open Standard — free local CLI and generous free tier drive format adoption) and Pillar 3 (Enterprise Governance — Enterprise tier pricing is anchored to compliance, audit, and SSO features).

**Dissent:** Priya Nair (favors per-seat over usage-based), Sarah Chen (favors 90-day delay on all pricing), Dr. Elena Vasquez (requires on-prem SKU and procurement-ready features before publishing any tier), and James Okonkwo (favors 100-step metered threshold over 500) each recorded formal dissent on specific aspects of the resolution.

## 4. Strategic Discussion — Licensing

**Positions:** Marcus Thorne recommends staying MIT, arguing that at zero adoption a defensive license is existential risk not protection, contingent on Ash Cloud becoming the premium governed runtime and enterprise governance serving as the primary defensibility; Priya Nair recommends MIT unequivocally from portfolio math, arguing a defensive license worsens odds against the true threats (zero adoption, out-execution) while addressing only the least probable one; James Okonkwo emphatically recommends MIT from his GTM lens, having lived through this exact debate at VeloCloud where MIT enabled a $2.5B outcome and non-standard licenses kill enterprise deals by extending sales cycles; Dr. Elena Vasquez recommends MIT as the only viable option, as any non-OSI license is a procurement disqualifier in regulated enterprises where compliance teams reject non-standard licenses by policy.

**Agreement:** All directors aligned that MIT is the correct license for Ash at this stage, that OSI-approved licensing is non-negotiable for enterprise procurement, and that the license conversation must be closed for a defined period while the company focuses on adoption velocity.

**Trade-off:** The central tension is between MIT's adoption-maximizing frictionlessness (which leaves the format exposed to commoditization by platform players) and a defensive license's promise of legal protection against capture (which protects code that is easy to rewrite while costing trust the company cannot afford at zero adoption).

**Resolution:** RESOLVED THAT the board adopts MIT as the project license, contingent on Ash Cloud becoming the premium governed runtime with deterministic replay, policy-as-code, and procurement artifacts, enterprise governance infrastructure (SOC 2 Type II by Q2 2027, RBAC, SSO, on-prem/VPC) serving as the primary defensibility, user-authorized telemetry shipping within two weeks, and the license decision not being revisited for 18 months or until 1,000 active developers publish workflows, whichever occurs later.

**Mission check:** This advances Pillar 1 (Open Standard — MIT ensures the format remains freely implementable, OSI-approved, and trust-minimized, the non-negotiable foundation of an open standard) and Pillar 3 (Enterprise-Ready Governance — the resolution's conditions commit directly to SOC 2, RBAC, SSO, and procurement-ready infrastructure as the conversion mechanism).

**Dissent:** None — all four directors who spoke on the matter recommended MIT.

## 5. Functional Deep Dive — DSL vs Markdown Engine

**Positions:** Marcus Thorne proposed a full pivot to markdown as the primary user surface, with the .ash DSL becoming an internal intermediate representation, acknowledging his own attachment to the parser as the company's biggest adoption risk; Priya Nair unconditionally endorsed the pivot, citing TaskWeaver's 1,200 GitHub stars in two weeks as an unambiguous market signal that developers want markdown, not custom syntax; Dr. Elena Vasquez advocated markdown-first for enterprise governance, arguing that a human-auditable .md provenance chain maps directly to EU AI Act compliance and removes a regulatory translation step; Sarah Chen supported the pivot to build community, emphasizing that an open standard requires non-engineers to read and contribute to workflows, which only markdown enables.

**Agreement:** All directors aligned that the markdown engine should be the primary user surface and the DSL should become an internal intermediate representation (analogous to LLVM IR or a compiler target), maintained at one engineer 20% time for correctness and power-user escape-hatch use cases only.

**Tension:** The central tension is between the engineering team's natural attachment to the beautifully crafted .ash DSL — a correct, elegant piece of engineering Marcus wrote in a weekend — and the business reality of zero downloads and zero stars against competitors whose markdown-native formats are winning market attention at velocity.

**Resolution:** RESOLVED THAT the board adopts markdown as the primary user surface effective immediately, the .ash DSL is reclassified as an internal intermediate representation maintained for correctness only (one engineer 20% time, no new syntax unless markdown provably cannot express the use case), the onboarding narrative changes from "learn Ash syntax" to "write a workflow in markdown — Ash handles the execution," the CEO converts three reference workflows from .ash to .md and ships a one-command quickstart template within one week, and adoption (10 active .md workflow authors by August 10) is the binding metric against which the pivot's success is measured.

**Mission check:** This advances all three mission pillars — Pillar 1 (Open Standard) because Markdown is the most widely adopted text format in software and lowers the barrier to participation for developers, documentation writers, and compliance officers alike; Pillar 2 (Model-Agnostic) because the runtime architecture is unchanged; and Pillar 3 (Enterprise-Ready Governance) because human-auditable markdown provenance chains map directly to EU AI Act compliance, procurement review, and regulatory filing without a rendering layer.

**Dissent:** None — all four directors who spoke on the DSL pivot voted in favor, though Dr. Elena Vasquez and Sarah Chen recorded conditional observations that the pivot does not change the outstanding requirements for an on-prem SKU, SOC 2 timeline, and 90-day pricing delay first raised in the monetization discussion.

## 6. Closed Session (without CEO)

**1. CEO performance vs mission.** Marcus executes fast and honestly self-assesses — shipping three surfaces in one week while correctly naming zero adoption as the central problem is rare founder candor. But he could not state his own cash balance or burn rate, was unprepared to defend unit economics, and had no community plan until the board demanded one. Specific changes: (a) financial reporting with cash balance, burn rate, and runway must be circulated 48 hours before every meeting, (b) Marcus's time must shift from feature engineering to direct onboarding — personal demos, tutorials, hand-holding the first 10 users — until adoption data exists, (c) SOC 2 planning needs a named owner with a quarterly milestone, not a Q2 2027 aspiration.

**2. Board composition — blind spots.** As a group we cover GTM, venture finance, enterprise architecture, and open-source community — but we lack a product-management voice from a developer-tools company and any security-engineering depth beyond Elena's governance lens. Adding a director is premature: we need to see whether Marcus can execute against the commitments made today before expanding the table. If adoption remains flat in 90 days, we should recruit a product-minded operator, not another category expert.

**3. Governance quality.** The licensing and DSL-pivot decisions were well-structured and reached clear consensus. The monetization debate, by contrast, produced four dissents out of five directors — a sign that the trade-off between adoption generosity and fiscal discipline is not yet resolved. Cadence improvement: quarterly meetings are too slow for a company at zero revenue with one employee. Monthly operational check-ins (60 minutes, half the board) should begin immediately, with full board meetings remaining quarterly. Pre-read quality must improve: board materials arrived without financials or adoption metrics, forcing in-session discovery that wasted time.

**4. Founder-investor alignment.** No single irreconcilable tension exists, but a pattern is emerging: Marcus's builder instinct ("ship another feature") clashes with the board's commercial instinct ("ship an onboarding funnel"). Priya's unit-economics-first mindset and James's activation-metric obsession are the right counterbalances, but Marcus needs to internalize them, not just accept them in-meeting. Sarah's 90-day pricing delay recommendation was outvoted but not debunked — the board should revisit whether publishing any paid tier before 10 active users creates more risk than revenue.

**5. Single biggest undiscussed risk.** The CEO *is* the company. One person holds engineering, product, community, and sales. There is no backup, no technical co-founder, and no succession plan if Marcus burns out or the problem-solution fit thesis is wrong. The board should agree by next meeting: (a) a written founder-resilience plan, (b) a budget and timeline for hiring engineer #2 before any other spend, and (c) a kill criterion — the specific date or metric at which we declare problem-solution fit unproven and either pivot or recommend a capital return. A single point of failure is acceptable at week one; by month six without a second hire, it is negligence.
