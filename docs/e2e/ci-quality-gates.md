# CI Quality Gates Checklist

## Metadata

- Owner: DevOps + QA
- Status: In Progress
- Priority: P1
- Last Updated: 2026-02-26
- Reviewer: Engineering Lead

## Goal

Define E2E quality gates that block unsafe merges.

## Checklist

- [x] E2E runs on pull requests.
- [x] Critical scenarios marked and required to pass.
- [x] Failure threshold policy defined.
- [x] Retry policy defined.
- [x] Artifact upload on failure enabled.
- [x] Merge blocking condition documented.

## Gate Policy

| Gate | Rule | Blocking | Owner | Status |
| --- | --- | --- | --- | --- |
| E2E smoke | Must pass on PR | Yes | QA | Implemented (template-e2e-critical-gate) |
| Critical flows | 100% pass | Yes | QA | Implemented |
| Non-critical flows | >=95% pass | Optional | QA | N/A (Path A initial scope) |

## Pipeline Hook Points
- Trigger: `pull_request`
- Job name: `template-e2e-critical-gate`
- Artifact path: `_bmad-output/test-artifacts/template-e2e/*`
- Notification path: GitHub PR checks

## Sign-off
- [x] DevOps approved
- [ ] QA approved

## Notes

- Workflow file: `.github/workflows/template-e2e.yml`
- To make the gate truly blocking, set `template-e2e-critical-gate` as a required status check in branch protection rules.
