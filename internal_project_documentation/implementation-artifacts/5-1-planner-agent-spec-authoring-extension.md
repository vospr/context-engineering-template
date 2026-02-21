# Story 5.1: Planner Agent Spec Authoring Extension

Status: review

## Story

As a planner agent,
I want permanent spec authoring capability built into my agent definition,
so that I author specs natively without consuming the spec-protocol.md skill each time.

## Acceptance Criteria

1. Planner natively authors spec packets following Pattern 1 format (Section 1)
2. Planner creates spec overview documents following naming convention (Section 9)
3. Planner creates feature tracker entries following JSON schema (Section 12)
4. Planner performs gap detection — identifying missing requirements or ambiguous criteria before speccing
5. Planner only specs the next 3-5 tasks (just-in-time decomposition), not the entire DAG

## Tasks / Subtasks

- [x] Task 1: Extend planner.md with SDD spec authoring responsibility (AC: #1, #2, #3)
  - [x] Add `spec-protocol.md` to the planner's skills list in frontmatter
  - [x] Add a new "## SDD Spec Authoring" section after the existing Process section
  - [x] Document that when SDD mode is active (spec-protocol.md exists), the planner authors spec packets natively
  - [x] Define the spec authoring workflow: classify tier → write spec packet → embed in TaskCreate → create overview (MODERATE+) → update feature tracker
  - [x] Reference Pattern 1 (Section 1) for spec packet format — do NOT duplicate the format
  - [x] Reference Section 9 for spec overview naming convention
  - [x] Reference Section 12 for feature tracker entry format
  - [x] Add Read tool to planner's tools if not already present (needed for reading feature-tracker.json) — already present
- [x] Task 2: Add gap detection capability (AC: #4)
  - [x] Define gap detection as a pre-speccing step: before writing any specs, scan for missing requirements or ambiguous criteria
  - [x] Define what constitutes a gap: missing acceptance criteria, ambiguous scope, circular dependencies, missing file_scope entries, untestable assertions
  - [x] Document the gap detection output: list of gaps with severity (blocking vs advisory)
  - [x] Blocking gaps must be resolved before speccing proceeds — planner reports gaps to dispatch loop for user clarification
  - [x] Advisory gaps are logged as warnings in the spec overview
- [x] Task 3: Add just-in-time decomposition rule (AC: #5)
  - [x] Document the JIT rule: planner specs the next 3-5 tasks only, not the full feature DAG
  - [x] Rationale: prevents over-speccing tasks that may change based on earlier task results
  - [x] Define when to spec the next batch: after current batch reaches VERIFIED (Section 15) or if remaining tasks < 2
  - [x] Reference the 7x7 constraint (Section 5) — max 7 tasks per feature total, spec 3-5 at a time
  - [x] State that the spec overview is created upfront with all planned tasks, but per-task spec packets are authored JIT
- [x] Task 4: Update planner task description template for SDD (AC: #1, #2)
  - [x] Extend the existing task description template to include the YAML spec packet between delimiters
  - [x] Reference Section 8 for full embedding workflow — compact reference instead of duplicating template
  - [x] State that for TRIVIAL tasks, the template is used without a spec packet (zero overhead)
  - [x] State that for SIMPLE tasks, the spec packet is minimal (~60 tokens, Section 6)
  - [x] State that for MODERATE/COMPLEX tasks, the full spec packet + overview are created
- [x] Task 5: Validate completeness (AC: #1-#5)
  - [x] Verify spec authoring workflow references all relevant spec-protocol.md sections
  - [x] Verify gap detection is documented with blocking vs advisory distinction
  - [x] Verify JIT decomposition (3-5 tasks) is documented
  - [x] Verify planner.md remains under 120 lines (token efficiency) — exactly 120 lines
  - [x] Verify existing planner capabilities are preserved — SDD is additive

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **ADR-002 (lines 88-96):** Spec Authoring — Skill-First (Slice 1), Agent Extension (Slice 4). "Extend planner.md with permanent spec authoring responsibility — only after format is proven stable through 3 slices."
- **Line 46:** Tier 6 — "Planner gains spec authoring + gap detection"
- **Line 70:** Slice 4 goals — "Full hybrid spec model + agent extensions (planner/reviewer/tester modes)"
- **Line 43:** Tier 3 — "just-in-time decomposition (spec next 3-5 tasks, not entire DAG)"
- **Line 435:** planner.md — "Task DAG + spec authoring (Slice 4: permanent extension)"
- **Lines 396-400:** Pattern 6 ownership — "Only the planner creates feature tracker entries and spec overviews"
- **Lines 499-501:** Dispatch flow — planner writes minimal/full spec + overview per tier
- **Line 545:** Slice 4 deliverables — modified planner.md, reviewer.md, tester.md

### Previous Story Intelligence (All Epics 1-4)

- Section 1 defines spec packet format (Pattern 1) — planner must author these natively
- Section 6 defines tier classification — planner uses this to determine spec depth
- Section 8 defines inline spec delivery — planner embeds in TaskCreate
- Section 9 defines spec overview naming — planner creates these for MODERATE+
- Section 12 defines feature tracker JSON schema — planner creates entries
- Section 14 defines Gate 1 (Spec Lint) — planner's output must pass this
- Section 15 defines expanded lifecycle — planner's spec starts at DRAFT
- Section 16 defines constitution — planner checks Phase -1 gates if constitution exists
- Current planner.md: 69 lines, skills: [] (empty — currently reads spec-protocol.md via dispatch prompt)

### What This Story Changes

| File | Change | Scope |
|------|--------|-------|
| `.claude/agents/planner.md` | Extended with SDD spec authoring | ~40-50 lines added |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/agents/planner.md` — do NOT create any new files
- Do NOT modify spec-protocol.md or CLAUDE.md
- Preserve ALL existing planner capabilities — SDD is additive
- Keep planner.md under 120 lines for token efficiency
- Reference spec-protocol.md sections — do NOT duplicate protocol content into agent definition
- Agent isolation (NFR5): planner only creates specs and tracker entries, never modifies code or reviews

### Project Structure Notes

- Target file: `.claude/agents/planner.md` (EDIT existing — extend with SDD capabilities)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-002 Spec Authoring]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 46 Agent Extensions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 43 JIT Decomposition]
- [Source: _bmad-output/planning-artifacts/architecture.md#Pattern 6 State Transitions & Ownership]
- [Source: _bmad-output/planning-artifacts/architecture.md#Lines 499-501 Dispatch Flow]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.1]
- [Source: _bmad-output/implementation-artifacts/4-3-optional-constitution-failure-pattern-library.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Extended planner.md from 69 → 120 lines (+51 lines of SDD capabilities)
- Added `spec-protocol` to skills frontmatter — planner now has native access to spec-protocol.md
- 6-step spec authoring workflow: classify tier → gap detection → write specs → embed in TaskCreate → create overview → update tracker
- Tier behavior table: TRIVIAL (no spec), SIMPLE (minimal), MODERATE (full + overview + tracker), COMPLEX (architect first)
- Gap detection table: 5 gap types with blocking/advisory severity and actions
- Just-in-time decomposition: spec 3-5 tasks at a time, overview created upfront, per-task packets authored JIT
- SDD task description template: compact reference to Section 8 embedding workflow
- Pre-spec checks: constitution Phase -1 gates + failure pattern review (Section 16)
- Constraints extended: ownership boundaries + specs-only restriction
- All existing planner capabilities preserved — Role, Process, Task Sizing, Output Format unchanged
- Exactly 120 lines — meets token efficiency target
- All 5 ACs verified PASS
- Epic 5 Story 1 of 4 complete

### Change Log

- 2026-02-18: Extended planner.md with SDD spec authoring capabilities
- 2026-02-21: Story 6.x enhancements — Pre-Spec Checks strengthened to MANDATORY failure-pattern consultation (Story 6.2); Reasoning Strategy Selection section added before SDD Spec Authoring (Story 6.5); **Trace** field added to artifact template (Story 6.1).

### File List

- `.claude/agents/planner.md` (MODIFIED — SDD Spec Authoring section added)
- `.claude/agents/planner.md` (MODIFIED 2026-02-21 — Mandatory Pre-Spec Checks, Reasoning Strategy Selection, Trace field)
