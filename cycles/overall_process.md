# Overall Software Development Process

The entire organisation operates within the **Strategic Cycle**, which contains all sub-cycles and is fundamentally dependent on their execution. Direction Setting constrains the sub-cycles; sub-cycle outcomes feed Review; Review feeds back into Direction.

---

## Cycle Descriptions

### 1. Strategic Cycle
[Detailed doc](strategic_cycle.md) — The top-level container. Sets direction, reviews outcomes, and adjusts. Contains all sub-cycles and is fundamentally dependent on their execution — if Product cannot deliver, Strategic is blocked.

### 2. Launch & Marketing Cycle
[Detailed doc](launch_marketing_cycle.md) — Contained within the Strategic Cycle. Plans and executes go-to-market campaigns, measures market response. Interacts with Product Cycle on release timing and feature details.

### 3. Operations / Support & Maintenance Cycle
[Detailed doc](operations_cycle.md) — Contained within the Strategic Cycle. Handles the live product, triages and resolves incidents, feeds bug reports and feature requests into Product Discovery. Receives hotfixes and patches from Development.

### 4. Product Cycle
[Detailed doc](product_cycle.md) — Contained within the Strategic Cycle. Drives feature delivery from discovery through release and outcome measurement. Delegates technical execution to the Development Cycle. Strategic outcomes depend on Product delivery.

### 5. Development Cycle
[Detailed doc](development_cycle.md) — Nested inside the Product Cycle. Owns technical execution from architecture through deployment and operational observation.

---

## I/O Between Cycles (within the Strategic container)

| From                  | To                   | Signal                                                            |
| --------------------- | -------------------- | ----------------------------------------------------------------- |
| Strategic             | Product              | OKRs, budget allocation, constraints, strategic priorities        |
| Strategic             | Launch & Marketing   | Corporate direction, release cadence, target markets              |
| Launch & Marketing    | Product              | Market response data, positioning requirements, customer feedback |
| Product               | Launch & Marketing   | Feature details, release schedule, value propositions             |
| Product               | Strategic            | Outcome reports, adoption metrics, portfolio health               |
| Operations / Support  | Product              | Bug patterns, feature requests, usage friction, trend analysis    |
| Product / Development | Operations / Support | Hotfixes, patch releases, known issues, runbook updates           |

---

## Consolidated Inputs

All inputs flowing into the organisation, split by origin.

### External Inputs

Inputs originating outside the company.

| Input                              | Source                                 | Consumed By                         |
| ---------------------------------- | -------------------------------------- | ----------------------------------- |
| Market trends & shifts             | Industry reports, analyst research     | Strategic Cycle                     |
| Competitive intelligence           | Competitive analysis, market tracking  | Strategic Cycle, Launch & Marketing |
| Investor expectations              | Shareholders, board representatives    | Strategic Cycle                     |
| Regulatory requirements            | Government, industry bodies            | Strategic Cycle, Development        |
| Target market / segments           | Market research, TAM/SAM/SOM analysis  | Launch & Marketing, Product         |
| User research data                 | Interviews, surveys, field studies     | Product                             |
| Usability test results             | Moderated/unmoderated testing sessions | Product                             |
| Usage analytics                    | Product analytics tools                | Product, Operations                 |
| NPS / CSAT scores                  | Survey platforms                       | Product                             |
| User tickets & feature requests    | Support channels, in-app feedback      | Operations                          |
| Monitoring alerts                  | Infrastructure monitoring              | Operations, Development             |
| Campaign reach & conversion data   | Ad platforms, web analytics            | Launch & Marketing                  |
| Security vulnerability disclosures | External researchers, bug bounty       | Development, Operations             |
| Third-party dependency changes     | Package registries, scanners           | Development                         |

### Internal Inputs

Inputs generated inside the organisation.

