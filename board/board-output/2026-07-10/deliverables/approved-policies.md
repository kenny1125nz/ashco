# Approved Policies — Board Meeting 2026-07-10

These policies are governing guidelines for the organization, approved by the board of directors on July 10, 2026. Each policy is actionable and binding until amended by a subsequent board resolution.

---

## 1. AI Governance Framework

**Authority:** Approved by the board on recommendation of Dr. Elena Vasquez, Independent Director, Enterprise Architecture.

### 1.1 Auditability
- Every workflow execution must produce a full provenance chain captured as a deterministic directed acyclic graph (DAG) with per-node state snapshots.
- The provenance chain must be human-auditable in markdown format — no translation layer may exist between the raw execution record and a compliance reviewer's reading.
- All audit records must map directly to EU AI Act Article 12 (record-keeping) and Article 22 (transparency) requirements without additional rendering or transformation.
- Audit trails must be immutable post-execution, retainable for a minimum of 12 months, and exportable in standard formats (JSON, CSV, PDF) for regulatory filing.

### 1.2 State Control & Deterministic Execution
- All workflow execution must be deterministic: the same input + the same DAG must produce the same output and the identical audit trail across any runtime instance.
- State capture must occur at every execution node, recording input, output, model provider, timestamp, and configuration parameters.
- Rollback must be supported at the node level, enabling partial workflow replay for forensic analysis or error recovery.
- Non-deterministic paths (e.g., live model inference) must be explicitly flagged and logged with the provider-specific variability parameters recorded.

### 1.3 Enterprise Compliance Infrastructure
- SOC 2 Type II certification is the binding compliance milestone: scoping must begin immediately, with audit readiness targeted for Q2 2027.
- The following must ship before any enterprise tier can be published: role-based access control (RBAC), single sign-on (SSO), on-premises / VPC deployment option, data processing agreement (DPA), and a service-level agreement (SLA).
- All enterprise governance features (SOC 2, RBAC, SSO, on-prem) must be priced at a premium tier — these are the defensibility mechanisms that justify enterprise pricing.
- The Ash runtime must offer policy-as-code guardrails that allow compliance teams to define approval gates, model allowlists, and execution constraints in human-readable configuration.
- Procurement-ready artifacts (security questionnaire responses, pentest reports, data residency documentation) must be maintained and versioned.

### 1.4 License & Format Governance
- MIT license is adopted and may not be revisited for 18 months or until 1,000 active developers publish workflows, whichever occurs later.
- Markdown is the primary user surface; any deviation from markdown-first documentation, onboarding, and execution records must be approved by the board.
- User-authorized telemetry must ship within two weeks to inform governance and compliance metrics.

---

## 2. Community Engagement Policy

**Authority:** Approved by the board on recommendation of Sarah Chen, Independent Director, Open-Source / Community.

### 2.1 Open-Source Stewardship
- The Ash project is MIT-licensed and must remain freely implementable, redistributable, and forkable by any party. No additional contributor license agreement (CLA) may impose terms beyond MIT.
- The local CLI must remain free with no registration, no telemetry requirement, and no usage cap. Any change to this policy requires a board resolution.
- The project must be hosted on a public GitHub repository with all development artifacts (spec, runtime, templates, documentation) visible and accepting contributions.

### 2.2 Contributor Program
- A CONTRIBUTING.md, maintainer ladder, and governance model must be published by July 31, 2026.
- The maintainer ladder must include concrete promotion criteria for each level: Contributor → Active Contributor → Maintainer → Core Maintainer, with defined privileges and responsibilities at each tier.
- At least three reference workflows authored in markdown must be published within one week of this policy's approval, serving as onboarding exemplars for new contributors.
- GitHub Discussions must be opened within two weeks of this policy's approval as the primary community forum.
- The project must be submitted to the MCP (Model Context Protocol) ecosystem within three weeks to establish presence in the agent interoperability landscape.

### 2.3 Communication Standards
- All project communication — README, documentation, issue templates, commit messages — must prioritize comprehension by non-engineers, including compliance officers, documentation writers, and evaluators.
- A one-command quickstart template must be maintained so that a new user can write and execute their first workflow in under 60 seconds without reading documentation.
- Community metrics (stars, forks, active contributors, workflow authors) must be reported to the board at every monthly operational check-in.
- The CEO must personally onboard the first 10 community members via direct demos, code reviews, and pair sessions.

### 2.4 Adoption Generosity
- The open-standard community tier (local CLI + free cloud for teams under 10) must remain free indefinitely. No usage limits may be placed on local execution.
- Pricing may not be introduced for any cloud tier until the board has reviewed adoption data from at least 10 active users across 3 distinct teams.

