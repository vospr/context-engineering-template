# Failure Observability Checklist

## Metadata

- Owner: DevOps + QA
- Status: Blocked
- Priority: P2
- Last Updated: 2026-02-26
- Reviewer: Engineering Lead

## Goal

Ensure each E2E failure has enough artifacts for fast root cause analysis.

## Checklist

- [ ] Screenshot capture on failure enabled. (Blocked: no framework)
- [x] Video capture policy defined.
- [ ] Trace/log capture enabled. (Blocked)
- [ ] Console/network logs captured. (Blocked)
- [x] CI artifact retention window defined.
- [x] Failure triage template created.

## Artifact Standard

| Artifact | Required | Path Pattern | Retention | Owner |
| --- | --- | --- | --- | --- |
| Screenshot | Yes | `artifacts/screenshots/` | 14 days | QA |
| Video | Optional | `artifacts/videos/` | 7 days | QA |
| Trace | Yes | `artifacts/traces/` | 14 days | DevOps |
| Logs | Yes | `artifacts/logs/` | 14 days | DevOps |

## Triage Template

- Failure ID:
- Test case:
- First failing step:
- Suspected layer (app/test/env):
- Next action:

## Current State

Standard is defined but cannot be enforced until an E2E framework is added and running in CI.

## Sign-off
- [ ] DevOps approved
- [ ] QA approved
