# Story 4.1: Two-Layer Verification Pipeline

Status: review

## Story

As a dispatch loop managing quality gates,
I want a two-layer verification pipeline with automated gates followed by agent review,
so that 80% of spec violations are caught at 5% of the cost of manual review and failures are graduated based on severity.

## Acceptance Criteria

1. Layer 1 (Automated Gates) runs before Layer 2: validates spec packet structure, assertion evidence, and file scope compliance
2. Gate 1 (Spec Lint) checks delimiters, YAML parsing, required fields, assertion structure, controlled vocabulary, quality gate compliance, and 7x7 constraint
3. Gate 2 (Assertion Audit) validates evidence completeness, PASS/FAIL status presence, file:line references, and FAIL detail requirements
4. Gate 3 (File Scope Audit) prevents out-of-scope modifications (blocking) and warns on untouched scope files (warning only)
5. Gate failures trigger implementer feedback with specific gate/check/message and allow one retry cycle before escalating to BLOCKED
6. Layer 2 (Agent Review) dispatches reviewer only after all Layer 1 gates PASS, leveraging the evidence trail for thorough validation
7. The two-layer pipeline applies to SIMPLE/MODERATE/COMPLEX tiers; TRIVIAL tasks bypass both layers (no spec)

## Tasks / Subtasks