---

## 3. GTM Strategy Summary

**Authority:** Approved by the board on recommendation of James Okonkwo, Independent Director, DevTools Go-to-Market.

### 3.1 Adoption Funnel & Activation
- The binding activation metric is **10 developers completing the Hello Ash tutorial and pushing a workflow file to a public repository** within 30 days.
- The secondary metric is **10 active workflows across 3 distinct teams** — this is the gate condition for any pricing or monetization discussions.
- The adoption funnel must be instrumented from day one: landing page visit → tutorial start → first workflow authoring → first public push. Each stage must be measurable and reported.
- A one-command quickstart template and three opinionated workflow templates targeting infrastructure engineers are the primary onboarding assets. These templates must emphasize Ash as a build system for AI agents — the persona and use case that competing formats are not targeting.

### 3.2 Pricing Model
- Pricing is usage-based consumption: 500 free execution steps per user per month, Team tier at $50/user/month for unlimited steps, Enterprise tier at $5K–$25K/month.
- Pricing parameters must be implemented as code (pricing-as-code) and subject to revision within 30 days of receiving data from 100 active users.
- The board adopts this pricing model as a hypothesis, not a conclusion. All directors except Marcus Thorne recorded positions that differ in specifics (threshold, structure, timing); the model will be validated or revised based on adoption data.
- No pricing may be published until the enterprise tier includes SOC 2, RBAC, SSO, DPA, SLA, and on-prem deployment — the governance features that justify the premium price band.

### 3.3 Enterprise Transition
- The enterprise go-to-market motion is compliance-led, not product-led. All six active enterprise evaluations are blocked on SOC 2 readiness, not product gaps.
- SOC 2 Type II certification is the single highest-leverage revenue conversion activity and must be resourced immediately.
- Enterprise pricing must be annual prepaid with committed volume contracts, aligning with procurement requirements and cash flow predictability.
- The sales cycle must be tracked: evaluation → SOC 2 review → POC → security review → procurement → close. Stage duration and drop-off must be measured and reported.
- The CEO must maintain a named prospect list and pipeline velocity metrics, reported at each monthly operational check-in.

### 3.4 Competitive Positioning
- The primary competitive threat is not direct (no direct competitor has a governed open-standard format) but indirect: bundled alternatives (GitHub Copilot agent workflows) and first-mover format adoption (TaskWeaver).
- Ash's differentiation must be enterprise governance — auditability, deterministic execution, policy-as-code, and compliance readiness — not syntax, speed, or features.
- If adoption metrics are not met by the next board meeting, all non-essential spend must be cut to extend runway, and a formal problem-solution fit review must be conducted.

---

## 4. Financial Statements

**Authority:** Approved by the board on recommendation of the board's review and discussion of the company's financial position.

The detailed financial report at `board-output/2026-07-10/finance-report.md` has been reviewed and approved by the board. The following summarizes the board's findings and directives:

### 4.1 Financial Position (Launch Week, July 4–10, 2026)
- Revenue: $0 (pre-revenue, seed-stage)
- Net burn: $100/week (~$430/month), driven entirely by model inference token costs
- Cash compensation: $0 (founder sweat equity; no fractional help cash comp)
- Runway: Not calculable from reported data — cash on hand was not disclosed to the board

### 4.2 Board Directives
- The CEO must circulate cash balance, fully-loaded monthly burn rate (inclusive of fractional help), and runway projection to the board 48 hours before every subsequent meeting. This is a mandatory reporting requirement.
- The controller function (currently the CEO) must reconcile accounts and provide unit economics (LTV/CAC, payback period, break-even assumptions) by the next monthly operational check-in.
- The current token budget of $100/week is approved; increase to $300–$500/week is authorized once community adoption generates organic testing demand, subject to CEO discretion.
- SOC 2 scoping expenditure of $15,000–$25,000 (external auditor + compliance tooling) is pre-approved to begin immediately. This is the board's priority allocation of the company's limited capital.
- Fundraising (seed round, Q1 2027, $1.5M–$2.5M target) is authorized only after SOC 2 readiness is underway and community adoption metrics are trending positively. Premature fundraising is not authorized.

### 4.3 Risk Acknowledgement
The board acknowledges that the financial statements reflect a pre-revenue entity with one week of operating history. The primary risk is under-investment in engineering and compliance capacity, not near-term insolvency. The CEO's inability to state cash-on-hand and burn rate at the meeting is noted as a governance deficiency that must not recur.
