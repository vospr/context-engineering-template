# Story 4.2: Expanded Lifecycle States & Graduated Escalation

Status: done

## Story

As a project lead,
I want formal lifecycle states with quality gates at each transition and graduated escalation for failures,
so that spec integrity is enforced progressively and problems surface early.

## Acceptance Criteria

1. Specs follow expanded lifecycle: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
2. Each transition has a defined gate (lint passes, reviewer approves, all assertions pass, feature-level check)
3. Graduated escalation applies: Green (all pass) → Yellow (minor issues) → Orange (major issues, reviewer escalation) → Red (BLOCKED, user escalation)
4. The spec-level circuit breaker halts a feature after 3 consecutive BLOCKED tasks

## Tasks / Subtasks

- [x] Task 1: Add Section 15 (Expanded Lifecycle States) to spec-protocol.md (AC: #1, #2)
  - [x] Add new Section 15 after Section 14 (Two-Layer Verification Pipeline)
  - [x] Replace Section 10's placeholder with the full 6-state lifecycle model
  - [x] Define each state: DRAFT, LINT_PASS, RATIFIED, EXECUTING, VERIFIED, GRADUATED
  - [x] Define the gate at each transition — what must pass to advance
  - [x] Map gates to existing infrastructure: Gate 1 (Section 14 spec lint), reviewer approval, assertion evidence (Section 11), feature tracker verified (Section 12)
  - [x] Define GRADUATED as feature-level terminal state — all tasks in the feature have VERIFIED specs
  - [x] Reference Section 10's immutability rule — still applies in expanded lifecycle
- [x] Task 2: Define Graduated Escalation Protocol (AC: #3)
  - [x] Define 4 escalation levels: Green, Yellow, Orange, Red
  - [x] Green: all gates pass, all assertions PASS — proceed normally
  - [x] Yellow: minor issues (warnings from Gate 3, SHOULD violations) — proceed with logged warning
  - [x] Orange: major issues (MUST violations, FAIL assertions) — escalate to reviewer with specific findings
  - [x] Red: BLOCKED — 3 consecutive failures or unresolvable issue — escalate to user
  - [x] Map escalation levels to existing circuit breaker (Section 14 retry + worker-reviewer 3 cycles)
  - [x] State that escalation is cumulative: Yellow warnings that recur become Orange
- [x] Task 3: Define Spec-Level Circuit Breaker (AC: #4)
  - [x] Define: if 3 tasks in a feature reach BLOCKED → halt entire feature
  - [x] Connect to Section 13 feature stall detection (3+ BLOCKED → NEEDS_RESPEC)
  - [x] State that spec-level circuit breaker triggers BEFORE feature stall — it's per-spec, not per-feature
  - [x] Clarify relationship: task circuit breaker (3 reviewer cycles) → spec-level circuit breaker (3 BLOCKED tasks in feature) → feature stall (NEEDS_RESPEC)
  - [x] Document the escalation cascade: task-level → spec-level → feature-level
- [x] Task 4: Document state transition integration with existing sections (AC: #1, #2)
  - [x] Map each expanded state to the layer that produces it: Layer 1 gates → LINT_PASS, reviewer → RATIFIED, implementer → EXECUTING, assertion audit → VERIFIED, feature tracker → GRADUATED
  - [x] Reference Section 14 (Two-Layer Verification) for LINT_PASS transition
  - [x] Reference Section 12/13 (Feature Tracker) for GRADUATED transition
  - [x] State that Section 10's 3-state model remains valid for Slice 1/2 projects — expanded lifecycle is Slice 3
  - [x] Document backward compatibility: 3-state ↔ 6-state mapping (DRAFT=DRAFT, ACTIVE=LINT_PASS|RATIFIED|EXECUTING, DONE=VERIFIED|GRADUATED)
- [x] Task 5: Validate completeness (AC: #1-#4)
  - [x] Verify all 6 states defined with entry/exit criteria
  - [x] Verify all transition gates map to existing infrastructure
  - [x] Verify graduated escalation (Green/Yellow/Orange/Red) documented
  - [x] Verify spec-level circuit breaker documented
  - [x] Verify backward compatibility with 3-state model
  - [x] Verify no modifications to Sections 1-14

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Decision 1 (lines 221-228):** Spec Lifecycle — Progressive States. Slice 1: DRAFT → ACTIVE → DONE. Slice 3: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED.
- **Line 44:** Tier 4 — "graduated escalation (Green → Yellow → Orange → Red); graduation ceremony (formal feature completion)"
- **Line 69:** Slice 3 goals — "Constitution + spec ratification + two-layer verification + graduated escalation + spec-level circuit breaker"
- **Lines 217-218:** Deferred decisions — "Full spec lifecycle states (LINT_PASS, RATIFIED, GRADUATED)" and "Spec-level circuit breaker"
- **Line 226:** Full Slice 3 state progression with quality gates at each transition
- **Lines 269-278:** Decision 5 — Failure & Recovery Matrix — circuit breaker patterns

### Previous Story Intelligence (Stories 2.1-2.5, 3.1-3.2, 4.1)

- Section 10 defines current 3-state model (DRAFT → ACTIVE → DONE) with placeholder for Slice 3 expansion (lines 653-661)
- Section 10 immutability rule (lines 645-651) — still applies in expanded lifecycle
- Section 11 defines evidence reporting — maps to VERIFIED transition gate
- Section 12/13 define feature tracker and stall detection — maps to GRADUATED transition and spec-level circuit breaker
- Section 14 defines two-layer verification pipeline — Gate 1 (spec lint) maps to LINT_PASS transition
- Section 14 retry cycle (1 retry before BLOCKED) — feeds into graduated escalation
- spec-protocol.md now has 14 sections (~1014 lines)

### What Section 15 Adds vs What Already Exists

| Concern | Existing Section | Section 15 Adds |
|---------|-----------------|-----------------|
| Lifecycle states | Section 10 (3-state) | **6-state expanded lifecycle with gates** |
| Quality gates | Section 14 (automated gates) | **Gate-to-state mapping** |
| Escalation | Section 14 (retry + BLOCKED) | **NEW: 4-level graduated escalation** |
| Circuit breaker (task) | Section 14 / CLAUDE.md | Referenced — no change |
| Circuit breaker (spec) | — | **NEW: 3 BLOCKED tasks halt feature** |
| Circuit breaker (feature) | Section 13 (stall detection) | **Escalation cascade connecting all 3** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-14
- Add Section 15 AFTER Section 14
- Keep content token-efficient
- Reference existing sections for gate criteria — do NOT duplicate rules
- Section 10's 3-state model remains valid — Section 15 EXTENDS it for Slice 3, not replaces

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 15)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 1: Spec Lifecycle Progressive States]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 44 Tier 4 Graduated Escalation]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 69 Slice 3 Goals]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 217-218 Deferred Decisions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 5: Failure & Recovery Matrix]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.2]
- [Source: _bmad-output/implementation-artifacts/4-1-two-layer-automated-verification-pipeline.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 15 (Expanded Lifecycle States & Graduated Escalation) to spec-protocol.md — ~100 lines
- 6-state lifecycle: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED with gate table mapping each transition to existing infrastructure
- 5 transition rules with gate owners and failure responses
- GRADUATED defined as feature-level terminal state (not task-level)
- Backward compatibility table: 3-state ↔ 6-state mapping for Slice 1/2 projects
- Graduated escalation: Green/Yellow/Orange/Red with triggers, responses, and examples
- Escalation rules: Yellow → Orange (recurring warnings), Orange → Red (exhausted retries)
- 3-layer escalation cascade: task circuit breaker → spec-level circuit breaker → feature stall
- Spec-level circuit breaker: 3 BLOCKED tasks → halt feature + NEEDS_RESPEC
- Tier applicability: SIMPLE skips RATIFIED/GRADUATED, MODERATE/COMPLEX use full pipeline
- Sections 1-14 untouched — verified via section header line check
- All 4 ACs verified PASS
- Epic 4 Story 2 of 3 complete

### Change Log

- 2026-02-18: Added Section 15 (Expanded Lifecycle States & Graduated Escalation) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 15 added after Section 14)
