# Story 5.3: Tester Assertion Execution & Integration Modes

Status: review

## Story

As a tester agent,
I want assertion execution mode and integration verification mode,
so that I can independently verify implementer claims and check feature-level integration.

## Acceptance Criteria

1. In assertion execution mode, the tester independently re-executes each assertion from the spec packet against the actual codebase
2. Results are compared against implementer-reported evidence, and discrepancies are flagged as NEEDS_INVESTIGATION
3. In integration verification mode, the tester checks feature-level assertions from the spec overview
4. The tester verifies cross-task interactions work correctly and reports integration results per feature ID

## Tasks / Subtasks

- [x] Task 1: Extend tester.md with SDD Assertion Execution Mode (AC: #1, #2)
  - [x] Add `spec-protocol` to the tester's skills list in frontmatter
  - [x] Add a new "## SDD Assertion Execution Mode" section after the existing Constraints section
  - [x] Define activation: when dispatched with mode=assertion-execution and a task with embedded spec packet
  - [x] Define the assertion re-execution workflow: read spec packet → read implementer evidence → independently verify each assertion against codebase
  - [x] Define verification method: for each assertion, check the file:line reference, verify the observable matches the assertion's positive/negative claim
  - [x] Define NEEDS_INVESTIGATION flag: when tester's finding contradicts implementer-reported evidence
  - [x] Document output: per-assertion comparison (implementer claim vs tester finding) with CONFIRMED/NEEDS_INVESTIGATION status
- [x] Task 2: Extend tester.md with SDD Integration Verification Mode (AC: #3, #4)
  - [x] Add a new "## SDD Integration Verification Mode" section
  - [x] Define activation: when dispatched with mode=integration-verification and a feature ID
  - [x] Define the integration workflow: read spec overview → identify cross-task dependencies → verify integration points
  - [x] Define what to check: cross-task file interactions, shared state consistency, feature-level acceptance criteria from overview
  - [x] Document output: per-feature integration report with feature ID, cross-task findings, integration status
  - [x] Report integration results per feature ID (F-{NNN})
- [x] Task 3: Define tester-specific output formats for SDD modes (AC: #1, #2, #3, #4)
  - [x] Assertion execution report: assertion ID, implementer claim, tester finding, status (CONFIRMED/NEEDS_INVESTIGATION)
  - [x] Integration verification report: feature ID, tasks checked, cross-task interactions, integration status (PASS/PARTIAL/FAIL)
  - [x] Both formats written to implementation-artifacts/ following existing naming convention
  - [x] Discrepancy details include: what implementer claimed, what tester found, which file:line was checked
- [x] Task 4: Document integration with verification pipeline (AC: #1, #2)
  - [x] Assertion execution mode closes Vulnerability 3 (architecture line 158): "Self-graded assertions — fully closed in Slice 3 with independent tester execution"
  - [x] Maps to Section 15 EXECUTING → VERIFIED transition — tester provides independent verification
  - [x] Reference Section 14 Layer 2 (Agent Review) — tester can be dispatched alongside or instead of reviewer for assertion verification
  - [x] Reference Section 11 evidence reporting format — tester validates against this standard
- [x] Task 5: Validate completeness (AC: #1-#4)
  - [x] Verify assertion execution mode documented with re-execution workflow
  - [x] Verify NEEDS_INVESTIGATION flag defined for discrepancies
  - [x] Verify integration verification mode documented with feature-level scope
  - [x] Verify cross-task interaction checks documented
  - [x] Verify tester.md at 107 lines — well under 120 target
  - [x] Verify existing tester capabilities preserved — SDD modes are additive

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Line 46:** Tier 6 — "tester gains assertion execution + integration verification modes"
- **Line 70:** Slice 4 — "agent extensions (planner/reviewer/tester modes)"
- **Line 439:** tester.md — "Test execution + assertion execution (Slice 4: triple mode)"
- **ADR-003 (line 105):** "Tester extension: Slice 3 (assertion execution mode + integration mode) — Only after verification needs are proven"
- **Vulnerability 3 (line 158):** "Self-graded assertions — fully closed in Slice 3 with independent tester execution"
- **Line 545:** Slice 4 deliverables — modified planner.md, reviewer.md, tester.md

### Previous Story Intelligence (Stories 4.1, 4.2, 5.1, 5.2)

- Section 11 defines evidence reporting format — tester validates implementer evidence against this
- Section 14 defines two-layer verification — tester provides independent assertion verification in Layer 2
- Section 15 defines EXECUTING → VERIFIED gate — tester's assertion execution confirms this transition
- Section 9 defines spec overview documents — tester reads these for integration verification
- Section 12/13 define feature tracker — tester reports per feature ID
- Current tester.md: 64 lines, skills: ["testing-strategy"]
- Planner extended in Story 5.1 (120 lines), reviewer extended in Story 5.2 (91 lines)

### What This Story Changes

| File | Change | Scope |
|------|--------|-------|
| `.claude/agents/tester.md` | Extended with 2 SDD modes | ~45-50 lines added |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/agents/tester.md` — do NOT create any new files
- Do NOT modify spec-protocol.md, CLAUDE.md, planner.md, or reviewer.md
- Preserve ALL existing tester capabilities — SDD modes are additive
- Keep tester.md under 120 lines for token efficiency
- Tester does NOT modify source code — read + execute + report only
- Reference spec-protocol.md sections — do NOT duplicate protocol content

### Project Structure Notes

- Target file: `.claude/agents/tester.md` (EDIT existing — extend with SDD modes)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Line 46 Agent Extensions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 439 Tester Triple Mode]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-003 Verification]
- [Source: _bmad-output/planning-artifacts/architecture.md#Vulnerability 3 Self-Graded Assertions]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.3]
- [Source: _bmad-output/implementation-artifacts/5-2-reviewer-spec-review-mode.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Extended tester.md from 64 → 107 lines (+43 lines of SDD capabilities)
- Added `spec-protocol` to skills frontmatter
- Assertion Execution Mode: 5-step workflow (read spec → read evidence → verify each assertion → compare → report)
- CONFIRMED/NEEDS_INVESTIGATION status per assertion — discrepancies escalate to dispatch loop
- Closes Vulnerability 3: self-graded assertions now independently verified
- Integration Verification Mode: 5-step workflow (read overview → read tracker → check cross-task → verify criteria → report)
- Cross-task interaction table: COMPATIBLE/CONFLICT status per shared file
- Feature acceptance checklist from overview criteria
- Lifecycle integration: maps to EXECUTING → VERIFIED (Section 15), Layer 2 (Section 14)
- Output paths: assertion-{task-id}.md and integration-F-{NNN}.md
- Added constraint: "verify against actual codebase, never trust evidence without checking"
- All existing tester capabilities preserved — Role, Process, Output Format, Constraints unchanged
- 107 lines — well under 120 target
- All 4 ACs verified PASS
- Epic 5 Story 3 of 4 complete

### Change Log

- 2026-02-18: Extended tester.md with SDD Assertion Execution and Integration Verification modes
- 2026-02-21: Story 6.x enhancements — **Trace** field added to test report header; **Upstream Trace** added to failure entries (Story 6.1).

### File List

- `.claude/agents/tester.md` (MODIFIED — 2 SDD mode sections added)
- `.claude/agents/tester.md` (MODIFIED 2026-02-21 — Trace field in header, Upstream Trace in failure entries)
