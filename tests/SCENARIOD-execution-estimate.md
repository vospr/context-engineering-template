# Scenario D: SDD Spec Lifecycle — Execution Estimate

Date: 2026-02-18

## Overview

Scenario D validates the SDD (Spec-Driven Development) pipeline behaviorally — not just structurally — by exercising the full spec lifecycle from planning through verification in a single autonomous prompt. It targets a minimal Node.js "health check" feature (GET /health → {"status":"ok","timestamp":"<ISO>"}).

## Pre-Execution Fixes Applied

### Permission Settings Updated
The previous run attempt (screenshots Screen1–Screen11) revealed **11 confirmation prompts** that blocked autonomous execution, violating the `interaction_count = 1` requirement. The following bash patterns were added to `.claude/settings.local.json`:

| Pattern | Covers | Screenshot Evidence |
|---------|--------|-------------------|
| `Bash(git -C:*)` | git operations with -C path flag | Screen1, Screen4, Screen5, Screen6 |
| `Bash(git checkout:*)` | branch creation | Screen1 |
| `Bash(git status:*)` | staged file verification | Screen5 |
| `Bash(cd:*)` | all cd-prefixed compound commands | Screen2, Screen7, Screen8, Screen10, Screen11 |
| `Bash(npm install:*)` | dependency installation | Screen2 |
| `Bash(test:*)` | file existence checks | Screen3 |
| `Bash(mkdir:*)` | directory creation | Screen9 |
| `Bash(curl:*)` | HTTP endpoint verification | Screen7, Screen11 |
| `Bash(timeout:*)` | timed server start/test | Screen7 |
| `Bash(node:*)` | Node.js server execution | Screen7, Screen11 |
| `Bash(kill:*)` | process cleanup after tests | Screen7, Screen11 |
| `Bash(bash -c:*)` | subshell commands | Screen7 |

### README Update Condition
Added project condition: when Scenario D successfully executes, README.md is updated with the validation results section documenting which test case the project realized.

## Expected Agent Dispatch Sequence

| Step | Agent | Model | Purpose | Est. Tokens |
|------|-------|-------|---------|-------------|
| 1 | Main Agent | sonnet | Read state, classify complexity, init dispatch | ~2,000 |
| 2 | Planner | sonnet | Tier classification (SIMPLE), author spec packet with YAML assertions, create feature-tracker.json | ~8,000–12,000 |
| 3 | Implementer | sonnet | Scaffold Node.js project (package.json, express, jest), create src/app.js, src/routes/health.js, src/server.js, write tests | ~15,000–25,000 |
| 4 | Implementer | sonnet | npm install, run tests, collect assertion evidence, write implementation artifact | ~8,000–12,000 |
| 5 | Tester/Reviewer | sonnet | Verify assertions independently, validate spec compliance, evidence report | ~5,000–8,000 |
| 6 | Main Agent | sonnet | Update feature-tracker.json, write final summary, git commit | ~3,000–5,000 |
| **Total** | | | | **~41,000–64,000** |

## Expected Tier Classification

- **Tier: SIMPLE** — Single endpoint, clear requirements, ≤3 files, no architectural decisions needed
- Rationale: GET /health returning static JSON is below MODERATE threshold (no cross-cutting concerns, no data layer, no auth)
- Routing: Planner writes minimal spec packet inline in task description; no full spec overview document needed

## Expected Spec Packet

```yaml
--- SPEC ---
version: 1
intent: "Implement GET /health endpoint returning JSON status with timestamp"
assertions:
  - id: A1
    positive: "GET /health MUST return HTTP 200 with Content-Type application/json"
    negative: "GET /health MUST NOT return non-200 status codes for healthy server"
  - id: A2
    positive: "Response body MUST contain 'status' field with value 'ok'"
    negative: "Response body MUST NOT omit 'status' field"
  - id: A3
    positive: "Response body MUST contain 'timestamp' field with ISO 8601 format"
    negative: "Response body MUST NOT return timestamp in non-ISO format"
  - id: A4
    positive: "Server MUST listen on PORT environment variable with fallback to 3000"
    negative: "Server MUST NOT hard-code port number without env override"
constraints:
  - "Express.js framework"
  - "Jest + supertest for testing"
  - "App/server split pattern (app exports without listen)"
file_scope:
  - src/app.js
  - src/routes/health.js
  - src/server.js
  - tests/health.test.js
  - package.json
--- END SPEC ---
```

