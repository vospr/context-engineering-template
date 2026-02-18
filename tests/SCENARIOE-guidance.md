# SCENARIO E Guidance: Slice 4 Template-Driven CRUD with Full Metrics Validation

Date: 2026-02-18
Purpose: Validate that Slice 4 capabilities (spec templates, agent-specific views, metrics dashboard, permanent agent extensions) work end-to-end through a COMPLEX-tier CRUD feature that exercises template consumption.

## What This Scenario Validates

Scenarios A-C validate Context Engineering principles. Scenario D validates the SDD pipeline (Slices 1-3). **Scenario E validates Slice 4 specifically** — the production-grade scale layer that makes SDD permanent and measurable.

### Slice 4 Capabilities Covered

| Capability | Description | How Scenario E Exercises It |
|-----------|-------------|----------------------------|
| Template Consumption | Planner checks spec-templates/ before authoring | CRUD feature matches rest-crud-endpoint.yaml — planner must find and adapt it |
| Agent-Specific Spec Views | Dispatch loop filters spec fields per agent role | Prompt requires reporting what each agent received |
| Metrics Dashboard | Token tracking, assertion metrics, entropy score | Feature tracker must include Slice 4 extended fields |
| Permanent Agent Extensions | Planner/reviewer/tester have native SDD capabilities | Planner authors specs without skill dependency; reviewer validates evidence; tester executes assertions |
| Phase Fix Validation | Slice 1 states (DRAFT/ACTIVE/DONE) used correctly | Explicit instruction prevents VERIFIED regression |

## Scope

- Case A only (requires full template with spec-protocol.md + spec-templates/).
- Single-prompt autonomous execution (`interaction_count = 1`).
- CRUD feature scope — broader than Scenario D's health check, narrower than Scenario A's full API.
- Must exercise template consumption (the key Slice 4 differentiator from Scenario D).

## Prerequisites

### 1. Permission Settings

Ensure `.claude/settings.local.json` has the autonomous execution permissions. Required patterns:

```json
{
  "permissions": {
    "allow": [
      "Bash(git -C:*)", "Bash(git checkout:*)", "Bash(git status:*)",
      "Bash(git branch:*)", "Bash(git log:*)", "Bash(git diff:*)",
      "Bash(git add:*)", "Bash(git commit:*)", "Bash(git push:*)",
      "Bash(git remote add:*)",
      "Bash(cd:*)", "Bash(npm install:*)", "Bash(npm test:*)",
      "Bash(npm run:*)", "Bash(npx:*)", "Bash(node:*)",
      "Bash(mkdir:*)", "Bash(test:*)", "Bash(curl:*)",
      "Bash(timeout:*)", "Bash(kill:*)", "Bash(bash -c:*)",
      "Bash(ls:*)", "Bash(echo:*)", "Bash(tee:*)", "Bash(chmod:*)"
    ]
  }
}
```

### 2. Clean State

```bash
# From the Case A project folder (NOT Project_Template_backup):
git checkout . && git clean -fd
# Verify spec-protocol.md exists (SDD activation):
ls .claude/skills/spec-protocol.md
# Verify spec-templates exist (Slice 4 activation):
ls .claude/spec-templates/rest-crud-endpoint.yaml
# Verify NO feature-tracker.json exists yet:
ls planning-artifacts/feature-tracker.json  # should fail (not found)
```

### 3. Seed Files Required

No additional seed files beyond the standard template. The scenario validates that:
- Planner discovers and adapts spec templates from `.claude/spec-templates/`
- Feature tracker is bootstrapped with Slice 4 extended fields
- Metrics are computed and recorded

## Scenario Prompt (copy-paste exactly)

