# Flakiness Policy Checklist

## Metadata

- Owner: QA Lead
- Status: Blocked
- Priority: P2
- Last Updated: 2026-02-26
- Reviewer: DevOps

## Goal

Control and reduce flaky E2E tests over time.

## Checklist

- [x] Flaky test definition agreed.
- [x] Retry limits defined.
- [ ] Quarantine process defined. (Blocked: no E2E suite yet)
- [ ] Auto-ticketing/reporting rule defined. (Blocked)
- [x] MTTR target for flaky tests defined.
- [ ] Exit criteria from quarantine defined. (Blocked)

## Policy

## Definition
- A test is flaky if: it fails intermittently with unchanged code and environment inputs.

## Retry Rules
- Max retries: 2
- Retry scope: E2E PR smoke only

## Quarantine
- Owner: QA Lead
- SLA: triage in 1 business day
- Merge behavior: blocked if critical scenario remains flaky after retry budget

## Metrics
| Metric | Target | Current | Status |
| --- | --- | --- | --- |
| Flake rate | <2% | TBD | Not Started |
| Mean time to fix | <3 days | TBD | Not Started |

## Sign-off
- [ ] QA Lead approved
- [ ] DevOps approved