## Expected Artifacts Created

| Artifact | Path | Purpose |
|----------|------|---------|
| Spec packet | Embedded in TaskList task description | SDD spec with assertions |
| Feature tracker | planning-artifacts/feature-tracker.json | Feature lifecycle state |
| Implementation code | src/app.js, src/routes/health.js, src/server.js | Health check endpoint |
| Tests | tests/health.test.js | Assertion verification |
| Package config | package.json, package-lock.json | Dependencies |
| Evidence report | implementation-artifacts/2026-MM-DD-impl-T-{id}.md | Per-assertion PASS/FAIL evidence |
| Implementation artifact | implementation-artifacts/2026-MM-DD-impl-T-{id}.md | Implementation notes |

## Expected Behavioral Check Results (22 checks)

| Check | Expected | Confidence | Notes |
|-------|----------|------------|-------|
| A1: Spec delimiters | PASS | High | Planner trained on spec-protocol.md |
| A2: Spec fields | PASS | High | Standard YAML packet format |
| A3: Controlled vocabulary | PASS | High | Quality gate enforced |
| A4: Double-entry assertions | PASS | Medium | Depends on planner thoroughness |
| A5: 7x7 rule | PASS | High | Only 3-4 assertions needed |
| B1: Tier stated | PASS | High | Required by dispatch loop |
| B2: Tier reasoning | PASS | Medium | May be brief for SIMPLE |
| B3: Routing matches tier | PASS | High | SIMPLE → inline spec |
| C1: Evidence format | PASS | High | Implementer trained on format |
| C2: All IDs covered | PASS | High | Small assertion set |
| C3: file:line valid | PASS | Medium | Depends on accurate line refs |
| C4: No unresolved FAIL | PASS | Medium | Simple feature, low risk |
| D1: Tracker created | PASS | High | Required deliverable |
| D2: Valid JSON | PASS | High | Standard format |
| D3: Required fields | PASS | Medium | Depends on field completeness |
| D4: Phase correct | PASS | Medium | Should be DONE if all pass |
| E1: Impl artifact | PASS | High | Standard workflow |
| E2: Cold-start readable | PASS | Medium | Depends on artifact quality |
| E3: Git commit format | PASS | High | [T-{id}] format enforced |
| F1: Planner dispatched | PASS | High | Required for spec |
| F2: Implementer dispatched | PASS | High | Required for code |
| F3: Verifier dispatched | PASS | Medium | May skip if confidence high |

**Expected score: 20-22 / 22** (≥18 required to pass)

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Permission prompt blocks execution | **Eliminated** | High | Updated settings.local.json with 12 new patterns |
| npm install fails (network) | Low | High | Pre-install in clean state |
| Port conflict on 3000/3099 | Low | Medium | PORT env var override |
| Spec uses vague terms | Low | Medium | Quality gate in spec-protocol.md |
| Feature tracker missing fields | Medium | Low | Check D3 manually |
| Tester agent not dispatched | Medium | Low | Reviewer can substitute (F3) |

## Token Budget Estimate

| Component | Estimated Tokens |
|-----------|-----------------|
| CLAUDE.md + agent loading | ~3,000 |
| spec-protocol.md (on demand) | ~4,000 |
| Agent dispatches (4-6 agents) | ~35,000–55,000 |
| Tool calls (bash, file ops) | ~5,000–10,000 |
| **Total estimated** | **~47,000–72,000** |
| Budget ceiling | 128,000 |
| **Headroom** | **~56,000–81,000 (44-63%)** |

## Execution Checklist

- [x] Permission settings updated (11 new patterns)
- [x] README update condition added
- [ ] Clean state prepared (`git checkout . && git clean -fd` in target folder)
- [ ] Verify spec-protocol.md exists
- [ ] Verify NO feature-tracker.json exists
- [ ] Record start metrics (`/cost`)
- [ ] Submit Scenario D prompt (single prompt, no follow-up)
- [ ] Wait for completion
- [ ] Record end metrics
- [ ] Run behavioral validation checklist (22 checks)
- [ ] Fill in reporting template
