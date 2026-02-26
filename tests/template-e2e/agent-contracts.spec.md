# E2E-TPL-002 Agent Contract Integrity

- Scenario ID: `E2E-TPL-002`
- Criticality: `Critical`
- Owner: `QA`

## Objective

Validate the core agent set exists and each agent contract has required frontmatter fields.

## Assertions

1. Required agents exist:
   - `.claude/agents/researcher.md`
   - `.claude/agents/planner.md`
   - `.claude/agents/architect.md`
   - `.claude/agents/implementer.md`
   - `.claude/agents/reviewer.md`
   - `.claude/agents/tester.md`
2. Each required agent contains frontmatter keys:
   - `name`
   - `model`
   - `description`
   - `tools`

## Evidence Paths

- `.claude/agents/*.md`

