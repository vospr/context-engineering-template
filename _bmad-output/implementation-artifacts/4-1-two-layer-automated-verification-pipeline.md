# Story 4.1: Two-Layer Automated Verification Pipeline

Status: done

## Story

As a dispatch loop,
I want automated verification gates (spec lint, assertion audit, file scope check) that run before dispatching a reviewer,
so that 80% of spec violations are caught at 5% of the cost of agent review.

## Acceptance Criteria

1. Spec lint validates YAML structure and required fields in the spec packet
2. Assertion audit confirms every assertion ID has a result (PASS or FAIL with evidence)
3. File scope audit verifies the implementer only modified files listed in `file_scope`
4. Failures at the automated layer block reviewer dispatch with a specific error
5. The implementer gets one retry cycle before the task is marked BLOCKED

## Tasks / Subtasks

- [x] Task 1: Add Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md (AC: #1, #2, #3, #4, #5)
  - [x] Add new Section 14 after Section 13 (Tracker State Machine & Recovery)
  - [x] Document the two-layer concept: Layer 1 (automated gates) runs before Layer 2 (agent review)
  - [x] State the cost rationale: automated gates catch 80% of violations at 5% of agent review cost
  - [x] Document the 3 automated gates and their execution order
- [x] Task 2: Define Gate 1 — Spec Lint (AC: #1)
  - [x] Validates YAML structure between `# --- SPEC ---` / `# --- END SPEC ---` delimiters
  - [x] Checks all required fields present: version, intent, assertions, constraints, file_scope
  - [x] Checks assertion structure: each has id, positive, negative
  - [x] Checks controlled vocabulary usage: positive/negative use MUST/MUST NOT/SHOULD/MAY
  - [x] Checks assertion quality gate: no banned vague terms without specific observables (Section 4)
  - [x] Checks 7x7 constraint: max 7 assertions per task (Section 5)
- [x] Task 3: Define Gate 2 — Assertion Audit (AC: #2)
  - [x] Checks every assertion ID from the spec packet has a corresponding result in evidence
  - [x] Checks each result has PASS or FAIL status
  - [x] Checks FAIL results include expected vs actual
  - [x] Checks evidence includes file:line references (not just "looks good")
  - [x] References Section 11 evidence format rules
- [x] Task 4: Define Gate 3 — File Scope Audit (AC: #3)
  - [x] Compares files actually modified by implementer against `file_scope` in spec packet
  - [x] Flags any file modified that is NOT in file_scope as a violation
  - [x] Flags any file in file_scope that was NOT modified as a warning (may indicate incomplete work)
  - [x] State that scope violations block reviewer dispatch
- [x] Task 5: Document failure handling and retry cycle (AC: #4, #5)
  - [x] If any gate fails → reviewer dispatch is BLOCKED with specific error per gate
  - [x] Implementer gets feedback: which gate failed, what the specific violation is
  - [x] Implementer gets one retry cycle to fix the violation
  - [x] If retry also fails → task is marked BLOCKED, escalated per existing circuit breaker
  - [x] Document the gate failure → feedback → retry → BLOCKED flow
- [x] Task 6: Validate completeness (AC: #1-#5)
  - [x] Verify all 3 gates are defined with clear pass/fail criteria
  - [x] Verify failure handling includes specific error messages
  - [x] Verify retry cycle is documented
  - [x] Verify no modifications to Sections 1-13

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR13 (epics line 32):** Two-layer verification: automated gates before agent review (Slice 3)
- **ADR-003 (lines 98-107):** Verification — Slice 3 adds two-layer: automated (lint, assertions, file audit) gates agent review. 80% catch rate at 5% cost.
- **Lines 145:** "Verification layering — cheap automated checks gate expensive agent reviews; 80% of failures caught at 5% of cost"
- **Lines 411-414:** Pattern enforcement: spec lint validates YAML structure, post-task audit verifies assertion results + file_scope
- **Decision 5 (lines 269-278):** Failure matrix — malformed YAML retry, assertion failure circuit breaker
- **Vulnerability 3 (line 158):** Self-graded assertions — "fully closed in Slice 3 with independent tester execution"

### Previous Story Intelligence (Stories 2.1-2.5, 3.1-3.2)

- Section 1 defines spec packet format and delimiters — Gate 1 validates against this
- Section 4 defines assertion quality gate and banned terms — Gate 1 checks this
- Section 5 defines 7x7 constraint — Gate 1 enforces max 7 assertions
- Section 11 defines evidence reporting format — Gate 2 validates against this
- Section 8 defines inline spec delivery — Gate 3 validates file_scope compliance
- spec-protocol.md now has 13 sections (~935 lines)

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-13
- Add Section 14 AFTER Section 13
- Keep content token-efficient
- Reference existing sections for gate criteria — do NOT duplicate rules

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 14)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-003 Verification]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 145 Verification Layering]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 411-414 Pattern Enforcement]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 5: Failure & Recovery Matrix]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.1]
- [Source: _bmad-output/implementation-artifacts/3-2-tracker-state-transitions-recovery.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md — ~85 lines
- Architecture flowchart: Layer 1 (automated gates) → Layer 2 (agent review) with cost rationale (80% catch at 5% cost)
- Gate 1 (Spec Lint): 7 checks referencing Sections 1, 4, 5 — validates YAML structure, required fields, assertion structure, vocabulary, quality, 7x7 constraint, delimiter format
- Gate 2 (Assertion Audit): 4 checks referencing Section 11 — coverage, status, FAIL evidence, file:line references
- Gate 3 (File Scope Audit): 2 checks — unauthorized modifications (violation), unmodified scope files (warning)
- Failure handling: gate failure → specific error feedback → one retry → BLOCKED with circuit breaker escalation
- Tier applicability table: gates apply to MODERATE+ only (TRIVIAL/SIMPLE skip Layer 1)
- Sections 1-13 untouched — verified via section header line check
- All 5 ACs verified PASS
- Epic 4 Story 1 of 3 complete

### Change Log

- 2026-02-18: Added Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 14 added after Section 13)
