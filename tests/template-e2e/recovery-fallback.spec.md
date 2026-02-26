# E2E-TPL-004 Recovery and Fallback Signals

- Scenario ID: `E2E-TPL-004`
- Criticality: `High`
- Owner: `QA`

## Objective

Validate that explicit recovery/fallback guidance exists for dispatch and tracker corruption conditions.

## Assertions

1. `CLAUDE.md` contains blocked/escalation handling in the dispatch loop.
2. `.claude/skills/spec-protocol.md` contains tracker parse failure handling.
3. `.claude/skills/spec-protocol.md` references git-based tracker recovery.

## Evidence Paths

- `CLAUDE.md`
- `.claude/skills/spec-protocol.md`