```text
Using the SDD spec-protocol with Slice 4 capabilities, implement a "bookmarks" CRUD API for a Node.js application.

Requirements:
1. Use the spec-driven development workflow defined in .claude/skills/spec-protocol.md.
2. Classify this feature as COMPLEX tier (greenfield CRUD, multi-file, establishes patterns).
3. The planner MUST check .claude/spec-templates/ for a matching template pattern BEFORE authoring specs from scratch. If rest-crud-endpoint.yaml matches, adapt it — do NOT copy blindly.
4. The planner MUST author YAML spec packets with assertions using controlled vocabulary (MUST/MUST NOT) and double-entry (positive + negative).
5. The dispatch loop MUST apply agent-specific spec views per CLAUDE.md Step 5:
   - Planner receives: version + intent + title only
   - Implementer receives: full spec packet
   - Reviewer receives: spec packet + evidence report
   - Tester receives: assertions + file_scope + constraints only
6. The implementer MUST report evidence for every assertion in format: {id}: PASS|FAIL — {file}:{line} ({brief evidence}).
7. Create or update planning-artifacts/feature-tracker.json with Slice 4 extended fields: tier, token_budget, token_spent, assertions_total, assertions_passing.
8. Use Slice 1 lifecycle states (DRAFT/ACTIVE/DONE) for the feature tracker phase field — do NOT use Slice 3 extended states.
9. Work autonomously — no follow-up interaction.

Feature scope:
- POST /bookmarks — create a bookmark (title, url required; description optional) → 201
- GET /bookmarks — list all bookmarks → 200
- GET /bookmarks/:id — get single bookmark → 200 or 404
- PUT /bookmarks/:id — update bookmark → 200 or 404
- DELETE /bookmarks/:id — delete bookmark → 204 or 404
- In-memory storage (Map with UUID keys)
- Input validation: title and url required, url must be valid format
- Express.js, Jest + supertest for testing

Deliverables:
- Spec packet(s) with assertions (adapted from template where applicable)
- Architecture Decision Record
- Implementation code and tests
- Per-assertion evidence report
- Updated feature-tracker.json with Slice 4 fields
- Metrics: token_budget, token_spent, assertions_total, assertions_passing, entropy_score
- Artifacts enabling a cold-start session to resume from files alone

Final response must include:
1) Template match analysis (which template was used, what was adapted vs added)
2) Tier classification and reasoning
3) Spec packet(s) authored
4) Agent-specific spec views applied (what each agent received)
5) What was implemented (files created/modified)
6) Assertion evidence table ({id}: PASS|FAIL — {file}:{line})
7) Test results
8) Feature tracker state with Slice 4 extended fields
9) Metrics summary (token budget vs spent, assertion pass rate, entropy score)
10) Current status and next recommended task
```

## Execution Procedure

1. Open a fresh Claude Code session in the Case A project folder (with Slice 4 files present).
2. Record start metrics (`/cost` if available).
3. Submit the Scenario E prompt once.
4. Do not send follow-up input during execution.
5. Wait until agent completion.
6. Record end metrics.
7. Run the behavioral validation checklist below.

## Behavioral Validation Checklist

### A. Spec Packet Quality (5 checks) — Same as Scenario D

- [ ] **A1:** At least one task description contains `--- SPEC ---` and `--- END SPEC ---` delimiters
- [ ] **A2:** Spec packet has `version: 1`, `intent:`, `assertions:`, `constraints:`, `file_scope:` fields
- [ ] **A3:** Every assertion uses controlled vocabulary (MUST, MUST NOT, SHOULD, MAY) — no vague terms
- [ ] **A4:** Each assertion has both `positive:` and `negative:` (double-entry)
- [ ] **A5:** Assertion count ≤ 7 per task (7x7 rule)

### B. Tier Classification (3 checks) — Same as Scenario D

- [ ] **B1:** Agent explicitly states COMPLEX tier classification
- [ ] **B2:** Classification reasoning references the decision table from spec-protocol.md Section 6
- [ ] **B3:** Routing matches tier — COMPLEX: architect pre-check + planner spec suite + overview

### C. Evidence Reporting (4 checks) — Same as Scenario D

