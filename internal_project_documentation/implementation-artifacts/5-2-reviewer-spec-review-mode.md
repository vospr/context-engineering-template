# Story 5.2: Reviewer Spec Review Mode

Status: review

## Story

As a reviewer agent,
I want a spec review mode that validates spec quality alongside code quality,
so that I catch spec-level issues (vague assertions, missing observables, scope violations) during review.

## Acceptance Criteria

1. Reviewer validates assertion evidence matches actual code changes (file:line references are accurate)
2. Reviewer checks that all assertions use controlled vocabulary and name specific observables
3. Reviewer verifies file_scope was respected — no modifications outside listed files
4. Reviewer provides structured feedback per the existing reviewer protocol (STATUS: APPROVED | NEEDS_CHANGES | BLOCKED)

## Tasks / Subtasks

- [x] Task 1: Extend reviewer.md with SDD Spec Review Mode (AC: #1, #2, #3, #4)
  - [x] Add `spec-protocol` to the reviewer's skills list in frontmatter
  - [x] Add a new "## SDD Spec Review Mode" section after the existing Output Format section
  - [x] Document dual-mode operation: standard code review (existing) + spec review mode (new)
  - [x] Define when spec review mode activates: when the task has an embedded spec packet (delimiters present)
  - [x] Document the spec review checklist (see Task 2)
  - [x] State that spec review findings use the same STATUS/ISSUES/SEVERITY format — no new output format
- [x] Task 2: Define the Spec Review Checklist (AC: #1, #2, #3)
  - [x] Evidence accuracy: verify file:line references in assertion results point to actual code changes (Section 11)
  - [x] Controlled vocabulary: verify assertions use MUST/MUST NOT/SHOULD/MAY (Section 3)
  - [x] Observable specificity: verify assertions name specific observables, not vague terms (Section 4)
  - [x] File scope compliance: verify no files modified outside file_scope from spec packet
  - [x] Assertion completeness: verify every assertion ID has a PASS/FAIL result
  - [x] FAIL evidence: verify FAIL results include expected vs actual
  - [x] Map each check to its spec-protocol.md section reference
- [x] Task 3: Define spec-specific severity classification (AC: #4)
  - [x] CRITICAL: evidence references non-existent code (file:line doesn't match), assertion results fabricated
  - [x] MAJOR: file_scope violated, assertions missing controlled vocabulary, vague assertions without observables
  - [x] MINOR: SHOULD violations, advisory warnings, style issues in evidence reporting
  - [x] Integrate with existing severity definitions — spec severities augment, not replace
- [x] Task 4: Document integration with expanded lifecycle (AC: #1, #2, #3)
  - [x] Spec review maps to LINT_PASS → RATIFIED transition (Section 15) — reviewer approval gates RATIFIED
  - [x] Spec review also runs post-implementation at EXECUTING → VERIFIED — reviewer validates evidence against code
  - [x] Reference Section 14 Layer 2 (Agent Review) — this is the reviewer's role in the verification pipeline
  - [x] Reference Section 15 graduated escalation — reviewer findings feed escalation level
- [x] Task 5: Validate completeness (AC: #1-#4)
  - [x] Verify all 6 spec review checks documented with section references
  - [x] Verify spec-specific severity classification defined
  - [x] Verify existing reviewer capabilities preserved — spec review is additive
  - [x] Verify reviewer.md at 91 lines — well under 100 target
  - [x] Verify output format unchanged — same STATUS/ISSUES/SEVERITY structure

## Dev Notes

### Architecture Compliance

- **Source of truth:** `_bmad-output/planning-artifacts/architecture.md`
- **Line 46:** Tier 6 — "reviewer gains spec review mode"
- **Line 70:** Slice 4 — "agent extensions (planner/reviewer/tester modes)"
- **Line 438:** reviewer.md — "Code review + spec review (Slice 4: dual mode)"
- **Line 413:** Pattern enforcement — "Reviewer (agent): validates assertion evidence matches actual code changes"
- **Lines 545:** Slice 4 deliverables — modified planner.md, reviewer.md, tester.md
- **ADR-003 (lines 98-107):** Verification — reviewer confirms assertion results, Slice 3 adds two-layer

### Previous Story Intelligence (Stories 4.1, 4.2, 5.1)

- Section 3 defines controlled vocabulary (MUST/SHOULD/MAY/MUST NOT) — reviewer checks this
- Section 4 defines assertion quality gate and banned terms — reviewer checks this
- Section 11 defines evidence reporting format with file:line references — reviewer validates accuracy
- Section 14 defines Layer 2 (Agent Review) — reviewer is the agent in Layer 2
- Section 15 defines LINT_PASS → RATIFIED gate (reviewer approval) and EXECUTING → VERIFIED
- Current reviewer.md: 61 lines, skills: ["review-checklist", "architecture-principles"]

### What This Story Changes

| File | Change | Scope |
|------|--------|-------|
| `.claude/agents/reviewer.md` | Extended with SDD spec review mode | ~30-35 lines added |

### Critical Constraints

- Pure markdown only (NFR3)
- Edit `.claude/agents/reviewer.md` — do NOT create any new files
- Do NOT modify spec-protocol.md or CLAUDE.md
- Preserve ALL existing reviewer capabilities — spec review is additive
- Keep reviewer.md under 100 lines for token efficiency
- Reviewer remains read-only — no Edit, Write, or Bash tools
- Same output format (STATUS/ISSUES/SEVERITY) — no new feedback structure

### Project Structure Notes

- Target file: `.claude/agents/reviewer.md` (EDIT existing — extend with spec review mode)
- No other files should be created or modified

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Line 46 Agent Extensions]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 438 Reviewer Dual Mode]
- [Source: _bmad-output/planning-artifacts/architecture.md#Line 413 Pattern Enforcement]
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-003 Verification]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.2]
- [Source: _bmad-output/implementation-artifacts/5-1-planner-agent-spec-authoring-extension.md#Completion Notes]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

None — clean implementation.

### Completion Notes List

- Extended reviewer.md from 61 → 91 lines (+30 lines of SDD spec review capabilities)
- Added `spec-protocol` to skills frontmatter
- Dual-mode: spec review activates when `# --- SPEC ---` delimiters present in task
- Spec review checklist table: 6 checks with severity and section references (Sections 1, 3, 4, 11)
- Spec-specific severities: CRITICAL (fabricated evidence), MAJOR (scope/vocabulary/completeness), MINOR (SHOULD/style)
- Lifecycle integration: gates LINT_PASS → RATIFIED and EXECUTING → VERIFIED (Section 15)
- Escalation mapping: NEEDS_CHANGES → Orange, BLOCKED → Red (Section 15)
- Added constraint: "verify evidence against actual code, never trust self-reported results alone"
- All existing reviewer capabilities preserved — Role, Process, Feedback Format, Status/Severity unchanged
- 91 lines — well under 100 target
- All 4 ACs verified PASS
- Epic 5 Story 2 of 4 complete

### Change Log

- 2026-02-18: Extended reviewer.md with SDD Spec Review Mode
- 2026-02-21: Story 6.x enhancements — TRACE + UPSTREAM_TRACE fields added to mandatory feedback format (Story 6.1); New Failure Patterns output section added for CRITICAL issues (Story 6.2).

### File List

- `.claude/agents/reviewer.md` (MODIFIED — SDD Spec Review Mode section added)
- `.claude/agents/reviewer.md` (MODIFIED 2026-02-21 — TRACE/UPSTREAM_TRACE in feedback format, New Failure Patterns section)