| Input                                       | Source                        | Consumed By                             |
| ------------------------------------------- | ----------------------------- | --------------------------------------- |
| Corporate vision & mission                  | Board, CEO (Strategic)        | All cycles                              |
| OKRs & budget allocation                    | Strategic Cycle               | Product, Launch & Marketing             |
| Strategic plan & funding decisions          | Strategic Cycle               | Product, Launch & Marketing, Operations |
| Research reports & personas                 | Product (Discover)            | Product (Define, Design)                |
| Prioritised roadmap & feature hypotheses    | Product (Define)              | Product (Design), Launch & Marketing    |
| Design specs & prototypes                   | Product (Design)              | Product (Execute), Development          |
| Acceptance criteria                         | Product Manager               | Development                             |
| Architecture Decision Records               | Development (Tech Design)     | Development                             |
| Technical design docs & API contracts       | Development (Tech Design)     | Development                             |
| Sprint backlog & user stories               | Development (Tech Design)     | Development                             |
| Pull requests & committed code              | Development (Build)           | Development                             |
| Automated test results                      | CI pipeline                   | Development                             |
| Test reports & QA sign-off                  | QA (Development)              | Development                             |
| Security audit / penetration test results   | Security Engineer             | Development                             |
| Deployment plan & runbooks                  | Development                   | Development, Operations                 |
| Feature flags & release notes               | Development, Product          | Launch & Marketing, Operations          |
| Outcome reports & learning docs             | Product (Observe)             | Product, Strategic                      |
| Bug reports & regression findings           | QA, Support, internal testing | Development, Operations                 |
| Hotfixes & patch releases                   | Development                   | Operations                              |
| Incident reports & post-mortems             | Development, Operations       | Development, Strategic                  |
| Error budgets, cycle time, deploy frequency | Development (Observe)         | Development                             |
| Campaign plans & positioning docs           | Launch & Marketing            | Launch & Marketing                      |
| Campaign performance reports                | Launch & Marketing            | Launch & Marketing, Strategic           |
| Insight reports & trend analysis            | Operations (Feed Back)        | Product                                 |
| Tech debt & improvement backlog             | Development (Observe)         | Development                             |
| Velocity & reliability metrics              | Development (Observe)         | Product, Engineering Manager            |

---

## Summary of Roles

| Role                  | Primary Cycle(s)        | Responsibility                                                            |
| --------------------- | ----------------------- | ------------------------------------------------------------------------- |
| Board of Directors    | Strategic               | Governance, high-level strategy, funding                                  |
| CEO / Exec Team       | Strategic               | Company vision, business strategy, organisational orchestration           |
| Product Director      | Strategic, Product      | Portfolio governance, resource allocation, strategic alignment            |
| Product Manager       | Product                 | Feature definition, roadmap, stakeholder communication, outcome ownership |
| UX Researcher         | Product                 | User needs, behavioural insights, concept validation                      |
| UX / UI Designer      | Product                 | Interaction design, visual design, design system                          |
| Tech Lead / Architect | Product, Development    | System design, technical standards, architecture decisions                |
| Engineering Manager   | Product, Development    | Team delivery, people management, process improvement                     |
| Software Engineer     | Development             | Code implementation, testing, code review                                 |
| QA Engineer           | Development             | Test strategy, quality gates, regression coverage                         |
| DevOps / SRE          | Development, Operations | Infrastructure, CI/CD, reliability, observability                         |
| Security Engineer     | Development, Strategic  | Threat modelling, vulnerability management, compliance                    |
| Data / Analytics      | Product, Strategic      | Metrics, experimentation, data-driven insights                            |
| Marketing             | Launch & Marketing      | Positioning, campaigns, launch execution                                  |
| Sales                 | Launch & Marketing      | Pipeline, demos, revenue generation                                       |
| Customer Success      | Operations              | Onboarding, retention, account health                                     |
| Customer Support      | Operations              | Incident triage, user troubleshooting                                     |
| Legal / Compliance    | Strategic               | Regulatory requirements, licensing, data privacy                          |
