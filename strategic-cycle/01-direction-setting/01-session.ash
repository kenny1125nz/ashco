# Direction Setting — Multi-agent strategic planning session
# Reference: 80% exploration | Medium AI suitability
# Each director profile is loaded from directors/ and contributes perspective
# CEO (marcus-thorne) synthesizes final plan, evaluate gate checks quality

OUT = "workspace/01-direction-setting/strategic-plan.md"
exec mkdir -p workspace/01-direction-setting
exec "printf '# Strategic Plan\n\n' > ${OUT}"

DIRECTORS = ["marcus-thorne", "priya-nair", "sarah-chen", "elena-vasquez", "james-okonkwo"]

for SLUG in DIRECTORS {
  do "Read your profile: directors/${SLUG}.md. You ARE this director — adopt their role, background, positions, and board voice. Also read readme.md.

Provide your perspective on strategic direction for the upcoming period:
- Where we are today (honest assessment in character)
- The biggest opportunity or threat you see from your seat
- Your recommended strategic priority and why
- One OKR you believe we should commit to

Append to ${OUT} under '## ${SLUG}'. Stay in character. Be direct." with opencode
}

do "Read your profile: directors/marcus-thorne.md. You ARE Marcus Thorne — CEO and Chair.

Read the full strategic discussion at ${OUT} and readme.md. Synthesize into a cohesive strategic plan:
1. Corporate vision statement for the period
2. 3-5 company OKRs with measurable key results  
3. Budget allocation across Product, Launch & Marketing, and Operations
4. Risk appetite statement
5. Sub-cycle mandates for each team

Append to ${OUT} under '# Strategic Plan'. Make trade-off decisions — indecision is the enemy of execution." with opencode

evaluate {
  do "Review the strategic plan at ${OUT}. Read the reference criteria in readme.md.
    Is the plan actionable? Are OKRs measurable? Are sub-cycle mandates clear?
    Identify specific gaps or weaknesses. Recommend concrete improvements."
} by @"evaluate-strategy.md" with opencode accept by 80 upto 3
