---
role: design
---
# Triage Phase — Operations Cycle

**Inputs**: User tickets, monitoring alerts, escalation requests  
**Outputs**: Triaged queue, severity assignments, SLA tracking

Categorise and prioritise incoming tickets and alerts by severity and impact. Route to the appropriate resolver, assign SLA targets, and update the incident tracking system.

---

## Reference

### Participants
Customer Support, SRE / DevOps

### Activity
Prioritise, categorise, route to appropriate resolver

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 70% / 30% |
| AI Suitability | High |
| Key Methodology | ITIL / ITSM Framework, SLA Management, Priority Matrix (Impact × Urgency), RACI |
| Key Decisions | Severity level, escalation path, SLA target |
| Key Human Input | Customer empathy in nuanced situations, complex escalation handling, policy exceptions |
| KPIs | MTTR (time to triage), SLA compliance %, first-response time, auto-triage accuracy |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | End users | Support tickets, feature requests, bug reports | Ticket volume trend, channel distribution |
| Incoming | Infrastructure providers | Monitoring alerts, uptime notifications | Alert accuracy rate, false positive rate |
| Outgoing | Operations (Resolve) | Triaged queue, severity assignments | SLA compliance, triage accuracy |
