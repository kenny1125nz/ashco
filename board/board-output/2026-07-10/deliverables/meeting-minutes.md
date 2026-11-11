# Board Meeting Minutes

**Company:** Ash Inc.
**Date:** July 10, 2026
**Time:** 10:00 AM – 12:30 PM ET
**Location:** Virtual (Video Conference)

---

## Attendance

All five directors were present:

| Name | Title |
|------|-------|
| Marcus Thorne | Executive Director, Co-Founder & Chief Executive Officer |
| Priya Nair | Investor Director, Partner at Orchestra Ventures |
| Sarah Chen | Independent Director, Open-Source & Community Strategy |
| James Okonkwo | Independent Director, DevTools Go-to-Market Expert |
| Dr. Elena Vasquez | Independent Director, Enterprise Architecture Leader |

**Conflicts of Interest:** None declared.

---

## 1. Administrative

The chair called the meeting to order at 10:00 AM ET. The minutes of the previous meeting were approved as circulated. The agenda for the meeting was adopted as presented.

---

## 2. CEO Business Update (with Q&A)

Marcus Thorne presented the business update. Key highlights:

- **Adoption:** Zero adopted workflows. The quarter establishes a baseline from zero.
- **Revenue:** $0. Token cost is approximately $100. Burn is near-zero (founder-only compensation). Runway is adequate at current spend but unsustainable indefinitely without revenue.
- **Headcount:** 1.0 FTE (CEO) plus intermittent fractional assistance.
- **Positive developments:** Delivered ash-lang.com, the npm package, and the VS Code extension within one week. EU AI Act enforcement (January 2027) validates the governance and audit trail roadmap. Product focus has narrowed to simplicity and event-triggered workflows.
- **Challenges:** Zero adoption — no evidence of problem-solution fit. Testing and user experience are not production-ready. TaskWeaver launched a near-identical markdown-based format and achieved 1,200 GitHub stars in two weeks. GitHub Copilot's agent workflow beta validates the category but threatens differentiation.
- **CEO asks:** Requested board guidance on (a) a monetization decision before the next meeting, including free-tier boundaries, pricing model, and implementation timeline; and (b) whether to pursue SOC 2 Type II certification now or defer until product-market fit is established.

### Board Questions and CEO Response

**Dr. Elena Vasquez** queried the SOC 2 Type II timeline and budget, the specific audit-trail architecture for EU AI Act compliance, and the roadmap priority of governance infrastructure relative to developer experience. The CEO committed to a Q2 2027 target for SOC 2 Type II, confirmed a deterministic DAG architecture with per-node state capture mapped to EU AI Act requirements, and stated that governance infrastructure ranks second only to adoption.

**Sarah Chen** asked for a week-by-week community launch plan, a contributor governance model with a published date, and a specific analysis of why TaskWeaver gained traction while Ash did not. The CEO committed to publishing three reference workflows within the week, opening GitHub Discussions the following week, submitting Ash to MCP the week after, and publishing a CONTRIBUTING.md with maintainer ladder by July 31.

**James Okonkwo** requested a defined activation metric for the next 30 days, a concrete adoption milestone that would trigger pricing discussions, and a GTM differentiation strategy against TaskWeaver. The CEO set 10 developers completing the Hello Ash tutorial and pushing a `.ash` file to a public repo as the 30-day activation metric, committed not to draft pricing until 10 active workflows exist across 3 distinct teams, and committed to launching three opinionated workflow templates by July 17 targeting infrastructure engineers.

**Priya Nair** asked for precise cash balance and fully-loaded monthly burn, the unit economics and LTV/CAC assumptions required to reach break-even under a $320K annual burn, and a resource reallocation commitment to address adoption velocity. The CEO acknowledged he could not provide precise financial figures and committed to follow up after reconciling accounts, further committing to 10 active developers as the quarter's adoption target and reallocating 100% of his time from features to onboarding.

---

## 3. Strategic Discussion — Monetization

The board considered four position papers on pricing architecture.

**RESOLVED THAT** the board adopts a usage-based consumption pricing model for Ash Cloud with 500 free execution steps per user per month, a Team tier at $50/user/month for unlimited steps, and an Enterprise tier at $5K–$25K/month, with all parameters implemented as configuration and subject to revision within 30 days of receiving data from 100 active users.

**Common ground:** All directors agreed that (a) the local CLI must remain free under the MIT license with no registration requirement, (b) instrumentation for usage data must ship from day one, and (c) enterprise governance features (SOC 2, RBAC, SSO) justify premium pricing.

**Dissent recorded:** Priya Nair (favored per-seat over usage-based pricing), Sarah Chen (favored a 90-day delay on all pricing), Dr. Elena Vasquez (required an on-prem SKU and procurement-ready features before publishing any tier), and James Okonkwo (favored a 100-step metered threshold over 500) each recorded formal dissent on specific aspects of the resolution.

**Mission alignment:** The resolution advances Pillar 1 (Open Standard) through the free local CLI and generous free tier, and Pillar 3 (Enterprise Governance) by anchoring Enterprise-tier pricing to compliance, audit, and SSO features.

---

## 4. Strategic Discussion — Licensing

The board considered the appropriate open-source license for the Ash project.

**RESOLVED THAT** the board adopts MIT as the project license, contingent on (a) Ash Cloud becoming the premium governed runtime with deterministic replay, policy-as-code, and procurement artifacts; (b) enterprise governance infrastructure (SOC 2 Type II by Q2 2027, RBAC, SSO, on-prem/VPC) serving as the primary defensibility; (c) user-authorized telemetry shipping within two weeks; and (d) the license decision not being revisited for 18 months or until 1,000 active developers publish workflows, whichever occurs later.