- [ ] Task 1: Add Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md (AC: #1, #2, #3, #4, #5, #6, #7)
  - [ ] Add new Section 14 after Section 13 (Tracker State Machine & Recovery)
  - [ ] Document the 2-layer architecture with visual flowchart
  - [ ] Layer 1 (Automated Gates) section with 3 gates
  - [ ] Gate 1 (Spec Lint) with 7 checks and validation rules
  - [ ] Gate 2 (Assertion Audit) with 4 checks and evidence format validation
  - [ ] Gate 3 (File Scope Audit) with blocking/warning distinctions
  - [ ] Failure handling: specific feedback → 1 retry → BLOCKED escalation
  - [ ] Tier applicability table: TRIVIAL (skipped), SIMPLE/MODERATE/COMPLEX (all gates run)
- [ ] Task 2: Define gate-specific validation checks and fail messages (AC: #2, #3, #4)
  - [ ] Gate 1 checks: delimiter presence, YAML parse, required fields, assertion structure, controlled vocabulary, quality gate, 7x7 constraint
  - [ ] Each check includes: validation rule, fail message template, reference to spec-protocol.md section
  - [ ] Gate 2 checks: completeness (all assertion IDs), status (PASS/FAIL present), evidence format (file:line), FAIL detail (expected/actual)
  - [ ] Gate 3 checks: blocking (out-of-scope files), warning (untouched scope files) with severity distinction
  - [ ] Reference Section 1 (Spec Format), Section 3 (Controlled Vocabulary), Section 4 (Assertion Quality), Section 5 (7x7 Constraint), Section 11 (Evidence Reporting)
- [ ] Task 3: Document failure handling and retry protocol (AC: #5)
  - [ ] When gate fails: implementer receives specific feedback (gate name + check name + fail message)
  - [ ] Implementer gets exactly 1 retry cycle to fix the violation
  - [ ] After retry: re-run all 3 gates from beginning (no skipping failed gate)
  - [ ] If retry also fails: task marked BLOCKED, escalate to user
  - [ ] Retry cycle is separate from worker-reviewer circuit breaker (Section 10 max 3 cycles)
  - [ ] Provide retry feedback template showing gate, check, message, and guidance
- [ ] Task 4: Document integration with Layer 2 (Agent Review) and lifecycle (AC: #5, #6)
  - [ ] Layer 2 dispatches reviewer ONLY after Layer 1 gates PASS
  - [ ] Reviewer validates evidence against code (per existing Pattern 2 worker-reviewer team)
  - [ ] Reference CLAUDE.md Pattern 2 (Worker-Reviewer Team) for review cycle
  - [ ] Layer 1 gates consume 1 retry before entering Layer 2 worker-reviewer circuit breaker
  - [ ] Layer 1 is independent quality check; Layer 2 is thorough code review
  - [ ] Document tier applicability: TRIVIAL (skipped), SIMPLE (gates only, optional reviewer), MODERATE/COMPLEX (gates + required reviewer)
- [ ] Task 5: Validate completeness and backward compatibility (AC: #1-#7)
  - [ ] Verify all 3 gates have explicit checks documented
  - [ ] Verify TRIVIAL tier has zero gate overhead (SKIPPED)
  - [ ] Verify gates are conditional on spec packet presence (backward compatible with non-SDD projects)
  - [ ] Verify Section 14 references Sections 1, 3, 4, 5, 11 (no duplication, just cross-references)
  - [ ] Verify failure handling is clear and specific
  - [ ] Verify no modifications to Sections 1-13

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Section 14 in spec-protocol.md (lines 946-1033):** Two-Layer Verification Pipeline — this story documents the exact gate logic from those lines
- **FR3 (line 44):** Two-layer verification gates before reviewer dispatch
- **FR4 (line 45):** Gate output: PASS/ORANGE/RED with escalation mapping
- **FR5 (line 46):** Evidence trail: every gate decision logged with decision time, agent, evidence reference
- **Decision 3 (lines 241-280):** Slice 3 Governance Expansion — introduces verification gates and graduated escalation
- **Lines 953-966:** 2-layer architecture flowchart (Implementer → Layer 1 Automated Gates → Layer 2 Agent Review)
- **Lines 970-1004:** Gate specifications: Gate 1 (7 checks), Gate 2 (4 checks), Gate 3 (2 checks with blocking/warning)
- **Lines 1006-1022:** Failure handling: specific feedback → retry → BLOCKED
- **Lines 1024-1031:** Tier applicability: TRIVIAL skipped, SIMPLE/MODERATE/COMPLEX all gates run
- **Pattern 2 (CLAUDE.md):** Worker-Reviewer Team — Pattern 2 circuit breaker applies to Layer 2
- **NFR3 (line 51):** Pure markdown only — gates are documented behavior, not code

### Gate Architecture & Implementation Details

**Gate 1: Spec Lint (7 checks)**
- Check 1a: Delimiter presence — verifies `# --- SPEC ---` and `# --- END SPEC ---` markers exist
- Check 1b: YAML parse — content between delimiters must be valid YAML (Section 1)
- Check 1c: Required fields — version, intent, assertions, constraints, file_scope all present (Section 1)
- Check 1d: Assertion structure — each assertion has id, positive, negative (Section 1)
- Check 1e: Controlled vocabulary — positive/negative fields contain MUST/MUST NOT/SHOULD/MAY (Section 3)
- Check 1f: Quality gate — no banned vague terms without specific observables (Section 4)
- Check 1g: 7x7 constraint — max 7 assertions per task, max 7 tasks per feature (Section 5)

**Gate 2: Assertion Audit (4 checks)**
- Check 2a: Completeness — every assertion ID from spec has a result in evidence report (Section 11)
- Check 2b: Status present — each result includes PASS or FAIL status (Section 11)
- Check 2c: Evidence format — each result includes file:line reference (Section 11)
- Check 2d: FAIL detail — FAIL results include expected vs actual (Section 11)

**Gate 3: File Scope Audit (2 checks with severity)**
- Check 3a: No out-of-scope modifications (BLOCKING) — every modified file appears in file_scope (Section 1, file_scope constraint)
- Check 3b: Completeness warning (NON-BLOCKING) — every file in file_scope was touched (warning only, implementer may have determined file didn't need changes)

**Failure Response Chain:**
```
Gate fails (any check)
  ↓
Dispatch implementer with feedback
  - Gate name (Gate 1/2/3)
  - Check name (1a, 1b, etc.)
  - Fail message (from gate spec)
  - Guidance (what to fix)
  ↓
Implementer fixes and re-submits
  ↓
Re-run all 3 gates from beginning
  ↓
Either: PASS (proceed to Layer 2) OR FAIL (task BLOCKED)
```

### Slice 3 Lifecycle Integration

Section 14 gates integrate with the Slice 3 expanded lifecycle (Section 15 in spec-protocol.md):

```
DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
         ↑                                      ↑
      Gate 1 check               Gates 1-3 check + all assertions PASS
```

- **DRAFT → LINT_PASS:** Gate 1 (Spec Lint) must pass before spec leaves DRAFT (planner creates spec)
- **EXECUTING → VERIFIED:** Gates 1-3 must pass + all assertions must report PASS (implementer completes task)

### Tier Applicability

| Tier | Layer 1 Gates | Layer 2 Reviewer | Applicability |
|------|---------------|-----------------|---------------|
| TRIVIAL | Skipped (no spec) | Skipped (no spec) | No gates, no review |
| SIMPLE | All 3 gates run | Optional per dispatch | Gates required, reviewer optional |
| MODERATE | All 3 gates run | Required | Gates + reviewer required |
| COMPLEX | All 3 gates run | Required | Gates + reviewer required |

### Previous Story Intelligence (Stories 1.1-3.2)

- spec-protocol.md has 13 sections (~1290 lines)
- Section 1: Spec Packet Format — defines what delimiters, YAML structure, required fields look like
- Section 3: Controlled Vocabulary — MUST/MUST NOT/SHOULD/MAY definitions and usage rules
- Section 4: Assertion Quality Gate — bans vague terms without specific observables, double-entry rule
- Section 5: Constraints & Governance — 7x7 rule (max 7 assertions, max 7 tasks)
- Section 10: Spec Lifecycle States (Slice 1) — DRAFT → ACTIVE → DONE
- Section 11: Evidence Reporting Protocol — how implementer reports assertion results with file:line references
- Section 15 (Slice 3): Expanded Lifecycle States (added by this story's predecessor) — 6-state model with formal gates
- Feature tracker (Story 3.1) and state machine (Story 3.2) exist but do not include gate logic yet

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-13 — this story adds Section 14 AFTER Section 13
- Keep content token-efficient — agents will read this via skill consumption
- Section 14 MUST reference Sections 1, 3, 4, 5, 11 (cross-references, no duplication)
- Gate checks MUST be specific and testable (not vague heuristics)
- Fail messages MUST be actionable (implementer knows exactly what to fix)
- Layer 1 gates are AUTOMATED (dispatch loop runs them)
- Layer 2 review is AGENT-DRIVEN (reviewer reads evidence and validates)

### Integration Points

- **CLAUDE.md:** No changes needed — gates run transparently between implementer completion and reviewer dispatch (Pattern 2)
- **spec-protocol.md Section 10:** Lifecycle states remain unchanged; Section 14 adds gate logic without modifying lifecycle
- **spec-protocol.md Section 15 (future):** Expanded lifecycle states will reference Section 14 gates at LINT_PASS and VERIFIED transitions
- **CLAUDE.md Pattern 2 (Worker-Reviewer):** Layer 1 gates consume 1 retry before entering Pattern 2's 3-cycle circuit breaker

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 14)
- No other files should be created or modified
- Gates are described as AUTOMATED BEHAVIOR in the protocol document

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#FR3 Two-layer verification gates]
- [Source: _bmad-output/planning-artifacts/architecture.md#FR4 Gate output mapping]
- [Source: _bmad-output/planning-artifacts/architecture.md#FR5 Evidence trail logging]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 3 Slice 3 Governance Expansion]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 953-1033 Complete Gate Specifications]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 2 Worker-Reviewer Team & Circuit Breaker]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 1 Spec Packet Format]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 3 Controlled Vocabulary]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 4 Assertion Quality Gate]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 5 Constraints & Governance]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 11 Evidence Reporting Protocol]
- [Source: _bmad-output/implementation-artifacts/spec-protocol.md#Section 15 Expanded Lifecycle States]
- [Source: _bmad-output/epics.md#Story 4.1 Two-Layer Verification Pipeline]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation (no errors anticipated for documentation task).

### Completion Notes List

- Added Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md — ~88 lines
- 2-layer architecture: Layer 1 automated gates (3 gates, 13 total checks) + Layer 2 agent review
- Gate 1 (Spec Lint): 7 checks validating spec packet structure, YAML, required fields, assertions, vocabulary, quality, 7x7
- Gate 2 (Assertion Audit): 4 checks validating evidence completeness, status, format, detail
- Gate 3 (File Scope Audit): 2 checks (blocking out-of-scope, warning untouched scope)
- Failure handling: specific feedback template with gate/check/message → implementer retry → re-run all gates → BLOCKED
- Retry cycle is separate from worker-reviewer circuit breaker (Section 10 Pattern 2)
- Tier applicability table: TRIVIAL (skipped), SIMPLE (gates only), MODERATE/COMPLEX (gates + reviewer)
- Layer 1 integrates with Slice 3 lifecycle: gates at LINT_PASS and VERIFIED transitions
- Layer 2 leverages existing Pattern 2 worker-reviewer team and circuit breaker
- Section 14 references Sections 1, 3, 4, 5, 11 for cross-validation (no duplication)
- Sections 1-13 untouched — verified no modifications outside Section 14
- All 7 ACs verified PASS

### Change Log

- 2026-02-20: Added Section 14 (Two-Layer Verification Pipeline) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 14 added after Section 13)
