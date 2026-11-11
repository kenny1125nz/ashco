---
role: review
---
# Observe Phase — Development Cycle

**Inputs**: Error budgets, cycle time, deployment frequency, incident rate  
**Outputs**: Improvement backlog, velocity metrics, reliability reports

Analyse delivery metrics and incident patterns from the recent cycle. Identify process improvements, tech debt items, and reliability investments. Prioritise them into the improvement backlog.

---

## Reference

### Participants
Software Engineers, QA, DevOps / SRE

### Activity
Retrospective, process improvement, tech debt planning, reliability engineering

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 20% / 80% |
| AI Suitability | High |
| Key Methodology | Observability (logs, metrics, traces), SLO / SLI / Error Budgets, Reliability Engineering, Retrospectives |
| Key Decisions | Tech debt priorities, reliability investments, on-call rotation changes, process improvements |
| Key Human Input | Incident triage judgment, reliability investment balance, on-call escalation discernment, retrospective facilitation |
| KPIs | MTTD (time to detect), MTTR (time to resolve), error budget burn rate, alert-to-ticket conversion |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | Development (Deploy) | Error budgets, cycle time, deployment frequency, incident rate | Monitoring data completeness |
| Outgoing | Product | Feasibility estimates, delivery timelines, quality data | Estimate accuracy (±%), delivery predictability |
| Outgoing | Strategic | Incident trends, post-mortems | Report actionability, trend clarity, post-mortem quality score |
| Incoming | Operations | Bug reports, escalation patterns | Report quality score, escalation relevance rate |
