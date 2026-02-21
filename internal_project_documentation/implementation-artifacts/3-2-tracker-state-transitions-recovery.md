# Story 3.2: Tracker State Transitions & Recovery

Status: review

## Story

As a dispatch loop,
I want the feature tracker to update automatically as tasks progress and recover gracefully from corruption,
so that project state is always accurate and the system never gets permanently stuck.

## Acceptance Criteria

1. When all tasks for a feature report PASS on all assertions, the dispatch loop flips `verified` to true and `phase` to DONE
2. Only the planner creates tracker entries; only the dispatch loop updates phase and verified
3. If feature-tracker.json fails to parse, the system degrades gracefully to non-SDD mode
4. The tracker is recoverable via `git checkout` if corrupted
5. A feature with 3+ BLOCKED tasks is flagged for re-spec

## Tasks / Subtasks

- [x] Task 1: Add Section 13 (Tracker State Machine) to spec-protocol.md (AC: #1, #2, #5)
  - [x] Add new Section 13 after Section 12 (Feature Tracker Protocol)
  - [x] Document the automated state transition logic the dispatch loop performs after each task completion
  - [x] Define the verification check: for each task ID in `tasks`, check if ALL assertion IDs have PASS evidence
  - [x] Define the DONE transition: when every task in the feature has all assertions PASS → set verified=true, phase=DONE
  - [x] Define the re-spec trigger: when 3+ tasks in a feature are BLOCKED → flag feature for re-spec via NEEDS_RESPEC
  - [x] Document the dispatch loop's post-task-completion checklist (check evidence → update tracker → check re-spec threshold)
  - [x] Reinforce ownership: only dispatch loop performs these transitions (Section 12 ownership rules)
- [x] Task 2: Document recovery and graceful degradation (AC: #3, #4)
  - [x] Document JSON parse failure handling: if feature-tracker.json is unreadable → fall back to non-SDD mode
  - [x] Document git recovery: `git checkout planning-artifacts/feature-tracker.json` restores last committed version
  - [x] Document rebuild procedure: reconstruct tracker from spec overview documents + TaskList state
  - [x] State that graceful degradation means TaskList-only dispatch continues — no tasks are lost, only feature-level tracking pauses
  - [x] Document what "non-SDD mode" means in degradation: tasks execute without feature-level tracking, assertions still enforced per-task
- [x] Task 3: Document the feature stall detection pattern (AC: #5)
  - [x] Define stall: 3+ tasks in a single feature reach BLOCKED status
  - [x] Define response: dispatch loop flags feature for re-spec, NEEDS_RESPEC flag triggers planner to re-evaluate decomposition
  - [x] State that re-spec means: planner re-examines the feature, may restructure tasks, may update spec overview
  - [x] Reference CLAUDE.md Step 6 NEEDS_RESPEC handling (Story 2.1)
- [x] Task 4: Validate completeness (AC: #1-#5)
  - [x] Verify automated DONE transition logic is documented
  - [x] Verify ownership rules consistent with Section 12
  - [x] Verify graceful degradation is documented
  - [x] Verify git recovery is documented
  - [x] Verify re-spec threshold (3+ BLOCKED) is documented
  - [x] Verify no modifications to Sections 1-12

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Decision 5 (lines 269-278):** Failure & Recovery Matrix — feature stalls (3+ BLOCKED tasks), tracker corrupt (JSON parse fails)
- **Pattern 6 (lines 392-401):** State Transitions & Ownership — dispatch loop changes feature phase, flips verified
- **Vulnerability 4 (line 159):** Feature tracker SPOF — git backup, rebuildable from source files + TaskList, graceful degradation
- **Decision 1 (lines 221-228):** Spec Lifecycle — DONE transition when all assertions pass
- **Lines 275-276:** "Feature stalls (3+ BLOCKED tasks) → Flag feature for re-spec, planner re-evaluates decomposition"
- **Lines 277-278:** "Feature tracker corrupt → Graceful degradation to non-SDD mode; git checkout recovers"

### Previous Story Intelligence (Story 3.1)

- Section 12 already documents: JSON schema, ownership rules table, phase transitions, basic recovery (3-step)
- Section 12 ownership: planner creates entries + adds task IDs, dispatch loop updates phase + verified
- Section 12 recovery subsection has the 3 recovery steps — Section 13 expands on degradation details and stall detection
- Section 13 adds: automated transition LOGIC (the dispatch loop's algorithm), stall detection, expanded degradation behavior

### What Section 13 Adds vs What Already Exists

| Concern | Section 12 (exists) | Section 13 (adds) |
|---------|--------------------|--------------------|
| Phase transitions | Defined (DRAFT→ACTIVE→DONE) | **Automated transition algorithm** |
| Ownership | Defined (planner/dispatch loop) | Reinforced — no changes |
| Recovery | 3-step overview | **Expanded degradation behavior** |
| Stall detection | — | **NEW: 3+ BLOCKED → re-spec** |
| Post-task checklist | — | **NEW: dispatch loop algorithm** |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-12
- Add Section 13 AFTER Section 12
- Keep content token-efficient
- Do NOT duplicate Section 12 content — reference it

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 13)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 5: Failure & Recovery Matrix]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 6: State Transitions & Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#Vulnerability 4: Tracker SPOF]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.2]
- [Source: _bmad-output/implementation-artifacts/3-1-feature-tracker-json-schema-initialization.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 13 (Tracker State Machine & Recovery) to spec-protocol.md — ~90 lines
- 6-step post-task completion checklist for dispatch loop
- Automated DONE transition with pseudocode algorithm
- Feature stall detection: 3+ BLOCKED tasks → NEEDS_RESPEC with rationale (nearly half of 7x7 max)
- Graceful degradation table: 6 capabilities compared in SDD vs degraded mode
- 3 recovery procedures: git recovery (fastest), manual rebuild (4-step), fresh start
- References CLAUDE.md Step 6 NEEDS_RESPEC handling and Section 12 ownership rules
- Sections 1-12 untouched — verified via section header line check
- All 5 ACs verified PASS
- Epic 3 implementation COMPLETE — both stories delivered

### Change Log

- 2026-02-17: Added Section 13 (Tracker State Machine & Recovery) to spec-protocol.md — Epic 3 complete

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 13 added after Section 12)
