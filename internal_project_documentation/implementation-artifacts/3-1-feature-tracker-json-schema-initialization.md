# Story 3.1: Feature Tracker JSON Schema & Initialization

Status: review

## Story

As a main agent starting a new session,
I want a JSON feature tracker that I can read to reconstruct project state,
so that I can answer "where are we?" without replaying conversation history.

## Acceptance Criteria

1. When a planner creates a new feature, it writes to `planning-artifacts/feature-tracker.json`
2. Each entry contains fields in this exact order: id, title, phase, spec_overview, tasks[], verified
3. `phase` uses Slice 1 values: DRAFT | ACTIVE | DONE
4. `tasks` references TaskList task IDs
5. `verified` is false until ALL task assertions pass
6. The file is valid JSON parseable by any standard parser

## Tasks / Subtasks

- [x] Task 1: Add Section 12 (Feature Tracker Protocol) to spec-protocol.md (AC: #1, #2, #3, #4, #5, #6)
  - [x] Add new Section 12 after Section 11 (Evidence Reporting Protocol)
  - [x] Define the feature tracker purpose: feature-level progress index that survives context resets
  - [x] Specify the file location: `planning-artifacts/feature-tracker.json`
  - [x] Define the JSON schema with fields in exact order: id, title, phase, spec_overview, tasks[], verified
  - [x] Define `phase` values: DRAFT (planner creating specs), ACTIVE (tasks dispatched), DONE (all verified)
  - [x] Define `tasks` as array of TaskList task IDs (T-{NNN} format from Section 9)
  - [x] Define `verified` as boolean — false until ALL task assertions pass
  - [x] State the file MUST be valid JSON parseable by any standard parser
- [x] Task 2: Document the feature tracker entry template and example (AC: #2, #6)
  - [x] Provide the exact JSON entry format as a template
  - [x] Provide a complete example with multiple features in different phases
  - [x] Show the full file structure (JSON array of feature entries)
  - [x] State field ordering MUST match the template exactly
- [x] Task 3: Document ownership and state transition rules (AC: #1, #3, #4, #5)
  - [x] Only the planner creates new entries (when speccing a MODERATE+ feature)
  - [x] Only the dispatch loop updates `phase` and `verified` fields
  - [x] Document phase transitions: DRAFT → ACTIVE (first task dispatched) → DONE (all tasks verified)
  - [x] Document verified transition: false → true (when ALL tasks in the feature have all assertions PASS)
  - [x] Reference Section 10 lifecycle states — feature tracker phase aligns with spec lifecycle
  - [x] State relationship to CLAUDE.md Step 2: dispatch loop checks feature-tracker.json for unverified features
- [x] Task 4: Validate completeness (AC: #1-#6)
  - [x] Verify JSON schema has all 6 required fields
  - [x] Verify phase values match Section 10 lifecycle states
  - [x] Verify ownership rules match Pattern 6 from architecture
  - [x] Verify no modifications to Sections 1-11

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR12 (epics line 31):** Feature tracker JSON index file at planning-artifacts/feature-tracker.json
- **ADR-004 (lines 109-119):** Feature Tracker — JSON Index File. Format, role, Slice 2 required fields, TaskList relationship.
- **Pattern 4 (lines 350-370):** Feature Tracker Entry Format — exact JSON structure with field ordering
- **Pattern 6 (lines 392-401):** State Transitions & Ownership — planner creates entries, dispatch loop updates phase/verified
- **Decision 1 (lines 221-228):** Spec Lifecycle states align with tracker phase (DRAFT/ACTIVE/DONE)
- **Truth 6 (line 32):** "The system must be able to answer 'where are we?' at any moment from files alone" — feature tracker implements this
- **Truth 4 (line 30):** "State must survive context death" — tracker is the durable feature-level state
- **Vulnerability 4 (line 159):** Feature tracker single point of failure — git backup, graceful degradation

### Pattern 4 from Architecture (verbatim)

```json
{
  "id": "F-001",
  "title": "User Authentication",
  "phase": "ACTIVE",
  "spec_overview": "planning-artifacts/spec-F-001-auth-overview.md",
  "tasks": ["T-001", "T-002", "T-003"],
  "verified": false
}
```

### Previous Story Intelligence (Stories 2.1-2.5)

- spec-protocol.md now has 11 sections (~720 lines)
- Section 9 defines Feature IDs (F-{NNN}) and Task IDs (T-{NNN}) — tracker uses these same ID schemes
- Section 9 defines spec overview naming — tracker's `spec_overview` field references these paths
- Section 10 defines lifecycle states DRAFT/ACTIVE/DONE — tracker phase aligns with these
- CLAUDE.md Step 2 (Story 2.1) already references feature-tracker.json: "If no tasks AND spec-protocol.md exists AND feature-tracker.json has unverified features → dispatch planner to spec next feature"

### Critical Constraints

- Pure markdown only (NFR3) — the protocol goes in spec-protocol.md; the actual JSON file is created at runtime by the planner
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files (including feature-tracker.json itself)
- Do NOT modify Sections 1-11
- Add Section 12 AFTER Section 11
- Keep content token-efficient
- JSON schema MUST match Pattern 4 from architecture exactly

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 12)
- No other files should be created or modified
- `planning-artifacts/feature-tracker.json` will be created at runtime by the planner — NOT by this story

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-004 Feature Tracker]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 4: Feature Tracker Entry Format]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 6: State Transitions & Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#Truth 4 and Truth 6]
- [Source: _bmad-output/planning-artifacts/architecture.md#Vulnerability 4: Tracker SPOF]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.1]
- [Source: _bmad-output/implementation-artifacts/2-5-spec-lifecycle-states-evidence-reporting.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 12 (Feature Tracker Protocol) to spec-protocol.md — ~95 lines
- JSON schema: 6 fields (id, title, phase, spec_overview, tasks[], verified) with field table
- Complete file example: 3 features in DONE/ACTIVE/DRAFT phases showing full JSON array structure
- Ownership rules table: planner creates entries + adds task IDs, dispatch loop updates phase + verified
- Phase transitions: DRAFT → ACTIVE → DONE aligned with Section 10 lifecycle states
- Integration with CLAUDE.md Step 2: dispatch loop checks for unverified features
- Recovery: 3-step process (graceful degradation → git recovery → rebuild from spec overviews)
- Sections 1-11 untouched — verified via section header line check
- All 6 ACs verified PASS

### Change Log

- 2026-02-17: Added Section 12 (Feature Tracker Protocol) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 12 added after Section 11)
