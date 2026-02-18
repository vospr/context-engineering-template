# SCENARIO D Guidance: SDD Spec Lifecycle End-to-End Validation

Date: 2026-02-18
Purpose: Validate that the SDD (Spec-Driven Development) pipeline works behaviorally — not just structurally — by exercising the full spec lifecycle from planning through verification in a single autonomous prompt.

## What This Scenario Validates

Scenarios 1-8 validate Context Engineering principles (retrieval, reduction, governance, offloading). Scenario C (9) validates autonomous execution of a vertical slice. **Scenario D validates the SDD machinery itself** — the behaviors that `validate-sdd.sh` can only check structurally.

### Behavioral Gaps Covered

| Gap | Description | How Scenario D Exercises It |
|-----|-------------|----------------------------|
| Spec Lifecycle | DRAFT → ACTIVE → DONE state transitions | Planner authors spec, implementer executes, evidence closes it |
| Tier Router | TRIVIAL tasks skip spec; SIMPLE+ get full spec | Prompt requests 2 tasks at different tiers |
| Spec Packet Delivery | YAML packets embedded in TaskList descriptions | Planner writes `--- SPEC ---` delimited packets into tasks |
| Assertion Evidence | `{id}: PASS\|FAIL — {file}:{line}` format | Implementer must report per-assertion evidence |
| Feature Tracker | `feature-tracker.json` creation and state machine | Dispatch loop creates tracker, updates phase on completion |
| Session Continuity | Cold-start session reconstructs state from files | Final output must enable a new session to resume from files alone |
| Agent SDD Extensions | Planner spec-authoring, tester assertion-execution | Planner classifies tier, tester verifies assertions independently |
| Quality Gate | Vague terms banned, controlled vocabulary enforced | Spec must use MUST/MUST NOT, not "works correctly" |

## Scope

- Case A only (requires the full template with `spec-protocol.md` present).
- Single-prompt autonomous execution (`interaction_count = 1`).
- Narrower implementation scope than Scenario C — the goal is to validate SDD behaviors, not build a large feature.

## Prerequisites

### 1. Permission Settings

Ensure `.claude/settings.local.json` has the autonomous execution permissions documented in `tests/SCENARIOC-guidance.md` (Prerequisites section). The same permission set applies here.

### 2. Clean State

```bash
# From the Case A project folder:
git checkout . && git clean -fd
# Verify spec-protocol.md exists (SDD activation):
ls .claude/skills/spec-protocol.md
# Verify NO feature-tracker.json exists yet:
ls planning-artifacts/feature-tracker.json  # should fail (not found)
```

### 3. Seed Files Required

No additional seed files beyond the standard template. The scenario validates that the SDD pipeline bootstraps its own artifacts (feature-tracker.json, spec overview, evidence reports) from scratch.

## Scenario Prompt (copy-paste exactly)

```text
Using the SDD spec-protocol, implement a minimal "health check" feature for a Node.js API.

Requirements:
1. Use the spec-driven development workflow defined in .claude/skills/spec-protocol.md.
2. The planner MUST author at least one YAML spec packet with assertions using controlled vocabulary (MUST/MUST NOT).
3. Classify the feature tier (TRIVIAL/SIMPLE/MODERATE/COMPLEX) and route accordingly.
4. The implementer MUST report evidence for every assertion in the format: {id}: PASS|FAIL — {file}:{line}.
5. Create or update planning-artifacts/feature-tracker.json with this feature's state.
6. Work autonomously — no follow-up interaction.
7. Keep scope minimal: one GET /health endpoint returning {"status":"ok"} with a timestamp.

Deliverables:
- Spec packet(s) with assertions
- Implementation code and tests
- Per-assertion evidence report
- Updated feature-tracker.json
- Artifacts enabling a cold-start session to resume from files alone

Final response must include:
1) Tier classification and reasoning
2) Spec packet(s) authored
3) What was implemented (files created/modified)
4) Assertion evidence table ({id}: PASS|FAIL — {file}:{line})
5) Test results
6) Feature tracker state
7) Current status and next recommended task
```

## Execution Procedure

1. Open a fresh Claude Code session in the Case A project folder.
2. Record start metrics (`/cost` if available).
3. Submit the Scenario D prompt once.
4. Do not send follow-up input during execution.
5. Wait until agent completion.
6. Record end metrics.
7. Run the behavioral validation checklist below.

## Behavioral Validation Checklist

After the run completes, manually verify each item. This is the core value of Scenario D — it validates *behaviors*, not just file existence.

### A. Spec Packet Quality (5 checks)

- [ ] **A1:** At least one task description contains `--- SPEC ---` and `--- END SPEC ---` delimiters
- [ ] **A2:** Spec packet has `version: 1`, `intent:`, `assertions:`, `constraints:`, `file_scope:` fields
- [ ] **A3:** Every assertion uses controlled vocabulary (MUST, MUST NOT, SHOULD, MAY) — no vague terms ("works", "correct", "proper", "appropriate")
- [ ] **A4:** Each assertion has both `positive:` and `negative:` (double-entry)
- [ ] **A5:** Assertion count ≤ 7 per task (7x7 rule)

### B. Tier Classification (3 checks)

- [ ] **B1:** Agent explicitly states the tier classification (TRIVIAL, SIMPLE, MODERATE, or COMPLEX)
- [ ] **B2:** Classification reasoning references the decision table from spec-protocol.md Section 6
- [ ] **B3:** Routing matches tier — TRIVIAL skips spec overview; SIMPLE+ includes full spec

### C. Evidence Reporting (4 checks)

