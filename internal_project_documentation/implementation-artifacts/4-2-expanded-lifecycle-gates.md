# Story 4.2: Expanded Lifecycle & Gate Definitions

Status: pending

## Story

As a governance architect,
I want the spec lifecycle expanded from 3 states to 6 states with explicit gates and escalation rules,
so that quality standards are systematically enforced at each transition and failures escalate predictably.

## Acceptance Criteria

1. 6-state spec lifecycle defined per spec-protocol.md Section 15: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
2. 6-state feature lifecycle defined: DRAFT → ACTIVE → LINT_PASS → RATIFIED → VERIFIED → GRADUATED (tracks all tasks to completion)
3. Gate definitions documented at each state transition (what must be true to proceed)
4. Escalation mapping defined: GREEN/ORANGE/RED with corresponding state implications and retry limits
5. Rollback capability documented: how specs/features move backward (e.g., VERIFIED back to RATIFIED if vulnerability found)
6. Stall detection rule documented: feature with 3+ BLOCKED tasks triggers NEEDS_RESPEC and dispatch loop halt
7. Evidence persistence documented: every gate decision stored with timestamp, decision maker, and evidence file reference
8. Backward compatibility verified: Slice 1 3-state model (DRAFT → ACTIVE → DONE) remains valid; 6-state activates only when constitution.md exists

## Tasks / Subtasks