**Common ground:** All directors agreed that MIT is the correct license at this stage, that OSI-approved licensing is non-negotiable for enterprise procurement, and that the license conversation should be closed for a defined period to focus on adoption velocity.

**Dissent:** None.

**Mission alignment:** The resolution advances Pillar 1 (Open Standard) by ensuring the format remains freely implementable and OSI-approved, and Pillar 3 (Enterprise-Ready Governance) through the explicit conditions committing to SOC 2, RBAC, SSO, and procurement-ready infrastructure.

---

## 5. Strategic Discussion — DSL Investment

The board considered whether to continue investing in the native `.ash` DSL or to pivot to markdown as the primary user surface.

**RESOLVED THAT** the board adopts markdown as the primary user surface effective immediately; the `.ash` DSL is reclassified as an internal intermediate representation maintained for correctness only (one engineer at 20% time, no new syntax unless markdown provably cannot express the use case); the onboarding narrative changes from "learn Ash syntax" to "write a workflow in markdown — Ash handles the execution"; the CEO converts three reference workflows from `.ash` to `.md` and ships a one-command quickstart template within one week; and adoption (10 active `.md` workflow authors by August 10) is the binding metric against which the pivot's success is measured.

**Common ground:** All directors aligned that the markdown engine should be the primary user surface and the DSL should become an internal intermediate representation.

**Dissent:** None. Dr. Elena Vasquez and Sarah Chen recorded conditional observations that the pivot does not change the outstanding requirements for an on-prem SKU, SOC 2 timeline, and 90-day pricing delay first raised in the monetization discussion.

**Mission alignment:** The resolution advances all three mission pillars — Pillar 1 (Open Standard) by lowering the barrier to participation through markdown; Pillar 2 (Model-Agnostic) by leaving the runtime architecture unchanged; and Pillar 3 (Enterprise-Ready Governance) by producing human-auditable markdown provenance chains that map directly to EU AI Act compliance.

---

## 6. Closed Session (Without CEO)

The board convened in closed session without the CEO. The following matters were discussed:

**CEO Performance vs. Mission:** The board acknowledged Marcus Thorne's execution velocity and candid self-assessment, while noting he was unprepared on financial reporting (cash balance, burn rate, unit economics) and lacked a community plan until directed by the board. The board determined that (a) financial reporting must be circulated 48 hours before every meeting, (b) the CEO's time must shift from feature engineering to direct user onboarding until adoption data exists, and (c) SOC 2 planning requires a named owner with quarterly milestones.

**Board Composition — Blind Spots:** The board identified gaps in product-management experience from a developer-tools company and in security-engineering depth. The board agreed that board expansion is premature but should be revisited if adoption remains flat in 90 days, at which point a product-minded operator should be recruited.

**Governance Quality:** The licensing and DSL-pivot discussions were well-structured with clear consensus. The monetization debate yielded four dissents, indicating unresolved tension between adoption generosity and fiscal discipline. The board resolved to institute monthly operational check-ins (60 minutes, half the board) effective immediately, and to require improved pre-read materials containing financials and adoption metrics.

**Founder-Investor Alignment:** The board observed a pattern where the CEO's builder instinct ("ship another feature") requires ongoing counterbalance from the board's commercial instinct ("ship an onboarding funnel"). The board determined that the 90-day pricing delay recommendation should be revisited.

**Single Biggest Undiscussed Risk:** The board identified that the CEO is the single point of failure for engineering, product, community, and sales. The board resolved that by the next meeting, the CEO must present (a) a written founder-resilience plan, (b) a budget and timeline for hiring engineer #2, and (c) a specific kill criterion — the date or metric at which problem-solution fit is declared unproven, triggering either a pivot or a recommendation of capital return.

---

## Summary of Formal Resolutions

| # | Resolution |
|---|------------|
| 1 | **Monetization:** Adopt usage-based consumption pricing for Ash Cloud with 500 free execution steps/user/month, Team tier at $50/user/month, Enterprise tier at $5K–$25K/month, configurable parameters, revisable within 30 days of data from 100 active users. |
| 2 | **Licensing:** Adopt MIT license, contingent on Ash Cloud becoming the premium governed runtime, enterprise governance infrastructure as primary defensibility, user-authorized telemetry within two weeks, and no revisitation for 18 months or 1,000 active developers. |
| 3 | **DSL Investment:** Adopt markdown as primary user surface, reclassify `.ash` DSL as internal intermediate representation, change onboarding narrative, convert three reference workflows within one week, target 10 active `.md` workflow authors by August 10. |

---

## Action Items

| Action | Owner | Deadline |
|--------|-------|----------|
| Publish three reference workflows | Marcus Thorne | July 17, 2026 |
| Ship one-command quickstart template | Marcus Thorne | July 17, 2026 |
| Open GitHub Discussions | Marcus Thorne | July 17, 2026 |
| Submit Ash to MCP | Marcus Thorne | July 24, 2026 |
| Publish CONTRIBUTING.md with maintainer ladder | Marcus Thorne | July 31, 2026 |
| Circulate cash balance, burn rate, and runway | Marcus Thorne | 48 hours before next meeting |
| Present founder-resilience plan, engineer #2 hiring plan, and kill criterion | Marcus Thorne | Next board meeting |
| Revisit 90-day pricing delay recommendation | Full Board | Next board meeting |

---

## Approval

**Minutes prepared by:** Board Secretary

**Approved by:**

\____________________________________
Marcus Thorne
Chair of the Board, Executive Director, Co-Founder & Chief Executive Officer
Ash Inc.

**Date of approval:** ___________________
