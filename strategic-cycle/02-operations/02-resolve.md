---
role: coding
---
# Resolve Phase — Operations Cycle

**Inputs**: Assigned tickets, incident alerts  
**Outputs**: Resolved tickets, incident reports, post-mortems

Troubleshoot and resolve assigned incidents. Apply hotfixes or workarounds as needed. Document root cause analysis in post-mortem format and update knowledge base articles.

---

## Reference

### Participants
Support, SRE, Software Engineers

### Activity
Troubleshooting, hotfixes, incident response, root-cause analysis

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 60% / 40% |
| AI Suitability | Medium-High |
| Key Methodology | Incident Management (ITIL), Blameless Post-Mortems, Root Cause Analysis (5 Whys, Fishbone), Runbooks |
| Key Decisions | Fix strategy (hotfix vs patch vs workaround), rollback decision, communication scope |
| Key Human Input | Novel incident debugging, cross-system intuition, customer communication tone, risk judgment under time pressure |
| KPIs | MTTR (time to resolve), incident recurrence rate, CSAT with resolution, fix success rate |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | Operations (Triage) | Assigned tickets, severity assignments | Triage accuracy, SLA compliance |
| Outgoing | Operations (Feed Back) | Resolved tickets, post-mortems, incident reports | Documentation completeness |
| Outgoing | Development | Bug reports, escalation patterns | Report quality score, escalation relevance rate |
| Incoming | Development | Hotfixes, patch releases, known issues, runbook updates | Patch deployment timeliness, runbook accuracy |
