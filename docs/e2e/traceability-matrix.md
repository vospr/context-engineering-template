# Requirement to E2E Traceability Matrix

## Metadata

- Owner: Product + QA
- Status: In Progress
- Priority: P1
- Last Updated: 2026-02-26
- Reviewer: Engineering Lead

## Goal

Map requirements to executable E2E scenarios and test files.

## Checklist

- [x] Source requirements list baselined.
- [x] Critical journeys mapped to scenarios.
- [x] Each scenario has expected outcome.
- [ ] Each scenario mapped to test file path.
- [x] Priority tags assigned (Critical/High/Medium).
- [x] Coverage gaps identified.

## Matrix

| Requirement ID | Requirement Summary | Journey | Scenario ID | Priority | Planned Test File | Status | Owner |
| --- | --- | --- | --- | --- | --- | --- | --- |
| FR-Template-001 | Dispatch loop invariants are enforced | Main orchestration loop checks | E2E-TPL-001 | Critical | `tests/template-e2e/dispatch-loop.spec.md` | Planned | QA |
| FR-Template-002 | Agent manifests and role contracts are consistent | Agent loading and constraints | E2E-TPL-002 | Critical | `tests/template-e2e/agent-contracts.spec.md` | Planned | QA |
| FR-Template-003 | SDD lifecycle and gating rules are coherent | Spec-driven workflow execution | E2E-TPL-003 | High | `tests/template-e2e/sdd-gates.spec.md` | Planned | QA |
| FR-Template-004 | Recovery behavior is deterministic | Corruption and fallback handling | E2E-TPL-004 | High | `tests/template-e2e/recovery-fallback.spec.md` | Planned | QA |
| FR-Template-005 | Documentation graph remains internally valid | Cross-file references and ownership | E2E-TPL-005 | Medium | `tests/template-e2e/docs-integrity.spec.md` | Planned | QA |

## Gap Log

| Gap ID | Missing Coverage | Impact | Proposed Fix | Owner | ETA | Status |
| --- | --- | --- | --- | --- | --- | --- |
| GAP-01 | No template E2E harness in repo | Cannot execute Path A tests | Add `tests/template-e2e/` + runner scripts | QA + DevOps | TBD | Open |
| GAP-02 | No CI gate for template E2E | Regressions can merge silently | Add CI workflow with blocking status checks | DevOps | TBD | Open |
| GAP-03 | No baseline expected-output snapshots | Hard to detect behavior drift | Add canonical fixtures/expected reports | QA | TBD | Open |

## Sign-off
- [ ] Product approved
- [ ] QA approved