- [ ] **C1:** Evidence report exists with format `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
- [ ] **C2:** Every assertion ID from the spec packet appears in the evidence report
- [ ] **C3:** Every `file:line` reference points to an actual file with relevant code at that line
- [ ] **C4:** No FAIL results (or if FAIL, retry cycle was attempted)

### D. Feature Tracker (4 checks) — Same as Scenario D

- [ ] **D1:** `planning-artifacts/feature-tracker.json` was created or updated
- [ ] **D2:** JSON is valid (parseable)
- [ ] **D3:** Entry has required fields: `id`, `title`, `phase`, `spec_overview`, `tasks`, `verified`
- [ ] **D4:** Phase is `DONE` (Slice 1 state, NOT `VERIFIED`)

### E. Session Continuity (3 checks) — Same as Scenario D

- [ ] **E1:** Implementation artifact written to `implementation-artifacts/`
- [ ] **E2:** A new session reading only files can determine: what was built, what passed, what's next
- [ ] **E3:** Git commit(s) made with task ID in commit message format `[T-{id}] {description}`

### F. Agent Orchestration (3 checks) — Same as Scenario D

- [ ] **F1:** Planner agent was dispatched (spec authoring)
- [ ] **F2:** Implementer agent was dispatched (code writing)
- [ ] **F3:** At least one of: tester dispatched OR reviewer dispatched (verification)

### G. Slice 4 Capabilities (6 NEW checks)

- [ ] **G1:** Planner checked `.claude/spec-templates/` for a matching template before authoring
- [ ] **G2:** Template assertions were adapted (not blindly copied) — at least 1 assertion added, removed, or modified from the template
- [ ] **G3:** Agent-specific spec views applied — output shows what each agent role received (filtered fields)
- [ ] **G4:** Feature tracker has Slice 4 extended fields (`tier`, `token_budget`, `token_spent`, `assertions_total`, `assertions_passing`)
- [ ] **G5:** Entropy score computed and recorded (either in tracker or metrics summary)
- [ ] **G6:** Planner operated as permanent native capability (not described as skill-dependent in output)

### Total: 28 behavioral checks

## Metrics to Record

| Metric | Description |
|--------|-------------|
| `start_tokens` | Token count at session start |
| `end_tokens` | Token count at session end |
| `tokens_used` | Delta |
| `interaction_count` | Must be `1` |
| `spec_packets_authored` | Count of YAML spec packets created |
| `template_used` | Which template was matched (e.g., rest-crud-endpoint.yaml) |
| `template_adaptations` | Count of assertions added/removed/modified from template |
| `tier_classified` | Which tier was selected |
| `assertions_total` | Total assertion IDs across all specs |
| `assertions_pass` | Count of PASS results |
| `assertions_fail` | Count of FAIL results |
| `feature_tracker_created` | Yes/No |
| `slice4_fields_present` | Yes/No (tier, token_budget, token_spent, etc.) |
| `entropy_score` | Recorded value |
| `agents_dispatched` | List of agent types dispatched |
| `spec_views_applied` | Yes/No (filtered dispatch reported) |
| `behavioral_checks_pass` | Count out of 28 |
| `behavioral_checks_fail` | Count out of 28 |
| `test_result` | Test suite pass/fail |
| `artifacts_created` | List of files created/updated |

## Pass/Fail Criteria

### Pass (all required)

- `interaction_count = 1`
- At least one valid spec packet authored with template adaptation documented
- Evidence report covers all assertion IDs
- `feature-tracker.json` created with valid schema AND Slice 4 extended fields
- `behavioral_checks_pass ≥ 23` out of 28 (allows minor gaps)
- Tests pass (if tests were written)
- Phase field is `DONE` (not `VERIFIED`)

### Fail (any of these)

- Agent blocks awaiting user clarification (`interaction_count > 1`)
- No spec packet authored (SDD pipeline not activated)
- Planner did NOT check spec-templates/ (Slice 4 template consumption not exercised)
- No evidence report (assertions not verified)
- `feature-tracker.json` not created or missing Slice 4 fields
- `behavioral_checks_pass < 23` (systemic failure)
- Spec uses vague terms banned by quality gate
- Phase uses Slice 3 extended state instead of DONE

## Reporting Template

```markdown
## Scenario E: Slice 4 Template-Driven CRUD Validation
Date: YYYY-MM-DD

### Metrics
- Start tokens:
- End tokens:
- Tokens used:
- Interaction count:
- Tier classified:
- Template used:
- Template adaptations:
- Spec packets authored:
- Assertions total:
- Assertions PASS:
- Assertions FAIL:
- Feature tracker created:
- Slice 4 fields present:
- Entropy score:
- Agents dispatched:
- Spec views applied:
- Test result:

### Behavioral Checks: __/28
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
| D4: Phase is DONE | PASS/FAIL | |
| E1: Impl artifact | PASS/FAIL | |
| E2: Cold-start readable | PASS/FAIL | |
| E3: Git commit format | PASS/FAIL | |
| F1: Planner dispatched | PASS/FAIL | |
| F2: Implementer dispatched | PASS/FAIL | |
| F3: Verifier dispatched | PASS/FAIL | |
| G1: Template checked | PASS/FAIL | |
| G2: Template adapted | PASS/FAIL | |
| G3: Spec views applied | PASS/FAIL | |
| G4: Slice 4 tracker fields | PASS/FAIL | |
| G5: Entropy score recorded | PASS/FAIL | |
| G6: Permanent capability | PASS/FAIL | |

### Artifacts Created
- [ ] list files here

### Pass/Fail: ___
### Notes:
```

## Comparison with Other Scenarios

| Aspect | Scenario C (9) | Scenario D (10) | Scenario E (11) |
|--------|---------------|-----------------|-----------------|
| Focus | Autonomous vertical slice | SDD pipeline (Slices 1-3) | Slice 4 capabilities |
| What it proves | Agent can build clean code from one prompt | SDD spec lifecycle works E2E | Template consumption + metrics + views work |
| Prompt scope | Full TODO API | Minimal health check | CRUD bookmarks API |
| Key artifact | Working code + tests | Spec packets + evidence + tracker | Template adaptation + metrics + filtered views |
| Pass gate | Code quality, lint, tests | 22 behavioral checks (≥18) | 28 behavioral checks (≥23) |
| Slice 4-specific | No | No | **Yes** |
| Template exercised | No | No | **rest-crud-endpoint.yaml** |
| Metrics tracked | No | No | **token_budget, assertions, entropy** |
