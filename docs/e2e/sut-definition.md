# SUT Definition Checklist

## Metadata

- Owner: QA Lead
- Status: Drafted (Blocked)
- Priority: P0
- Last Updated: 2026-02-26
- Reviewer: Engineering Lead

## Goal

Define the system under test (SUT) with enough precision to create real E2E tests.

## Checklist

- [x] SUT name and scope defined.
- [x] Runtime type defined (web app, API, CLI, hybrid).
- [x] Entry points listed (URLs, routes, commands).
- [x] In-scope user journeys listed.
- [x] Out-of-scope areas listed.
- [x] Environments listed (local, CI, staging).
- [x] Auth model described (if applicable).

## Template

## SUT Name
- Value: Context-Engineering-Template (template SUT, not product runtime)

## Scope
- In Scope: Markdown protocols, workflow definitions, agent/skill configuration, structural validation scripts.
- Out of Scope: Any executable product UI/API E2E flow.

## Runtime
- Type: Zero-runtime template
- Start Command: N/A (no product runtime)

## Entry Points
- UI: N/A
- API: N/A
- CLI: `claude` workflow usage and bash validation scripts (structural checks only)

## Critical Journeys
1. Create and maintain planning/implementation markdown artifacts.
2. Execute BMAD workflow instructions with correct artifacts.
3. Run template validation scripts (non-product E2E).

## Current Readiness Note

This SUT does not expose a real UI/API for end-user E2E automation. Product E2E remains blocked until a concrete runtime app exists.

## Sign-off
- [x] QA Lead approved
- [ ] Engineering Lead approved
