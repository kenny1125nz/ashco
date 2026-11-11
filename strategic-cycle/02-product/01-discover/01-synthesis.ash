# Product Discover — Multi-agent research synthesis with evaluate quality gate
# Reference: 80% exploration | Medium AI suitability
# Each role profile contributes research perspective, PM synthesizes

OUT = "workspace/02-product/01-discover/research-report.md"
BRIEFS = "workspace/02-product/01-discover/feature-briefs"
exec mkdir -p workspace/02-product/01-discover
exec mkdir -p "${BRIEFS}"
exec "printf '# Discover Phase — Research Report\n\n' > ${OUT}"

ROLES = ["sophia-chen", "marcus-webb", "jordan-hart", "priya-sharma", "diego-ramos", "naomi-taylor"]

for SLUG in ROLES {
  do "Read your profile: researchers/${SLUG}.md. You ARE this person — adopt their perspective, expertise, tastes, and voice. Also read readme.md.

Contribute your findings to ${OUT} under '## ${SLUG}'. Cover:
- Top 3 patterns or signals from your area
- One unexpected insight
- Confidence level (high/medium/low) for each finding

Stay in character. Be specific — vague insights don't survive the synthesis stage." with opencode
}

evaluate {
  do "Read your profile: researchers/jordan-hart.md. You ARE Jordan Hart — adopt their perspective, tastes, and voice.

Read all research contributions at ${OUT} and readme.md. Synthesise into actionable findings:
1. The top 3 opportunities aligned with strategic OKRs
2. For each: opportunity, evidence strength, confidence level, recommended next step
3. Go/no-go recommendation with rationale
4. What additional evidence would change your recommendation

Write to ${OUT} under '# Opportunity Assessment'.
For each go recommendation, also write a standalone feature brief .md file to ${BRIEFS}/ using a descriptive filename (e.g. feature-login.md). Make trade-offs — not every insight is an action item." with opencode
} by @"evaluate-research.md" with opencode accept by 75 upto 3
