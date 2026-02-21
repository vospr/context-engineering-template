# Story 6.4: System Health Circuit Breakers

Status: implemented

## Story

As the main agent dispatch loop,
I want system-level health checks that detect pathological multi-agent interaction patterns,
So that cascade failures, infinite dispatch loops, and plan explosions are caught before wasting resources or corrupting state.

Closes principle gap: **#32** (Emergent Behaviors in Multi-Agent Systems — monitoring/audit framework).

## Acceptance Criteria

1. Every 10 completed tasks, the dispatch loop checks for cascade failure: if >3 tasks are simultaneously BLOCKED, dispatch pauses and user receives a summary before continuing
2. Every 10 completed tasks, the dispatch loop checks for dispatch loop detection: if the same task ID has been dispatched >5 times, it is marked BLOCKED and escalated to the user with full dispatch history
3. Every 10 completed tasks, the dispatch loop checks for plan explosion: if a single planning dispatch created >15 tasks, those tasks are flagged for user review before any are dispatched
4. Checks run using data already present in TaskList — no new state tracking infrastructure required

## Tasks / Subtasks

- [x] Task 1: Add System Health Checks to CLAUDE.md Quality Gates section (AC: #1, #2, #3, #4)
  - [x] Add `### System Health Checks (Every 10 Tasks)` subsection after Circuit Breaker
  - [x] Define cascade failure check: >3 tasks simultaneously BLOCKED → pause + user summary
  - [x] Define dispatch loop check: same task ID dispatched >5 times → BLOCKED + escalate with history
  - [x] Define plan explosion check: single planning dispatch created >15 tasks → flag for user review

## Dev Notes

### Design Rationale

All three checks can be evaluated from TaskList status alone, which the dispatch loop already reads at Step 1 of every cycle. No new state tracking is required:

- **Cascade failure**: `count(tasks where status=BLOCKED)` — trivially computable from TaskList
- **Dispatch loop**: dispatch count is visible in the artifact file trail — each dispatch creates an artifact named with the task ID; counting artifacts for a task ID gives the dispatch count
- **Plan explosion**: `count(tasks created by most recent planning dispatch)` — the planner writes a plan artifact listing all tasks created; the dispatch loop can check this count

The every-10-tasks cadence was chosen to balance overhead against detection latency. Cascade failure is the most critical (worst blast radius) and could be checked more frequently, but 10-task cadence is sufficient for human-in-the-loop sessions.

### Threshold rationale

| Check | Threshold | Rationale |
|-------|-----------|-----------|
| Cascade failure | >3 BLOCKED | A typical feature has 5-7 tasks; >3 blocked simultaneously suggests systemic spec or architectural failure |
| Dispatch loop | >5 dispatches | Max 3 review cycles per task (Pattern 2) + initial dispatch + 1 escalation = 5 legitimate dispatches max |
| Plan explosion | >15 tasks | Violates 7x7 constraint (7 tasks/feature max); >15 tasks from one planning run indicates scope creep |

### What the checks cannot do

These are instructional circuit breakers — the LLM reads the instruction and checks conditions. They are not runtime monitors with guaranteed execution. The checks depend on the LLM following the "every 10 tasks" cadence. This is a best-effort safety net, not a hard guarantee.

### Files Changed

| File | Change |
|------|--------|
| `CLAUDE.md` | Quality Gates: new `### System Health Checks` section (+6 lines) |

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (facilitated by Claude Opus 4.6 brainstorming analysis)

### Completion Notes List

- System Health Checks section added to Quality Gates in CLAUDE.md
- 3 checks: cascade failure, dispatch loop, plan explosion
- All checks use TaskList data already read at Step 1 — zero new infrastructure
- CLAUDE.md line count: 157 (well under 200-line constraint) after all Story 6.x changes
- Gap #32 partially closed — system-level circuit breakers implemented; dedicated monitoring/audit toolchain remains out of scope for markdown-first template

### Change Log

- 2026-02-21: Added System Health Checks section to CLAUDE.md Quality Gates

### File List

- `CLAUDE.md` (MODIFIED — System Health Checks section in Quality Gates)
