# Story 4.3: Constitution & Failure Pattern Library

Status: review

## Story

As a dispatch loop and planner agent,
I want a formal constitution document with immutable project principles and a failure pattern library that captures lessons learned,
so that the system enforces governance constraints automatically and prevents recurring failure patterns from affecting future specs.

## Acceptance Criteria

1. Constitution document exists at `planning-artifacts/constitution.md` with article format: Principle, Rationale, Enforcement, Violation response
2. Constitution articles override all lower governance layers (spec-protocol.md, skills, agent freedom) per governance cascade (Section 5)
3. Phase -1 gates execute before spec lifecycle begins: constitution checks run at spec-creation time or spec-review time per article enforcement setting
4. Failure pattern library exists at `planning-artifacts/knowledge-base/failure-patterns.md` with FP-{NNN} sequential IDs and 5 required fields per pattern
5. Failure patterns are recorded automatically when: (a) Red escalation detected (3+ worker-reviewer cycles), (b) feature stall detected (3+ BLOCKED tasks), (c) reviewer identifies systemic issue
6. Pattern categories cover: spec-quality, assertion-gaps, scope-violations, decomposition-failures, governance-gaps
7. Evidence trail requirement: failure detection logs pattern ID, feature/task context, category, root cause, detection method, and recovery action taken

## Tasks / Subtasks

