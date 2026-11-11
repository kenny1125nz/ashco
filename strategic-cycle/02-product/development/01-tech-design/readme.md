---
role: design
---
# Tech Design Phase — Development Cycle

**Inputs**: Design spec from Product, system context, non-functional requirements  
**Outputs**: Architecture Decision Record (ADR), technical design doc, sprint backlog

Review the design spec and produce architecture decisions covering: system context, API contracts, database schema, infrastructure plan, and task breakdown. Document trade-offs and rationale in ADR format.

---

## Reference

### Participants
Tech Lead / Architect, Software Engineers, DevOps / SRE

### Activity
Architecture decisions, API contracts, database schema, infrastructure plan, task breakdown

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 40% / 60% |
| AI Suitability | Medium-High |
| Key Methodology | ADR, Domain-Driven Design, Design Patterns, RFC / Proposal Process, C4 Model |
| Key Decisions | Technology choices, architecture style, API contracts, database schema, infrastructure topology |
| Key Human Input | Architecture trade-off judgment, long-term maintainability intuition, risk on unproven approaches |
| KPIs | ADR adoption rate, rework due to design gaps, design review cycle time, architecture compliance score |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | Product (Design) | Design spec, system context, non-functional requirements | Spec clarity score |
| Outgoing | Product (Observe) | Feasibility estimates, delivery timelines, quality data | Estimate accuracy (±%), delivery predictability |
| Outgoing | Operations | Hotfixes, patch releases, known issues, runbook updates | Patch deployment latency, runbook accuracy |
