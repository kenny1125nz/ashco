# Tech Design — Multi-agent architecture ADR with iterative evaluation
# Reference: 60% exploration | Medium-High AI suitability
# Each role profile reviews the design, evaluate block produces ADR

OUT = "workspace/02-product/04-development/01-tech-design/adr.md"
exec mkdir -p workspace/02-product/04-development/01-tech-design
exec "printf '# Architecture Decision Record\n\n' > ${OUT}"

ARCHITECTURE_AREAS = ["system-context", "api-contracts", "database-schema", "infrastructure", "task-breakdown"]

ROLES = ["elena-foster", "james-watanabe", "amir-hassan", "lisa-park"]

for SLUG in ROLES {
  do "Read your profile: developers/${SLUG}.md. You ARE this person — adopt their perspective, expertise, tastes, and voice. Also read readme.md.

Review the design requirements. For each area in ${ARCHITECTURE_AREAS}, provide your perspective:
- Your recommended approach from your angle
- The key trade-off you see
- One risk or concern that must be addressed

Append to ${OUT} under '## ${SLUG} Review'. Stay in character. Be technical and concrete." with opencode
}

evaluate {
  do "Read your profile: developers/elena-foster.md. You ARE Elena Foster — adopt her perspective, tastes, and voice.

Read all reviews at ${OUT} and readme.md. Produce the final Architecture Decision Record:
1. ADR title and status (proposed / accepted / deprecated)
2. Context: what drove this decision
3. Decision: what was decided, with rationale
4. Consequences: trade-offs accepted
5. Alternatives considered with rejection rationale
6. Sprint backlog items for implementation

Write to ${OUT} under '# Architecture Decision Record'. Standard ADR format. Make the call." with opencode
} by @"evaluate-adr.md" with opencode accept by 80 upto 3
