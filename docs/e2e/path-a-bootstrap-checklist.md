# Path A Bootstrap Checklist (Template Workflow E2E)

## Metadata

- Owner: QA Lead + DevOps
- Status: In Progress
- Priority: P0
- Last Updated: 2026-02-26
- Reviewer: Engineering Lead

## Goal

Stand up executable template-level E2E/system tests for this zero-runtime repository.

## Scope

- In scope: workflow integrity, dispatch/gating invariants, docs and artifact consistency, failure/recovery behavior.
- Out of scope: browser UI flows and runtime API product behavior.

## Week 1 Execution Checklist

- [x] Create `tests/template-e2e/` directory structure.
- [x] Add baseline scenario specs:
  - [x] `dispatch-loop.spec.md`
  - [x] `agent-contracts.spec.md`
  - [x] `sdd-gates.spec.md`
  - [x] `recovery-fallback.spec.md`
  - [x] `docs-integrity.spec.md`
- [x] Add script runner (`tests/run-template-e2e.sh` or `.ps1`) that evaluates all scenarios.
- [x] Add machine-readable result output (`PASS/FAIL + evidence path`).
- [x] Add CI workflow job to run template E2E on pull requests.
- [x] Set blocking rule: fail PR on any critical scenario failure (workflow-enforced; set required status check in repository settings).

## Acceptance Criteria

- [x] At least five template scenarios execute in CI.
- [x] Each failing check points to file evidence.
- [ ] PR status check is blocking for critical failures. (Pending repository branch protection required check setup)
- [x] Test report generated under `_bmad-output/test-artifacts/`.

## Risks and Mitigations

| Risk | Impact | Mitigation | Owner |
| --- | --- | --- | --- |
| Over-coupled checks cause noisy failures | Medium | Keep checks invariant-focused and stable | QA |
| CI runtime grows too much | Medium | Parallelize read-only checks and keep critical subset | DevOps |
| Ambiguous expectations across docs | High | Add explicit expected outputs per scenario | Product + QA |

## Sign-off

- [ ] QA Lead approved
- [ ] DevOps approved
- [ ] Engineering Lead approved
