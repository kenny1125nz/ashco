---
role: coding
---
# Test Phase — Development Cycle

**Inputs**: Release candidate, acceptance criteria  
**Outputs**: Test report, bug tracker updates, QA sign-off

Run integration tests, regression tests, and security scans against the release candidate. Report all failures with reproduction steps. Verify acceptance criteria are met before issuing QA sign-off.

---

## Reference

### Participants
QA Engineer, Security Engineer, Software Engineers

### Activity
Integration testing, regression testing, performance testing, penetration scan, vulnerability audit

### Profile
| Dimension | Value |
|---|---|
| Execution / Exploration | 60% / 40% |
| AI Suitability | High |
| Key Methodology | Shift-Left Testing, Automated Testing Pyramid, Risk-Based Testing, Property-Based Testing, Chaos Engineering |
| Key Decisions | What to test at each level, release quality bar, risk acceptance |
| Key Human Input | Risk assessment intuition, exploratory testing creativity, scenario generation from production knowledge |
| KPIs | Test coverage %, defect escape rate, false positive rate, test execution time |

### Cycle I/O
| Direction | Partner | Signal | KPI |
|---|---|---|---|
| Incoming | Development (Build) | Release candidate, acceptance criteria | Code quality, test pass rate |
| Outgoing | Development (Deploy) | Test report, bug tracker updates, QA sign-off | QA sign-off completeness, defect escape rate |
