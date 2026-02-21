# Story 6.3: Complexity Escalation Protocol

Status: implemented

## Story

As the implementer agent and dispatch loop,
I want a structured escalation path when a task's actual complexity exceeds its classification,
So that the system re-routes instead of forcing bad implementations or producing silent failures.

Closes principle gap: **#16** (Reactive vs Deliberative Reasoning Architecture — dynamic switching heuristics).

## Acceptance Criteria

1. If an implementer discovers a task is significantly more complex than classified (e.g., SIMPLE task requires cross-cutting changes across >5 files, or hidden dependency cycles), it STOPS and reports ESCALATED status
2. The ESCALATED report is a partial implementation note containing: Original Classification, Discovered Complexity, and Recommendation (RESPEC | SPLIT | ARCHITECT_REVIEW)
3. The task is set to BLOCKED with reason: `Complexity escalation — {one-line summary}`
4. The dispatch loop re-classifies the task (Step 4) and re-dispatches based on the Recommendation
5. A task may only be escalated once — if already escalated, the implementer proceeds with best effort and flags remaining concerns as MAJOR issues

## Tasks / Subtasks

- [x] Task 1: Add Complexity Escalation Protocol section to implementer.md (AC: #1, #2, #3, #5)
  - [x] Add new `## Complexity Escalation Protocol` section before the Constraints section
  - [x] Define trigger: "significantly more complex than its classification" with concrete examples
  - [x] Define 3-step process: STOP → write ESCALATED partial note → set BLOCKED with reason
  - [x] Define ESCALATED note structure: Original Classification, Discovered Complexity, Recommendation fields
  - [x] Define Recommendation values: RESPEC | SPLIT | ARCHITECT_REVIEW
  - [x] Add guard clause: if already escalated once, proceed with best effort + MAJOR flags (prevents infinite escalation)
- [x] Task 2: Add ESCALATED handler to CLAUDE.md Step 6 (AC: #4)
  - [x] Add: "If ESCALATED flag in result → re-classify task complexity (Step 4) and re-dispatch; max 1 escalation per task"

## Dev Notes

### Design Rationale

The original dispatch loop had two implicit escalation paths but no formal protocol:
- ARCHITECTURE_IMPACT: dispatches planner to rebuild DAG
- NEEDS_RESPEC: dispatches planner to re-spec affected subtree

The ESCALATED flag follows the same flag-based routing pattern. The implementer sets the flag in the BLOCKED reason, and the dispatch loop reacts deterministically.

The guard clause (max 1 escalation per task) prevents infinite loops where the re-classified task is still mis-classified. After one escalation cycle, the implementer must proceed — this mirrors the 3-cycle circuit breaker in the worker-reviewer pattern.

### What "significantly more complex" means

Guidance in the implementer section uses two concrete triggers:
- >5 files required (violates the 5-file task constraint)
- Hidden dependency cycles (task cannot be completed without first completing another task not in DEPENDS_ON)

These are observable conditions, not subjective assessments.

### Recommendation routing

| Recommendation | Dispatch Target | Outcome |
|----------------|----------------|---------|
| RESPEC | Planner | Re-authors spec with expanded scope |
| SPLIT | Planner | Decomposes task into 2-3 smaller tasks |
| ARCHITECT_REVIEW | Architect | Architectural assessment before re-spec |

### Files Changed

| File | Change |
|------|--------|
| `.claude/agents/implementer.md` | New `## Complexity Escalation Protocol` section (+15 lines) |
| `CLAUDE.md` | Step 6: +1 line (ESCALATED handler) |

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (facilitated by Claude Opus 4.6 brainstorming analysis)

### Completion Notes List

- Complexity Escalation Protocol section added before Constraints in implementer.md
- 3-step process: STOP → ESCALATED partial note → BLOCKED
- Guard clause prevents infinite escalation loops (max 1 per task)
- ESCALATED handler in CLAUDE.md Step 6 — consistent pattern with ARCHITECTURE_IMPACT and NEEDS_RESPEC
- Uses existing BLOCKED mechanism + existing TaskUpdate capability — no new tools needed
- Gap #16 partially closed — dynamic switching at discovery time is now formalized; the remaining gap (automated mid-execution reclassification without human review) remains out of scope

### Change Log

- 2026-02-21: Implemented complexity escalation protocol in implementer.md and CLAUDE.md Step 6

### File List

- `.claude/agents/implementer.md` (MODIFIED — Complexity Escalation Protocol section added)
- `CLAUDE.md` (MODIFIED — Step 6 ESCALATED flag handler)
