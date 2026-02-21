# Story 2.5: Spec Lifecycle States & Evidence Reporting

Status: review

## Story

As an implementer agent,
I want clear lifecycle states and a structured evidence reporting format,
so that I know when a task transitions from DRAFT to ACTIVE to DONE and how to prove assertion compliance.

## Acceptance Criteria

1. Every assertion ID from the spec packet appears in the results section
2. Each result follows the format: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
3. FAIL results include what was expected vs what happened
4. Missing assertion results mean the task is NOT DONE
5. The spec transitions DRAFT → ACTIVE (on dispatch) → DONE (all assertions PASS)

## Tasks / Subtasks

- [x] Task 1: Add Section 10 (Spec Lifecycle States) to spec-protocol.md (AC: #5)
  - [x] Add new Section 10 after Section 9 (Spec Overview Documents)
  - [x] Define Slice 1 lifecycle states: DRAFT → ACTIVE → DONE
  - [x] Document state transitions: DRAFT (planner writes spec) → ACTIVE (dispatch loop accepts and dispatches) → DONE (all assertions PASS)
  - [x] Document transition triggers: what causes each state change
  - [x] Note the Slice 3 expansion: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED (future, not implemented now)
  - [x] State that specs are immutable once ACTIVE — changes require a new spec version (Governance Principle 7 from Section 5)
- [x] Task 2: Add Section 11 (Evidence Reporting Protocol) to spec-protocol.md (AC: #1, #2, #3, #4)
  - [x] Add new Section 11 after Section 10
  - [x] Define the evidence reporting format: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
  - [x] State that EVERY assertion ID from the spec packet MUST appear in results — missing = NOT DONE
  - [x] Document PASS evidence format: assertion ID + file:line + brief description of what was verified
  - [x] Document FAIL evidence format: assertion ID + file:line + what was expected vs what happened
  - [x] Include a complete evidence report example showing both PASS and FAIL results
  - [x] State that evidence reporting applies to SIMPLE+ tiers only (TRIVIAL has no assertions)
- [x] Task 3: Document the NOT DONE rule and completion criteria (AC: #1, #4)
  - [x] State explicitly: a task is DONE only when ALL assertion IDs have PASS results
  - [x] State explicitly: missing assertion results = task is NOT DONE regardless of other progress
  - [x] State explicitly: any FAIL result = task is NOT DONE (implementer must fix and re-report)
  - [x] Document how the dispatch loop uses evidence to transition spec state to DONE
- [x] Task 4: Validate completeness (AC: #1-#5)
  - [x] Verify all 3 lifecycle states (DRAFT/ACTIVE/DONE) are defined with transitions
  - [x] Verify evidence format matches Pattern 2 from architecture exactly
  - [x] Verify NOT DONE rule is unambiguous
  - [x] Verify no modifications to Sections 1-9

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR10 (epics line 29):** Spec lifecycle states: DRAFT → ACTIVE → DONE (Slice 1), expanding to 6-state in Slice 3
- **FR11 (epics line 30):** Implementer evidence reporting with assertion ID + file:line references
- **Decision 1 (lines 221-228):** Spec Lifecycle — Progressive States. Slice 1: DRAFT → ACTIVE → DONE. Slice 3: 6-state full lifecycle.
- **Pattern 2 (lines 317-333):** Implementer Evidence Reporting — exact format, rules for PASS/FAIL, missing = NOT DONE
- **Pattern 6 (lines 392-401):** State Transitions & Ownership — only implementer marks tasks completed, only dispatch loop flips verified
- **ADR-003 (lines 98-107):** Verification — inline assertions + post-task audit (Slice 1)
- **Vulnerability 3 (line 158):** Self-graded assertions in Slice 1 — accepted risk with reviewer safety net

### Pattern 2 from Architecture (verbatim)

```
## Assertion Results
- A1: PASS — src/auth/login.ts:42 (POST handler returns 200)
- A2: PASS — src/auth/login.ts:58 (returns 401 for invalid credentials)
- A3: PASS — src/auth/login.test.ts:15-28 (test covers both cases)
```

**Rules:**
- Every assertion ID from the spec packet MUST appear in results
- Each result: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
- FAIL results MUST include what was expected vs what happened
- Missing assertion results = task is NOT DONE

### Previous Story Intelligence (Stories 2.1-2.4)

- spec-protocol.md now has 9 sections (~600 lines)
- Section 7 routing already mentions implementer reports assertion evidence
- Section 8 implementer consumption workflow step 5 references evidence reporting
- Section 4 defines assertion quality rules — evidence must correspond to specific observables
- Section 5 Governance Principle 7: spec immutability once ACTIVE

### Previous Story Intelligence (Stories 1.1-1.3)

- Section 1 defines assertion IDs (A1-A7) unique within task
- Section 4 assertion quality gate: every assertion names a specific observable
- Section 5 Governance Principle 7: "Once a spec is in ACTIVE state, it MUST NOT be modified"

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-9 — those belong to previous stories
- Add Sections 10 and 11 AFTER Section 9
- Keep content token-efficient
- Evidence format MUST match Pattern 2 from architecture exactly
- Slice 1 lifecycle is 3 states only — mention Slice 3 expansion but do NOT implement it

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Sections 10-11)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 1: Spec Lifecycle — Progressive States]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 2: Implementer Evidence Reporting]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 6: State Transitions & Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-003 Verification]
- [Source: _bmad-output/planning-artifacts/architecture.md#Vulnerability 3: Self-Graded Assertions]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 2.5]
- [Source: _bmad-output/implementation-artifacts/2-4-spec-overview-documents.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 10 (Spec Lifecycle States) to spec-protocol.md — ~42 lines
  - 3-state model: DRAFT → ACTIVE → DONE with state table and 4 transition rules
  - Immutability rule: specs MUST NOT be modified once ACTIVE (references Governance Principle 7)
  - NEEDS_RESPEC integration for requirement changes during ACTIVE state
  - Slice 3 expansion noted (6-state) but not implemented
- Added Section 11 (Evidence Reporting Protocol) to spec-protocol.md — ~55 lines
  - Evidence format: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})` with component table
  - PASS example (3 assertions) and FAIL example (mixed PASS/FAIL) provided
  - NOT DONE rule: 3 explicit conditions (all IDs present, all PASS, evidence specific)
  - 5-step completion flow: implementer reports → dispatch loop checks → transitions or retries
  - Circuit breaker integration: 3 retry cycles → BLOCKED
  - Tier applicability: SIMPLE+ only, TRIVIAL exempt
- Sections 1-9 untouched — verified via section header line check
- All 5 ACs verified PASS
- Epic 2 implementation COMPLETE — all 5 stories delivered

### Change Log

- 2026-02-17: Added Sections 10-11 (Spec Lifecycle States + Evidence Reporting) to spec-protocol.md — Epic 2 complete

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Sections 10 and 11 added after Section 9)