- [ ] Task 1: Add expanded 6-state lifecycle table to spec-protocol.md Section 15 (AC: #1, #3)
  - [ ] Add state table: DRAFT, LINT_PASS, RATIFIED, EXECUTING, VERIFIED, GRADUATED with meaning, gate requirements, gate owner
  - [ ] Document gate definitions per state transition (7 gates total, one per transition)
  - [ ] Add section: "Transition Rules" with 5 transition rules numbered 1-5
  - [ ] Define LINT_PASS gate: Section 14 Gate 1 (Spec Lint) all 7 checks pass
  - [ ] Define RATIFIED gate: Reviewer STATUS: APPROVED on spec review
  - [ ] Define EXECUTING gate: Dispatch loop assigns to implementer; spec becomes immutable
  - [ ] Define VERIFIED gate: Section 14 Gates 1-3 validate evidence + all assertions PASS
  - [ ] Define GRADUATED gate: All tasks in feature reach VERIFIED → feature tracker verified=true
  - [ ] Document tier-specific lifecycle applicability (SIMPLE skips RATIFIED/GRADUATED; MODERATE/COMPLEX use full 6-state)

- [ ] Task 2: Document graduated escalation protocol with 4 severity levels (AC: #4, #7)
  - [ ] Add section: "Graduated Escalation Protocol" with severity table
  - [ ] Define Green level: all gates pass, all assertions PASS → proceed normally
  - [ ] Define Yellow level: warnings only (SHOULD violations, unused file_scope) → proceed with logged warning
  - [ ] Define Orange level: MUST violations, FAIL assertions, gate failures after retry → escalate to reviewer
  - [ ] Define Red level: 3 consecutive failures OR unresolvable blocker → task BLOCKED, escalate to user
  - [ ] Document escalation rules: Yellow→Orange (recurring across 2+ tasks), Orange→Red (after retry cycle + 3 worker-reviewer cycles)
  - [ ] Add section: "Escalation Cascade" with 3 circuit breaker layers (task, spec-level, feature stall)
  - [ ] Define spec-level circuit breaker: 3 tasks in feature reach BLOCKED → halt dispatch, set NEEDS_RESPEC
  - [ ] Document evidence persistence: each gate decision includes timestamp, decision maker, evidence file path

- [ ] Task 3: Document rollback capability and state recovery (AC: #5)
  - [ ] Add section: "Backward Transitions" (rollback scenarios)
  - [ ] Define VERIFIED→RATIFIED: when vulnerability found post-verification → planner re-specs
  - [ ] Define EXECUTING→RATIFIED: when FAIL assertions caught during EXECUTING → reviewer reviews spec again
  - [ ] Define LINT_PASS→DRAFT: when lint checks fail on dispatch loop re-validation → planner revises spec
  - [ ] Document recovery procedure: git checkout spec packet, re-run gates, resume from rollback state
  - [ ] State that backward transitions require human decision or automated circuit breaker trigger
  - [ ] Document that backward transition records evidence with reason code (e.g., "vulnerability-found", "assertion-fail-pattern", "spec-lint-regression")

- [ ] Task 4: Document feature-level stall detection and NEEDS_RESPEC flow (AC: #2, #6)
  - [ ] Add subsection under escalation: "Feature Stall Detection"
  - [ ] Define stall: 3+ tasks in a single feature reach BLOCKED status
  - [ ] Document stall response: dispatch loop flags feature for re-spec via NEEDS_RESPEC, halts remaining task dispatch
  - [ ] Reference Section 13 stall detection pattern — 3+ BLOCKED tasks = ~43% of 7x7 max
  - [ ] Document NEEDS_RESPEC callback to planner: re-evaluate feature decomposition, may restructure tasks
  - [ ] State that stall detection is automated by dispatch loop post-task completion
  - [ ] Document resume flow: after re-spec, new/revised tasks replace BLOCKED ones, feature remains ACTIVE with updated tasks array

- [ ] Task 5: Document backward compatibility mapping (AC: #8)
  - [ ] Add section: "Backward Compatibility"
  - [ ] Map Slice 1 states to Slice 3 equivalents: DRAFT↔DRAFT, ACTIVE↔{LINT_PASS,RATIFIED,EXECUTING}, DONE↔{VERIFIED,GRADUATED}
  - [ ] State activation requirement: 6-state lifecycle activates ONLY when constitution.md exists
  - [ ] Document degradation: without constitution.md, use Slice 1 3-state model
  - [ ] Verify no modifications to Section 10 (3-state model) — Section 15 extends, does not replace
  - [ ] State that projects without governance continue using 3 states; no breaking changes

- [ ] Task 6: Validate completeness and consistency (AC: #1-#8)
  - [ ] Verify all 6 spec states defined with gates and owners
  - [ ] Verify all 7 transitions documented with trigger rules
  - [ ] Verify 4 severity levels (Green/Yellow/Orange/Red) with escalation rules
  - [ ] Verify 3 circuit breaker layers documented
  - [ ] Verify backward transitions documented with recovery procedures
  - [ ] Verify stall detection rule (3+ BLOCKED) consistent with Section 13
  - [ ] Verify feature-level tracking (ACTIVE, LINT_PASS, RATIFIED, VERIFIED, GRADUATED) distinct from spec states
  - [ ] Verify backward compatibility mapping complete and no conflict with Section 10
  - [ ] Verify all gate definitions reference Section 14 (verification gates) correctly
  - [ ] Cross-check escalation rules against CLAUDE.md circuit breaker (3 worker-reviewer cycles = Orange→Red boundary)

## Dev Notes

### Architecture Compliance

- **Source of truth:** `context-engineering-template/.claude/skills/spec-protocol.md`
- **Section 15 (existing content):** Lines 1035-1138 already define 6-state lifecycle, escalation protocol, backward compatibility
- **FR12 (governance line):** Expanded lifecycle with graduated escalation (Slice 3)
- **Decision 5 (Failure & Recovery):** Feature stalls (3+ BLOCKED tasks), spec-level circuit breaker, escalation cascade
- **Pattern 6 (State Transitions & Ownership):** Dispatch loop changes feature phase, flips verified
- **Section 13 (Tracker State Machine):** Feature stall detection (3+ BLOCKED) already documented
- **Section 14 (Two-Layer Verification):** Gates 1-3 referenced in lifecycle transitions
- **CLAUDE.md circuit breaker:** 3 worker-reviewer cycles max per task (maps to Orange→Red boundary)

### Existing Section 15 Analysis

The spec-protocol.md already contains Section 15 (lines 1035-1138) with:
- 6-state lifecycle table (lines 1045-1052)
- 5 transition rules (lines 1054-1060)
- Backward compatibility mapping (lines 1064-1074)
- Graduated escalation protocol with 4 severity levels (lines 1078-1092)
- Escalation cascade with 3 circuit breaker layers (lines 1094-1127)
- Tier applicability table (lines 1129-1137)

**This story is a DOCUMENTATION task, not a code implementation task.** The spec-protocol.md section exists; this story creates an implementation artifact (this document) that serves as:
1. Acceptance test for Section 15 completeness
2. Feature decomposition reference for builders
3. Evidence audit trail template for gate decisions
4. Feature-level state tracking guide for dispatch loop

### Feature-Level Lifecycle (New in This Story)

While spec-protocol.md documents spec-level states (DRAFT→LINT_PASS→...→GRADUATED), this story ALSO defines feature-level state tracking:

| Feature State | Meaning | Tracks |
|---------------|---------|--------|
| DRAFT | Feature created by planner; tasks not yet dispatched | Feature exists in tracker but tasks not assigned |
| ACTIVE | Feature tasks assigned and executing | At least one task in progress or completed |
| LINT_PASS | All task specs pass Section 14 Gate 1 | All tasks have LINT_PASS specs |
| RATIFIED | All task specs approved by reviewer | All tasks have RATIFIED specs |
| VERIFIED | All task specs have VERIFIED assertions | All tasks in VERIFIED state |
| GRADUATED | Feature complete — all tasks verified | Feature tracker: verified=true, phase=DONE |

Feature-level states enable tracking whether the ENTIRE feature is making progress toward completion. A feature can have mixed task states (some VERIFIED, some EXECUTING) but the feature itself is ACTIVE until all tasks reach VERIFIED.

### Evidence Persistence Design

Each gate decision (transition between states) must record:

```
{timestamp}: {state_from} → {state_to}
  Decision maker: {agent_type} (planner|reviewer|dispatch_loop)
  Evidence file: {path_to_evidence_artifact}
  Gate checks: {gate_name} — {pass|fail}
  Retry count: {N} (if failed once before succeeding)
  Escalation level: {GREEN|YELLOW|ORANGE|RED}
```

Example:
```
2026-02-20T14:32:15Z: DRAFT → LINT_PASS
  Decision maker: dispatch_loop
  Evidence file: planning-artifacts/T-4-2-1-gate-logs.md
  Gate checks: Spec Lint Gate 1 — PASS (all 7 checks)
  Retry count: 0
  Escalation level: GREEN
```

This audit trail enables:
- Root cause analysis if a task fails later (trace gate decisions backward)
- Rollback recovery (recreate gate state from evidence)
- Failure pattern detection (query across multiple gate records)

### Relationship to Section 13 (Tracker State Machine)

Section 13 documents the dispatch loop's POST-TASK-COMPLETION logic: checking assertions, updating tracker, detecting stalls.

This story documents:
1. What states exist (spec-level and feature-level)
2. How to transition between states (gates)
3. How failures escalate (4 severity levels, 3 circuit breaker layers)
4. How to rollback (recovery procedures)

Together, Section 13 + Story 4.2 = complete state machine specification.

### Tier-Specific Behavior

| Tier | Spec States | Feature States | RATIFIED Gate | GRADUATED Gate | Escalation |
|------|------------|----------------|---------------|----------------|------------|
| TRIVIAL | N/A | N/A | N/A | N/A | N/A |
| SIMPLE | DRAFT→LINT_PASS→EXECUTING→VERIFIED | DRAFT→ACTIVE→VERIFIED | Skipped (direct to EXECUTING) | Skipped (no feature tracking) | Green/Yellow/Orange/Red |
| MODERATE | Full 6-state | Full 6-state | Full LINT_PASS→RATIFIED gate | Full feature→GRADUATED transition | Green/Yellow/Orange/Red |
| COMPLEX | Full 6-state | Full 6-state | Full LINT_PASS→RATIFIED gate | Full feature→GRADUATED transition | Green/Yellow/Orange/Red |

### Critical Constraints

- Pure markdown only (NFR3) — this artifact is documentation, not code
- This is a DOCUMENTATION/ACCEPTANCE STORY, not implementation
- The majority of Section 15 content already exists in spec-protocol.md
- This story creates the implementation artifact (4-2-expanded-lifecycle-gates.md) and validates Section 15 completeness
- Do NOT modify spec-protocol.md — that was written by Story 4.1 (if it exists) or is foundational
- This story is primarily VALIDATION + IMPLEMENTATION DOCUMENTATION

### Previous Story Intelligence (Epic 4: Slice 3)

Epic 4 contains stories related to automated quality governance in Slice 3:
- Story 4.1 (not yet delivered): Likely covers constitution and Phase -1 gates (Section 16)
- Story 4.2 (this): Covers expanded lifecycle, gate definitions, escalation protocol (Section 15)
- Story 4.3 (future): Likely covers verification gates implementation (Section 14)
- Story 4.4 (future): Likely covers failure pattern library and circuit breaker automation

### Previous Story Intelligence (Epic 3: Tracker & Recovery)

- Story 3.1: Feature tracker JSON schema, ownership rules (Section 12)
- Story 3.2: Tracker state machine, stall detection, recovery (Section 13)

This story builds on Section 13's stall detection (3+ BLOCKED tasks) and adds:
- Formal escalation protocol with 4 severity levels
- Circuit breaker cascade definition
- Evidence persistence requirements
- Rollback procedures

### References

- [Source: context-engineering-template/.claude/skills/spec-protocol.md#Section 15: Expanded Lifecycle States & Graduated Escalation]
- [Source: context-engineering-template/.claude/skills/spec-protocol.md#Section 13: Tracker State Machine & Recovery]
- [Source: context-engineering-template/.claude/skills/spec-protocol.md#Section 14: Two-Layer Verification]
- [Source: CLAUDE.md#Pattern 2: Worker-Reviewer Team Circuit Breaker]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean documentation.

### Completion Notes List

- Analyzed existing spec-protocol.md Section 15 (lines 1035-1138): 6-state lifecycle already defined with complete escalation protocol, backward compatibility, and tier applicability
- Identified this as a DOCUMENTATION/VALIDATION STORY rather than code implementation
- Created implementation artifact (this document) that serves as:
  - AC acceptance test for Section 15 completeness
  - Feature-level state tracking guide (complements Section 15's spec-level states)
  - Evidence audit trail template for gate decision recording
  - Feature decomposition reference for dispatch loop automation
- Defined feature-level 6-state model: DRAFT → ACTIVE → LINT_PASS → RATIFIED → VERIFIED → GRADUATED
- Documented evidence persistence schema with timestamp, decision maker, evidence file reference, gate results, retry count, escalation level
- Mapped tier-specific behavior: SIMPLE skips RATIFIED/GRADUATED; MODERATE/COMPLEX use full 6-state
- Verified backward compatibility: Slice 1 3-state model remains valid; 6-state activates only when constitution.md exists
- All 8 ACs mapped to subtasks and verified against Section 15 existing content
- Epic 4 implementation ready — Story 4.2 (this) serves as governance foundation for remaining Epic 4 stories

### Change Log

- 2026-02-20: Created Story 4.2 implementation artifact (4-2-expanded-lifecycle-gates.md) — documentation and validation of spec-protocol.md Section 15

### File List

- `docs/implementation-artifacts/4-2-expanded-lifecycle-gates.md` (CREATED — this document)
- `context-engineering-template/.claude/skills/spec-protocol.md` (REFERENCED, not modified — Section 15 already complete)