- [ ] **C1:** Evidence report exists with format `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
- [ ] **C2:** Every assertion ID from the spec packet appears in the evidence report (no missing IDs)
- [ ] **C3:** Every `file:line` reference points to an actual file that exists with relevant code at that line
- [ ] **C4:** No FAIL results (or if FAIL, retry cycle was attempted)

### D. Feature Tracker (4 checks)

- [ ] **D1:** `planning-artifacts/feature-tracker.json` was created or updated
- [ ] **D2:** JSON is valid (parseable)
- [ ] **D3:** Entry has required fields: `id`, `title`, `phase`, `spec_overview`, `tasks`, `verified`
- [ ] **D4:** Phase reflects actual state (DONE if all assertions PASS, ACTIVE if still in progress)

### E. Session Continuity (3 checks)

- [ ] **E1:** Implementation artifact written to `implementation-artifacts/` or `_bmad-output/implementation-artifacts/`
- [ ] **E2:** A new session reading only files (no conversation history) can determine: what was built, what passed, what's next
- [ ] **E3:** Git commit(s) made with task ID in commit message format `[T-{id}] {description}`

### F. Agent Orchestration (3 checks)

- [ ] **F1:** Planner agent was dispatched (spec authoring)
- [ ] **F2:** Implementer agent was dispatched (code writing)
- [ ] **F3:** At least one of: tester dispatched OR reviewer dispatched (verification)

### Total: 22 behavioral checks

## Metrics to Record

| Metric | Description |
|--------|-------------|
| `start_tokens` | Token count at session start |
| `end_tokens` | Token count at session end |
| `tokens_used` | Delta |
| `interaction_count` | Must be `1` |
| `spec_packets_authored` | Count of YAML spec packets created |
| `tier_classified` | Which tier was selected |
| `assertions_total` | Total assertion IDs across all specs |
| `assertions_pass` | Count of PASS results |
| `assertions_fail` | Count of FAIL results |
| `feature_tracker_created` | Yes/No |
| `agents_dispatched` | List of agent types dispatched |
| `behavioral_checks_pass` | Count out of 22 |
| `behavioral_checks_fail` | Count out of 22 |
| `test_result` | Test suite pass/fail |
| `artifacts_created` | List of files created/updated |

## Pass/Fail Criteria

### Pass (all required)

- `interaction_count = 1`
- At least one valid spec packet authored with controlled vocabulary
- Evidence report covers all assertion IDs
- `feature-tracker.json` created with valid schema
- `behavioral_checks_pass ≥ 18` out of 22 (allows minor gaps in non-critical areas)
- Tests pass (if tests were written)

### Fail (any of these)

- Agent blocks awaiting user clarification (`interaction_count > 1`)
- No spec packet authored (SDD pipeline not activated)
- No evidence report (assertions not verified)
- `feature-tracker.json` not created (continuity broken)
- `behavioral_checks_pass < 18` (systemic SDD failure)
- Spec uses vague terms banned by quality gate

## Reporting Template

```markdown
## Scenario D: SDD Spec Lifecycle End-to-End
Date: YYYY-MM-DD

### Metrics
- Start tokens:
- End tokens:
- Tokens used:
- Interaction count:
- Tier classified:
- Spec packets authored:
- Assertions total:
- Assertions PASS:
- Assertions FAIL:
- Feature tracker created:
- Agents dispatched:
- Test result:

### Behavioral Checks: __/22
| Check | Result | Notes |
|-------|--------|-------|
| A1: Spec delimiters | PASS/FAIL | |
| A2: Spec fields | PASS/FAIL | |
| A3: Controlled vocabulary | PASS/FAIL | |
| A4: Double-entry assertions | PASS/FAIL | |
| A5: 7x7 rule | PASS/FAIL | |
| B1: Tier stated | PASS/FAIL | |
| B2: Tier reasoning | PASS/FAIL | |
| B3: Routing matches tier | PASS/FAIL | |
| C1: Evidence format | PASS/FAIL | |
| C2: All IDs covered | PASS/FAIL | |
| C3: file:line valid | PASS/FAIL | |
| C4: No unresolved FAIL | PASS/FAIL | |
| D1: Tracker created | PASS/FAIL | |
| D2: Valid JSON | PASS/FAIL | |
| D3: Required fields | PASS/FAIL | |
| D4: Phase correct | PASS/FAIL | |
| E1: Impl artifact | PASS/FAIL | |
| E2: Cold-start readable | PASS/FAIL | |
| E3: Git commit format | PASS/FAIL | |
| F1: Planner dispatched | PASS/FAIL | |
| F2: Implementer dispatched | PASS/FAIL | |
| F3: Verifier dispatched | PASS/FAIL | |

### Artifacts Created
- [ ] list files here

### Pass/Fail: ___
### Notes:
```

## Comparison with Other Scenarios

| Aspect | Scenario C (9) | Scenario D (10) |
|--------|---------------|-----------------|
| Focus | Autonomous vertical slice execution | SDD pipeline behavioral validation |
| What it proves | Agent can build code + tests from one prompt | SDD spec lifecycle works end-to-end |
| Prompt scope | Full TODO API slice | Minimal health check endpoint |
| Key artifact | Working code + tests | Spec packets + evidence + feature tracker |
| Pass gate emphasis | Code quality, lint, tests | Behavioral check coverage (22 items) |
| SDD-specific? | No (tests general autonomy) | Yes (tests spec-protocol machinery) |

## Notes for Existing Comparison Package

- Add Scenario D as Scenario 10 in the prompt set (after Scenario 9 / Scenario C).
- Scenario D is Case A only — SDD requires the template.
- This scenario complements Scenario C: C proves the agent can ship code; D proves the SDD pipeline orchestrates correctly.
- Scenario D results should be reported separately from the A-vs-B token comparison (it has no Case B equivalent since SDD is template-only).
