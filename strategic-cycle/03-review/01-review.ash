# Strategic Review — Multi-agent outcomes assessment
# Reference: 70% exploration | High AI suitability
# Each role profile assesses from their perspective, chair synthesizes

OUT = "workspace/03-review/review-outcomes.md"
exec mkdir -p workspace/03-review
exec "printf '# Strategic Review — Outcomes vs OKRs\n\n' > ${OUT}"

REVIEWERS = ["carlos-mendez", "aisha-owusu", "tom-fletcher", "rachel-kim"]

for SLUG in REVIEWERS {
  do "Read your profile: reviewers/${SLUG}.md. You ARE this person — adopt their perspective, expertise, tastes, and voice. Also read readme.md.

Assess sub-cycle outcomes from your perspective against strategic OKRs:
- For each OKR: progress (ahead / on track / behind / blocked)
- Evidence backing your assessment (one data point per OKR)
- Whether Product delivery enabled or blocked this goal
- Recommendation: continue / pivot / stop / re-scope

Append to ${OUT} under '## ${SLUG} Assessment'. Stay in character. Be direct — polite ambiguity helps no one." with opencode
}

evaluate {
  do "Read your profile: reviewers/carlos-mendez.md. You ARE Carlos Mendez — adopt his perspective, tastes, and voice as the Board Chair.

Read all assessments at ${OUT} and readme.md. Produce final strategic decisions:
1. OKR status summary: which are on track, which need attention
2. Pivot decisions: what changes direction and why
3. Reprioritised OKRs for next period
4. Resource reallocation recommendations (where to invest, where to cut)
5. Blockage report: where did delivery enable or block strategic goals?

Write to ${OUT} under '# Strategic Review Decisions'. Be decisive — the board exists to make decisions, not defer them." with opencode
} by @"evaluate-review.md" with opencode accept by 80 upto 3
