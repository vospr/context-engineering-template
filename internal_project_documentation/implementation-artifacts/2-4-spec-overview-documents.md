# Story 2.4: Spec Overview Documents

Status: review

## Story

As a project lead,
I want human-readable spec overview documents created per feature,
so that I can review feature-level scope and acceptance criteria without parsing YAML.

## Acceptance Criteria

1. Spec overview documents are saved at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`
2. The overview contains: feature title, goal summary, task list with IDs, acceptance criteria summary
3. Feature IDs follow the pattern F-001, F-002 (zero-padded 3 digits)
4. Task IDs follow the pattern T-001, T-002 (globally unique across features)

## Tasks / Subtasks

- [x] Task 1: Add Section 9 (Spec Overview Documents) to spec-protocol.md (AC: #1, #2, #3, #4)
  - [x] Add new Section 9 after Section 8 (Inline Spec Delivery Protocol)
  - [x] Document the spec overview purpose: human-readable feature-level view for project leads and architects
  - [x] Specify the file naming convention: `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`
  - [x] Define the ID schemes: Feature IDs (F-001, F-002) and Task IDs (T-001, T-002)
  - [x] State that Feature IDs are zero-padded 3 digits, monotonically increasing
  - [x] State that Task IDs are globally unique across ALL features (not reset per feature)
  - [x] State that Assertion IDs (A1-A7) are unique within a task only (per Section 1)
- [x] Task 2: Define the spec overview document template (AC: #2)
  - [x] Create a markdown template showing the required structure of a spec overview
  - [x] Required sections: Feature Title, Goal Summary, Task List (with IDs and brief descriptions), Acceptance Criteria Summary
  - [x] Include a complete filled example of a spec overview document
  - [x] State when overviews are created: MODERATE and COMPLEX tiers only (per Section 7 routing)
- [x] Task 3: Document the relationship between overview, spec packets, and feature tracker (AC: #1, #2)
  - [x] Overview is human-readable; spec packets in task descriptions are machine-consumable — complementary, not competing
  - [x] Overview references task IDs that correspond to TaskList tasks with embedded spec packets
  - [x] Feature tracker (Epic 3, Slice 2) will reference the overview path in its `spec_overview` field
  - [x] State ownership: only the planner creates and updates spec overviews (per Pattern 6 from architecture)
- [x] Task 4: Validate completeness (AC: #1-#4)
  - [x] Verify naming convention is documented with examples
  - [x] Verify ID schemes (Feature, Task, Assertion) are all defined
  - [x] Verify template contains all 4 required sections
  - [x] Verify no modifications to Sections 1-8

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **FR7:** Spec overview documents created per feature in planning-artifacts/ following naming pattern spec-F-{NNN}-{kebab-name}-overview.md
- **Pattern 3 (lines 336-348):** Spec Overview Naming & Structure — file naming, ID schemes, required content
- **Pattern 4 (lines 350-370):** Feature Tracker Entry Format — `spec_overview` field references the overview path
- **Pattern 6 (lines 392-401):** State Transitions & Ownership — only the planner creates spec overviews
- **ADR-001 (lines 76-87):** Overview format is Markdown (human-readable, review-friendly); per-task format is YAML (machine-parseable)
- **Decision 3 (lines 242-259):** Spec overviews flat in planning-artifacts/ as `spec-{feature-id}-{name}-overview.md`
- **Lines 454-456:** Spec overview path referenced in project directory structure

### ID Scheme Summary (from architecture Pattern 3)

- **Feature IDs:** `F-001`, `F-002`, etc. — zero-padded 3 digits, monotonically increasing
- **Task IDs:** `T-001`, `T-002`, etc. — globally unique across features (never reset)
- **Assertion IDs:** `A1`, `A2`, etc. — unique within a task only (reset per task, max 7 per 7x7 rule)

### Previous Story Intelligence (Stories 2.1-2.3)

- Section 7 (Story 2.2) routing already states MODERATE and COMPLEX tiers create spec overviews
- Section 8 (Story 2.3) documents inline spec packet delivery — overviews complement these by providing human-readable view
- CLAUDE.md has 3 SDD lines (Story 2.1) — no further CLAUDE.md changes needed
- spec-protocol.md now has 8 sections (~517 lines)

### Previous Story Intelligence (Stories 1.1-1.3)

- Section 2 COMPLEX tier example references: `planning-artifacts/spec-F-003-oauth-integration-overview.md` — this is the naming pattern being formalized
- Section 1 defines assertion IDs (A1-A7) as unique within task

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/skills/spec-protocol.md` — do NOT create any new files
- Do NOT modify Sections 1-8 — those belong to previous stories
- Add Section 9 AFTER Section 8
- Keep content token-efficient
- Do NOT create an actual spec overview file — just document the protocol and template

### Project Structure Notes

- Target file: `.claude/skills/spec-protocol.md` (EDIT existing — append Section 9)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 3: Spec Overview Naming & Structure]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 4: Feature Tracker Entry Format]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 6: State Transitions & Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-001 Spec Format]
- [Source: _bmad-output/planning-artifacts/architecture.md#Decision 3: File Organization]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 2.4]
- [Source: _bmad-output/implementation-artifacts/2-3-inline-spec-packet-delivery-via-tasklist.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Added Section 9 (Spec Overview Documents) to spec-protocol.md — ~80 lines
- Naming convention: `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md` with 3 examples
- ID Schemes table: Feature (F-{NNN} global), Task (T-{NNN} global), Assertion (A{N} per-task)
- Overview template with 4 required sections: Feature Title, Goal, Task List, AC Summary + Notes
- Filled example: F-001 User Authentication with 3 tasks and 3 acceptance criteria
- Tier gating: TRIVIAL/SIMPLE = no overview, MODERATE/COMPLEX = planner creates overview
- Relationship table: overview (Markdown/humans) vs spec packets (YAML/implementers) vs tracker (JSON/dispatch loop)
- Ownership: planner-only, referencing Governance Principle 8
- Sections 1-8 untouched — verified via section header line check
- All 4 ACs verified PASS

### Change Log

- 2026-02-17: Added Section 9 (Spec Overview Documents) to spec-protocol.md

### File List

- `.claude/skills/spec-protocol.md` (MODIFIED — Section 9 added after Section 8)
