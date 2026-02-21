# Story 6.1: Cross-Agent Trace ID Convention

Status: implemented

## Story

As the main agent and all subagents,
I want a Trace ID generated at dispatch time and propagated through every artifact,
So that cross-agent failures can be diagnosed by grepping a single ID across all artifact files.

Closes principle gaps: **#9** (Safe and Debuggable Agent Loop) and **#33** (Debugging Failures Across Interacting Agents).

## Acceptance Criteria

1. Every dispatch in Step 5 of CLAUDE.md generates a `TRACE-{YYYY-MM-DD}-{HHmm}-{3-word-slug}` ID (e.g., `TRACE-2026-02-21-1430-add-auth-endpoint`)
2. The Trace ID is passed to the dispatched agent as part of task context
3. Every agent artifact header includes a `**Trace:**` field populated with the received Trace ID
4. Reviewer feedback format includes `TRACE:` line at the top of every review
5. Every CRITICAL issue in a review includes `UPSTREAM_TRACE:` pointing to the artifact that introduced the defect
6. Tester report headers include `**Trace:**`; every test failure includes `**Upstream Trace:**`
7. Timeline reconstruction requires no tooling: `grep -r "TRACE-..." *-artifacts/` returns a complete ordered timeline

## Tasks / Subtasks

- [x] Task 1: Add Trace ID generation to CLAUDE.md Step 5 (AC: #1, #2)
  - [x] Add line before "Use Task tool": "Generate Trace ID: `TRACE-{YYYY-MM-DD}-{HHmm}-{3-word-slug}`"
  - [x] Add "Pass: task description + relevant artifact file paths + Trace ID" to dispatch instruction
- [x] Task 2: Add **Trace** field to _agent-template.md Output Format (AC: #3)
  - [x] Add `**Trace**: {trace_id from dispatch context}` as first field in the "Include at minimum" list
- [x] Task 3: Add **Trace** to implementer, planner, architect artifact templates (AC: #3)
  - [x] implementer.md: `**Trace:** {trace_id from dispatch context}` after **Date** in template
  - [x] planner.md: `**Trace:** {trace_id from dispatch context}` after **Date** in template
  - [x] architect.md: `**Trace:** {trace_id from dispatch context}` after **Date** in template
- [x] Task 4: Add TRACE + UPSTREAM_TRACE to reviewer.md feedback format (AC: #4, #5)
  - [x] Add `TRACE: {trace_id from dispatch context}` as first line of feedback format block
  - [x] Add `UPSTREAM_TRACE: {artifact file that introduced the defect}` under every [CRITICAL] issue entry
- [x] Task 5: Add Trace + Upstream Trace to tester.md output format (AC: #6)
  - [x] Add `**Trace:** {trace_id from dispatch context}` after **Date** in report header template
  - [x] Add `**Upstream Trace:** {implementation artifact that introduced this failure}` to failure entry template

## Dev Notes

### Design Rationale

Trace IDs piggyback on the existing file-based artifact system. Because all artifact files are already date-prefixed and stored in flat `planning-artifacts/` and `implementation-artifacts/` directories, a grep across both directories with a single Trace ID reconstructs the complete execution timeline in chronological order.

The 3-word-slug component makes IDs human-readable in log output without requiring a lookup table. The format is LLM-generatable without tooling — identical to how the LLM already generates dates, task IDs, and commit messages.

### UPSTREAM_TRACE vs TRACE

- **TRACE** on every artifact: the ID of the *current* dispatch — links this artifact to its dispatch context
- **UPSTREAM_TRACE** on CRITICAL issues only: the *other* artifact that introduced the defect — enables causal chain tracing across agents

### Compliance with CLAUDE.md 200-line constraint

CLAUDE.md was at 150 lines before this story. The Trace ID addition added 1 line to Step 5. Total after all Story 6.x changes: 157 lines.

### Files Changed

| File | Change |
|------|--------|
| `CLAUDE.md` | Step 5: +2 lines (Trace ID generation + pass instruction) |
| `.claude/agents/_agent-template.md` | Output Format: +1 line (**Trace** field) |
| `.claude/agents/implementer.md` | Artifact template: +1 line (**Trace** field) |
| `.claude/agents/planner.md` | Artifact template: +1 line (**Trace** field) |
| `.claude/agents/architect.md` | Artifact template: +1 line (**Trace** field) |
| `.claude/agents/reviewer.md` | Feedback format: +2 lines (TRACE, UPSTREAM_TRACE) |
| `.claude/agents/tester.md` | Report template: +2 lines (**Trace**, **Upstream Trace**) |

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (facilitated by Claude Opus 4.6 brainstorming analysis)

### Completion Notes List

- All 7 files modified; zero new files created
- CLAUDE.md remains at 157 lines (well under 200-line constraint)
- No runtime infrastructure introduced — pure markdown convention
- Trace ID is LLM-generated at dispatch time; no external ID service needed
- Reviewer stays read-only (no new tools required)
- Gap #9 and #33 addressed simultaneously with a single shared convention
- Backward compatible: agents without a Trace ID in dispatch context simply omit the field

### Change Log

- 2026-02-21: Implemented cross-agent Trace ID convention across all 7 agent/template files

### File List

- `CLAUDE.md` (MODIFIED — Step 5 Trace ID generation)
- `.claude/agents/_agent-template.md` (MODIFIED — Trace field in Output Format)
- `.claude/agents/implementer.md` (MODIFIED — Trace field in artifact template)
- `.claude/agents/planner.md` (MODIFIED — Trace field in artifact template)
- `.claude/agents/architect.md` (MODIFIED — Trace field in artifact template)
- `.claude/agents/reviewer.md` (MODIFIED — TRACE + UPSTREAM_TRACE in feedback format)
- `.claude/agents/tester.md` (MODIFIED — Trace + Upstream Trace in report template)
