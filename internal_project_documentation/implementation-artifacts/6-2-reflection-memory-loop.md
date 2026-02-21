# Story 6.2: Reflection Memory Loop

Status: implemented

## Story

As the planner agent and dispatch loop,
I want failure-patterns.md to be mandatorily consulted before speccing and automatically updated after CRITICAL reviews,
So that the system learns from past failures without requiring manual curation.

Closes principle gap: **#29** (Memory Structure for Reflection and Self-Improvement).

## Acceptance Criteria

1. The planner's Pre-Spec Checks mandate searching `failure-patterns.md` for domain matches — this is no longer advisory
2. For each matching failure pattern found, the planner MUST either (a) add a spec constraint preventing recurrence, or (b) explicitly document in the spec overview why the pattern does not apply
3. When a review results in NEEDS_CHANGES or BLOCKED with at least one CRITICAL issue, the reviewer outputs a `## New Failure Patterns` section in the review artifact
4. The `## New Failure Patterns` section follows a structured format: Pattern name, Trigger, Prevention, Task Ref
5. The dispatch loop (Step 6) reads the `## New Failure Patterns` section from reviewer output and appends entries to `planning-artifacts/knowledge-base/failure-patterns.md`
6. The reviewer remains read-only — file writing is handled exclusively by the dispatch loop

## Tasks / Subtasks

- [x] Task 1: Strengthen planner Pre-Spec Checks to mandatory (AC: #1, #2)
  - [x] In planner.md `### Pre-Spec Checks`, replace: "check for known patterns in the feature's domain" with:
    "search it for patterns matching the feature's domain (file paths, component names, error categories). For each matching pattern: either (a) add a spec constraint preventing the known failure mode, or (b) document in the spec overview why the pattern does not apply. This check is **MANDATORY**, not advisory."
- [x] Task 2: Add New Failure Patterns output section to reviewer.md (AC: #3, #4)
  - [x] Add `## New Failure Patterns` section documentation after the Output Format section
  - [x] Define trigger condition: STATUS is NEEDS_CHANGES or BLOCKED AND at least one CRITICAL issue
  - [x] Define structured format: Pattern, Trigger, Prevention, Task Ref fields
  - [x] State that section is omitted entirely when no CRITICAL issues
  - [x] State that dispatch loop reads and appends this section — reviewer does NOT write to failure-patterns.md
- [x] Task 3: Add failure pattern append handler to CLAUDE.md Step 6 (AC: #5, #6)
  - [x] Add: "If reviewer output contains `## New Failure Patterns` section → append entries to `planning-artifacts/knowledge-base/failure-patterns.md`"

## Dev Notes

### Design Rationale

The failure-patterns.md file already exists (created in Story 4.3) as part of the constitution/governance system. The gap was that:
1. The planner's consultation was passive ("check for") rather than action-forcing ("must add constraint or explain why not")
2. There was no automated path from a new failure back into failure-patterns.md

This fix closes the loop: reviewer captures → dispatch loop persists → planner mandatorily consults.

### Reviewer read-only boundary preservation

The reviewer has `disallowedTools: ["Edit", "Write", ...]` by design. The fix routes the file-write through the dispatch loop (which has no such restriction), preserving the reviewer's read-only contract while enabling the feedback loop.

### Failure-patterns.md may not exist

If `planning-artifacts/knowledge-base/failure-patterns.md` does not exist (pre-Slice 3 projects), the planner Pre-Spec Check is still valid — the conditional already guards on file existence. The reviewer capture and dispatch loop append both no-op gracefully when the file is absent.

### Files Changed

| File | Change |
|------|--------|
| `.claude/agents/planner.md` | Pre-Spec Checks: mandatory consultation language (+2 lines replacing 1) |
| `.claude/agents/reviewer.md` | New `## New Failure Patterns` section (+16 lines) |
| `CLAUDE.md` | Step 6: +1 line (failure pattern append handler) |

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (facilitated by Claude Opus 4.6 brainstorming analysis)

### Completion Notes List

- Planner consultation changed from passive to MANDATORY — "This check is MANDATORY, not advisory"
- Reviewer New Failure Patterns section: triggers on CRITICAL, structured 4-field format
- Dispatch loop handler: 1-line addition to Step 6, consistent with existing flag-based routing pattern (ARCHITECTURE_IMPACT, NEEDS_RESPEC)
- Reviewer read-only boundary fully preserved
- failure-patterns.md growth risk noted: periodic human curation recommended (consistent with human-in-the-loop philosophy)
- Gap #29 partially closed — the remaining gap (automated prompt updates from patterns) remains out of scope for markdown-first template

### Change Log

- 2026-02-21: Implemented reflection memory loop — mandatory planner consultation, reviewer capture, dispatch loop append

### File List

- `.claude/agents/planner.md` (MODIFIED — Pre-Spec Checks strengthened to mandatory)
- `.claude/agents/reviewer.md` (MODIFIED — New Failure Patterns section added)
- `CLAUDE.md` (MODIFIED — Step 6 failure pattern append handler)
