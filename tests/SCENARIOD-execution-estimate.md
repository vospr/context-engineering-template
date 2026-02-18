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
| 1 | Main Agent | sonnet | Read state, classify COMPLEX, init dispatch | ~2,000 |
| 2 | Architect | opus | Pre-check: ADR for Express/Jest/supertest stack | ~5,000–8,000 |
| 3 | Planner | sonnet | Full spec suite: 4 tasks (26 assertions), overview, plan, feature tracker | ~10,000–15,000 |
| 4 | Implementer | sonnet | T-1: Scaffold Node.js project, npm install | ~8,000–12,000 |
| 5 | Implementer + Reviewer | sonnet | T-2: Implement GET /health endpoint, worker-reviewer cycle | ~12,000–18,000 |
| 6 | Implementer + Reviewer | sonnet | T-3: Write Jest+supertest tests, worker-reviewer cycle | ~10,000–15,000 |
| 7 | Tester | sonnet | T-4: Validate feature, smoke test, evidence report | ~8,000–12,000 |
| 8 | Main Agent | sonnet | Update feature tracker to DONE, git commits | ~3,000–5,000 |
| **Total** | | | | **~58,000–87,000** |

## Expected Tier Classification

- **Tier: COMPLEX** — Greenfield scaffold, multi-component, high coupling; establishes framework, test stack, and architectural patterns
- Rationale: Node.js project initialization with Express, Jest, and supertest crosses the COMPLEX threshold: 5+ files, new architectural patterns, high coupling between test stack and application framework, and no prior codebase to build on
- Routing: COMPLEX → architect pre-check + planner writes full spec suite + overview

## Expected Spec Packets

Four spec packets are expected across 4 tasks (26 total assertions: 7+7+6+6).

**T-1: Scaffold Node.js project** (7 assertions — package.json, Express/Jest/supertest installation, app/server split, directory structure, .gitignore, README, git init)

**T-2: Implement GET /health endpoint** (7 assertions — HTTP 200, Content-Type application/json, status field, timestamp ISO 8601, PORT env var, app/server split pattern, error handling)

**T-3: Write Jest+supertest tests** (6 assertions — test file exists, supertest import, GET /health test, status:ok assertion, timestamp format assertion, all tests pass)

**T-4: Validate feature end-to-end** (6 assertions — server starts, endpoint reachable, JSON parseable, smoke test passes, feature-tracker.json updated to DONE, evidence report complete)

**Representative packet (T-2):**

```yaml
# --- SPEC ---
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
  - "MUST use Express.js framework"
  - "MUST use app/server split pattern (app.js exports without listen)"
  - "MUST NOT hard-code port"
file_scope:
  - src/app.js
  - src/routes/health.js
  - src/server.js
# --- END SPEC ---
```

## Expected Artifacts Created

Approximately 15 artifacts are produced in a successful run.

| Artifact | Path | Purpose |
|----------|------|---------|
| ADR | planning-artifacts/YYYY-MM-DD-adr-express-jest-supertest.md | Architect pre-check decision record |
| Spec overview | planning-artifacts/spec-F-001-health-check-overview.md | Feature-level spec summary (COMPLEX tier) |
| Feature tracker | planning-artifacts/feature-tracker.json | Feature lifecycle state (phase: DONE on completion) |
| Plan | planning-artifacts/YYYY-MM-DD-plan-health-check.md | Task breakdown and dependencies |
| Decisions log | planning-artifacts/decisions.md | Technology decisions (Express, Jest, supertest) |
| Spec packets (x4) | Embedded in TaskList task descriptions T-1 through T-4 | SDD specs with 26 total assertions |
| Implementation code | src/app.js, src/routes/health.js, src/server.js | Health check endpoint |
| Tests | tests/health.test.js | Jest+supertest assertion verification |
| Package config | package.json, package-lock.json | Dependencies |
| Impl artifact T-1 | implementation-artifacts/YYYY-MM-DD-impl-T-1.md | Scaffold notes + evidence |
| Impl artifact T-2 | implementation-artifacts/YYYY-MM-DD-impl-T-2.md | Endpoint implementation notes + evidence |
| Impl artifact T-3 | implementation-artifacts/YYYY-MM-DD-impl-T-3.md | Test implementation notes + evidence |
| Review T-2 | implementation-artifacts/YYYY-MM-DD-review-T-2.md | Reviewer feedback on endpoint |
| Review T-3 | implementation-artifacts/YYYY-MM-DD-review-T-3.md | Reviewer feedback on tests |
| Test report T-4 | implementation-artifacts/YYYY-MM-DD-test-T-4.md | Tester evidence report, smoke test results |

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
| Agent dispatches (6-8 agents) | ~55,000–80,000 |
| Tool calls (bash, file ops) | ~8,000–16,000 |
| **Total estimated** | **~70,000–100,000** |
| Budget ceiling | 128,000 |
| **Headroom** | **~28,000–58,000 (22-45%)** |

## Known Gaps from Initial Run

The first Scenario D execution (before permission fixes) revealed these gaps:

| # | Gap | Severity | Resolution |
|---|-----|----------|-----------|
| 1 | Feature tracker `phase: "VERIFIED"` instead of `"DONE"` | MAJOR | Clarified in spec-protocol.md Section 12 — Slice 1 MUST use DONE; added explicit instruction to scenario prompt |
| 2 | Task IDs `T-1` instead of `T-001` (zero-padded) | MINOR | Cosmetic; Section 9 specifies T-{NNN} format |
| 3 | Evidence format: tables instead of canonical bullets | MINOR | T-003 matched Section 11; T-001/T-002 used tables |
| 4 | Off-by-one line number references | MINOR | Common LLM behavior; reviewer caught but approved |
| 5 | Extra fields in feature-tracker.json | MINOR | Harmless per "ignore unrecognized fields" rule |
| 6 | 11 confirmation prompts blocked autonomy | CRITICAL | Fixed — 12 bash patterns added to settings.local.json |

**From-scratch reproducibility confidence:**
- Functional correctness: 95%
- COMPLEX routing compliance: 95%
- Protocol compliance: 85% (improved from 70% with prompt clarification and spec-protocol fix)

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
