---
role: coding
---
# Deploy Phase — Development Cycle

**Inputs**: Approved release, deployment plan  
**Outputs**: Deployed production, runbook updates, deployment announcement

Validate on staging, run smoke tests, then deploy to production using the rollout strategy defined in the deployment plan. Toggle feature flags, verify monitoring signals, and update runbooks if needed.

---

## Reference

### Participants
DevOps / SRE, QA Engineer, Engineering Manager

### Activity
Staging validation, smoke tests, production deployment, feature flag toggle, monitoring

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 90% / 10% |
| AI Suitability | High |
| Key Methodology | Infrastructure as Code (Terraform / Pulumi), Immutable Infrastructure, Canary / Blue-Green Deployments, Feature Flags |
| Key Decisions | Rollout strategy (percentage, rings), rollback triggers, release window |
| Key Human Input | Rollback judgment under pressure, deployment timing based on business context, incident communication tone |
| KPIs | Change failure rate, deployment frequency, rollback rate, time from merge to production |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | Development (Test) | Approved release, deployment plan | Test report completeness, QA sign-off |
| Outgoing | Development (Observe) | Deployed production, runbook updates, deployment announcement | Deployment success rate, monitoring coverage |
| Outgoing | Operations | Hotfixes, patch releases, known issues, runbook updates | Patch deployment latency, runbook accuracy |
