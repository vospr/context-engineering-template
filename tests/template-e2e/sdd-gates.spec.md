# E2E-TPL-003 SDD Governance and Gate Signals

- Scenario ID: `E2E-TPL-003`
- Criticality: `High`
- Owner: `QA`

## Objective

Validate that SDD governance references and gate concepts are present in core template artifacts.

## Assertions

1. `.claude/skills/spec-protocol.md` exists.
2. `spec-protocol.md` contains `Controlled Vocabulary`.
3. `spec-protocol.md` contains `Assertion Quality Gate`.
4. `CLAUDE.md` references `spec-protocol.md` and `spec_tier`.

## Evidence Paths

- `.claude/skills/spec-protocol.md`
- `CLAUDE.md`