- [ ] Task 1: Create constitution.md template and integration documentation (AC: #1, #2)
  - [ ] Create `planning-artifacts/constitution.md` with intro explaining optionality and governance cascade
  - [ ] Document article format: Principle, Rationale, Enforcement, Violation response (with example)
  - [ ] Include 3-5 seed articles showing different enforcement patterns (spec-creation, spec-review, execution, post-completion)
  - [ ] Document that only humans can amend constitution; no agent may modify
  - [ ] Add amendment workflow: Propose → Rationale → Write → Effective (with immutability rule extension)
  - [ ] Verify articles can override spec-protocol.md rules (governance cascade enforcement)
- [ ] Task 2: Implement Phase -1 gates in dispatch loop integration (AC: #3)
  - [ ] Document Phase -1 gate sequence: check constitution.md existence → for each article with spec-creation enforcement → check spec packet → pass or fail with feedback
  - [ ] Document Phase -1 runs BEFORE DRAFT → LINT_PASS (Section 15 lifecycle)
  - [ ] Planner receives violation details → revises spec → re-checks (one retry before BLOCKED)
  - [ ] Articles with spec-review enforcement run at LINT_PASS → RATIFIED instead
  - [ ] Add Phase -1 decision tree diagram showing branching logic
  - [ ] Link to governance cascade enforcement table (constitution.md highest authority)
- [ ] Task 3: Create failure-patterns.md library structure and population rules (AC: #4, #5, #6, #7)
  - [ ] Create `planning-artifacts/knowledge-base/` directory structure
  - [ ] Create `planning-artifacts/knowledge-base/failure-patterns.md` with header explaining optionality and append-only requirement
  - [ ] Document entry format: FP-{NNN}, Category, Detected, Status, Root cause, Detection method, Resolution, Prevention
  - [ ] Document 5 categories: spec-quality, assertion-gaps, scope-violations, decomposition-failures, governance-gaps with examples
  - [ ] Document population triggers: (a) Red escalation (task BLOCKED after 3+ cycles), (b) feature stall (3+ BLOCKED tasks in feature), (c) reviewer systemic finding
  - [ ] Document evidence trail: pattern ID, feature ID/task ID, category, root cause explanation, which gate/escalation detected it, recovery action taken
  - [ ] Add status lifecycle: active → mitigated → resolved (with annotation support)
  - [ ] Document consumption: planner checks before speccing, reviewer checks during LINT_PASS → RATIFIED, dispatch loop records on Red/stall
- [ ] Task 4: Integrate constitution and failure patterns with spec-protocol.md Section 16 (AC: #1-#7)
  - [ ] Verify spec-protocol.md Section 16 already documents both systems
  - [ ] Add references from spec-protocol.md Section 16 to new constitution.md file path and failure-patterns.md file path
  - [ ] Verify Phase -1 gates section in spec-protocol.md references the dispatch loop integration point
  - [ ] Confirm governance cascade table shows constitution as highest authority
  - [ ] Confirm failure pattern library section documents append-only and status transitions
  - [ ] Verify tier applicability: TRIVIAL exempt, SIMPLE+ checked against constitution and patterns
- [ ] Task 5: Completion validation and evidence artifacts (AC: #1-#7)
  - [ ] Verify constitution.md exists, is valid markdown, articles follow format exactly
  - [ ] Verify failure-patterns.md exists, append-only structure enforced (no deletes)
  - [ ] Verify FP-{NNN} IDs are sequential starting from FP-001
  - [ ] Verify all 5 ACs pass: governance cascade enforcement, Phase -1 gates, library population triggers, evidence trail, tier applicability
  - [ ] Document completion notes with file creation summary

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md` and spec-protocol.md Section 16
- **Section 16 (Constitution & Failure Pattern Library):** Defines both optional governance mechanisms, article format, Phase -1 gates, library entry format, population triggers, consumption patterns
- **Governance Cascade (Section 5, spec-protocol.md):** Constitution > spec-protocol.md > skills > agent freedom — highest to lowest authority
- **Phase -1 Gates (Section 16, spec-protocol.md):** Run before DRAFT → LINT_PASS lifecycle; constitution.md existence check → article validation → spec packet check → pass/fail with feedback
- **Red Escalation (Section 15, spec-protocol.md):** Task reaching Red (BLOCKED after 3+ cycles) triggers failure pattern recording
- **Feature Stall (Section 13, spec-protocol.md):** 3+ BLOCKED tasks in feature triggers NEEDS_RESPEC and failure pattern recording
- **Reviewer Gate (Section 14-15, spec-protocol.md):** Reviewer identifying systemic issue (not one-off bug) records failure pattern
- **Tier Applicability:** TRIVIAL exempt (no spec), SIMPLE+ checked if constitution exists, patterns recorded on escalation

### Constitution Document Strategy

**File:** `planning-artifacts/constitution.md`

**Purpose:** Immutable project principles that override all other governance layers. Defines the WHY; spec-protocol.md defines the HOW.

**Optionality:** Constitution.md is OPTIONAL. When absent:
- Governance cascade starts at spec-protocol.md (no Phase -1)
- Seed principles from spec-protocol.md Section 5 provide lightweight governance
- System continues functioning normally — no degradation

**Key Principles:**
1. Only humans create/amend constitution — no agent may modify
2. Amendments take effect immediately for NEW specs; in-progress tasks continue against previous version
3. Each article must specify enforcement point: spec-creation time OR spec-review time OR execution OR post-completion
4. Articles MUST align with and strengthen (not contradict) seed principles from Section 5

**Seed Article Examples to Include:**

Example 1 — Type Safety (spec-creation enforcement):
```markdown
### Article 1: No Untyped External Inputs

**Principle:** Every external input MUST be validated with explicit type checks before processing.
**Rationale:** Untyped inputs caused 3 production incidents in Q1; runtime type errors are the #1 failure category.
**Enforcement:** Dispatch loop checks at Phase -1 (spec-creation time). Spec must include assertions for input validation.
**Violation response:** Block — spec cannot proceed from DRAFT until input validation assertions are present.
```

Example 2 — Security Review (spec-review enforcement):
```markdown
### Article 2: Security-Sensitive Paths Require Review Approval

**Principle:** Any spec touching authentication, secrets, or data access MUST be approved by security reviewer before RATIFIED.
**Rationale:** Security flaws are irrecoverable; human review is required before execution.
**Enforcement:** Reviewer checks at LINT_PASS → RATIFIED (Section 15 gate).
**Violation response:** Block — spec cannot transition to RATIFIED without explicit reviewer APPROVED status on security review.
```

Example 3 — Immutability Rule (extends Governance Principle 7):
```markdown
### Article 3: Specs Are Immutable Once Ratified

**Principle:** Once a spec reaches RATIFIED state (or ACTIVE in Slice 1), it MUST NOT be modified. Changes require a new spec version.
**Rationale:** Immutability prevents mid-task requirement changes that cause implementation thrash and incomplete evidence trails.
**Enforcement:** Dispatch loop prevents modifications to ACTIVE+ specs (Section 10 immutability rule).
**Violation response:** Log violation to failure-patterns.md as governance-gap if attempted; treat as NEEDS_RESPEC trigger.
```

### Failure Pattern Library Strategy

**File:** `planning-artifacts/knowledge-base/failure-patterns.md`

**Purpose:** Append-only record of failure patterns encountered during SDD execution. Captures lessons learned so past mistakes inform future specs and reviews.

**Key Requirements:**
1. **Append-only:** Entries never deleted. Status transitions: active → mitigated → resolved.
2. **Sequential IDs:** FP-001, FP-002, etc. Never reuse or skip.
3. **Five required fields per entry:** Category, Detected, Status, Root cause, Detection method, Resolution, Prevention
4. **Evidence trail:** Must capture which gate/escalation caught it, which feature/task failed, what recovery action was taken

**Population Rules:**

Trigger 1 — Red Escalation:
- When any task reaches Red (BLOCKED after 3+ worker-reviewer cycles)
- Dispatch loop records: category (likely spec-quality, assertion-gaps, or scope-violations), root cause from feedback log, detection method (which gate failed), resolution (escalated to user), prevention (constitution article or template update recommendation)

Trigger 2 — Feature Stall:
- When 3+ tasks in a feature reach BLOCKED
- Dispatch loop records: category = decomposition-failures, root cause = feature decomposition issues, detection method = stall threshold (3 tasks), resolution = NEEDS_RESPEC dispatched, prevention = revised feature spec, adjusted 7x7 constraint application

Trigger 3 — Reviewer Finding:
- When reviewer identifies systemic issue (not one-off bug)
- Reviewer provides pattern summary; dispatch loop records: category (governance-gaps likely), root cause from reviewer comment, detection method (human review), resolution (updated governance/template), prevention (constitution article or updated assertion template)

**Evidence Trail Components:**

```markdown
### FP-001: Vague Assertions Causing Verification Failures

**Category:** spec-quality
**Detected:** 2026-02-15
**Status:** active
**Root cause:** Assertions used banned vague terms ("works correctly," "proper handling") without specific observables. Reviewers couldn't determine pass/fail.
**Detection:** Gate 1 (Spec Lint) — Quality Gate check flagged vague terms in 4 assertions; implementer and reviewer both struggled with evidence verification
**Resolution:** Task re-specced with specific observables; implementer provided clear evidence matching assertions
**Prevention:** Constitution Article 4 added: "All assertions MUST name a specific observable (endpoint, file, return value, error code) — see spec-protocol.md Section 4 quality gate rules. Vague terms prohibited."
```

**Status Lifecycle:**

- **active:** Pattern currently observed, no permanent fix
- **mitigated:** Partial fix in place (e.g., template updated), but pattern may recur
- **resolved:** Fully prevented by governance automation or constitution article

Annotation example:
```markdown
**Status:** resolved (mitigated by Constitution Article 5 + Assertion Quality Template; no similar patterns in last 10 features)
```

### Phase -1 Gate Integration

**When Phase -1 Runs:**

```
Planner creates spec packet → TaskCreate submitted
  ↓
Dispatch loop receives new spec
  ↓
IF constitution.md exists:
  ├─ Phase -1: Constitution Check
  │   ├─ For each Article with enforcement = "spec-creation":
  │   │   └─ Check spec packet against Principle
  │   ├─ ALL PASS? → Proceed to DRAFT → LINT_PASS
  │   └─ FAIL? → Return violation details to planner → 1 retry → BLOCKED if fails again
  │
  └─ ELSE: Skip Phase -1 (proceed to DRAFT → LINT_PASS)

IF constitution.md absent:
  └─ Skip Phase -1 entirely (proceed to DRAFT → LINT_PASS)
```

**Failure Feedback to Planner:**

```
Constitution violation detected:
Article: [Article N: Title]
Principle: [exact principle text]
Failure reason: [specific check that failed]
Fix guidance: [what to adjust in spec]
Retry: You have 1 retry to fix and resubmit
```

### Evidence Trail for Failure Recording

When dispatch loop detects escalation or stall, it writes pattern entry with this minimal data structure:

```json
{
  "pattern_id": "FP-{NNN}",
  "timestamp": "2026-02-20T14:30:00Z",
  "feature_id": "F-005",
  "task_id": "T-042",
  "category": "assertion-gaps|spec-quality|scope-violations|decomposition-failures|governance-gaps",
  "escalation_type": "red|stall|reviewer",
  "root_cause": "string",
  "detection_point": "gate_name|escalation_level|reviewer_comment",
  "recovery_action": "string",
  "prevention_recommendation": "string"
}
```

Dispatch loop converts this to markdown entry (Task 3 handles format).

### Previous Story Intelligence (Stories 1.1-4.2)

- spec-protocol.md Sections 1-15 fully populated (~1400 lines)
- Section 16 already documents both constitution and failure patterns (lines 1141-1287)
- Spec lifecycle (Section 10): DRAFT → ACTIVE → DONE (Slice 1) or DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED (Slice 3)
- Verification pipeline (Section 14-15): automated gates + graduated escalation + circuit breaker
- Feature tracker (Section 12-13): tracks phase, verified status, stall detection
- Governance cascade (Section 5): constitution > spec-protocol > skills > agent freedom

### Critical Constraints

- Pure markdown only (NFR3)
- Create TWO new files: constitution.md (new) and failure-patterns.md (new)
- Do NOT modify spec-protocol.md — Section 16 already documents both systems
- Constitution.md MUST be human-owned: only humans amend, no agent may modify
- failure-patterns.md MUST be append-only: dispatch loop writes entries, never deletes
- Constitution optionality MUST be clear: system functions fully without it (graceful degradation)
- Phase -1 gates run before spec lifecycle (before DRAFT → LINT_PASS transition)
- Seed articles should demonstrate variety: spec-creation enforcement, spec-review enforcement, execution-time rules
- Failure pattern evidence trail must include: pattern ID, context (feature/task), category, root cause, detection method, recovery action

### Project Structure Notes

- Target files:
  - `planning-artifacts/constitution.md` (NEW)
  - `planning-artifacts/knowledge-base/failure-patterns.md` (NEW — directory may not exist yet)
- Reference file: `.claude/skills/spec-protocol.md` (read-only — Section 16 already documents both systems)
- No other files should be created or modified

### References

- [Source: .claude/skills/spec-protocol.md#Section 16: Constitution & Failure Pattern Library]
- [Source: .claude/skills/spec-protocol.md#Section 5: Governance Cascade & Principles]
- [Source: .claude/skills/spec-protocol.md#Section 10: Spec Lifecycle Immutability]
- [Source: .claude/skills/spec-protocol.md#Section 13: Feature Stall Detection & Escalation]
- [Source: .claude/skills/spec-protocol.md#Section 15: Graduated Escalation & Circuit Breakers]
- [Source: .claude/skills/spec-protocol.md#Section 14: Two-Layer Verification Pipeline]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation (document structure only, no code).

### Completion Notes List

- Created `planning-artifacts/constitution.md` (NEW, ~120 lines)
  - Header explaining optionality and relationship to seed principles (Section 5)
  - Governance cascade table showing constitution at highest authority
  - Article format specification: Principle, Rationale, Enforcement, Violation response
  - 3 seed articles demonstrating enforcement patterns:
    - Article 1: Type safety (spec-creation enforcement)
    - Article 2: Security review (spec-review enforcement)
    - Article 3: Immutability rule (execution-time enforcement)
  - Amendment workflow: Propose → Rationale → Write → Effective (with immutability note)
  - Ownership rules: only humans create/amend, no agent may modify
  - Phase -1 gate reference to dispatch loop integration
- Created `planning-artifacts/knowledge-base/` directory structure and `failure-patterns.md` (NEW, ~180 lines)
  - Header explaining append-only requirement and optionality
  - Entry format: FP-{NNN}, Category, Detected, Status, Root cause, Detection, Resolution, Prevention
  - 5 categories with descriptions and examples:
    - spec-quality: ambiguous, incomplete, untestable specs
    - assertion-gaps: missing critical behavior coverage
    - scope-violations: out-of-scope file modifications
    - decomposition-failures: incorrect feature decomposition
    - governance-gaps: insufficient governance rules
  - Population triggers: Red escalation, feature stall, reviewer finding
  - Status lifecycle: active → mitigated → resolved
  - Evidence trail components: pattern ID, context (F-{NNN}/T-{NNN}), category, root cause, detection method, recovery action
  - Consumption rules: planner checks before speccing, reviewer checks during review, dispatch loop records on escalation
  - 2 example entries showing different categories and escalation types
- Phase -1 gate sequence documented (spec-creation → validation → dispatch loop implementation point)
  - Constitution existence check
  - Per-article validation with specific failure feedback to planner
  - One retry before BLOCKED escalation
  - Articles with spec-review enforcement deferred to LINT_PASS → RATIFIED (Section 15)
- All 7 acceptance criteria verified PASS:
  - AC1: Constitution format matches spec-protocol.md Section 16
  - AC2: Governance cascade enforced (constitution highest authority)
  - AC3: Phase -1 gates run before DRAFT → LINT_PASS with feedback loop
  - AC4: Failure patterns append-only with FP-{NNN} sequential IDs and 5 required fields
  - AC5: Population triggers documented (Red escalation, feature stall, reviewer finding)
  - AC6: 5 categories defined with examples
  - AC7: Evidence trail captures pattern ID, context, category, root cause, detection method, recovery action
- Zero-code constraint (NFR3) satisfied — pure markdown
- Slice 3 governance fully documented; graceful degradation when absent
- Ownership enforced: humans only for constitution amendments; dispatch loop only for pattern recording

### Change Log

- 2026-02-20: Story 4.3 implemented — created constitution.md and failure-patterns.md with full governance framework

### File List

- `planning-artifacts/constitution.md` (NEW, ~120 lines)
- `planning-artifacts/knowledge-base/failure-patterns.md` (NEW, ~180 lines)
