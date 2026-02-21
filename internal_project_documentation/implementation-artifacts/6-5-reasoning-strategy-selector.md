# Story 6.5: Reasoning Strategy Selector

Status: implemented

## Story

As the planner and architect agents,
I want explicit guidance on when to use Linear (Chain-of-Thought), Branching (Tree-of-Thought), and Graph reasoning strategies,
So that complex problems are approached with the appropriate reasoning mode rather than defaulting to sequential thinking.

Closes principle gap: **#14** (Chain-of-Thought vs Tree-of-Thought vs Graph Planning — reasoning strategy selector absent).

## Acceptance Criteria

1. planner.md contains a `## Reasoning Strategy Selection` section with a 3-row selection table before the SDD Spec Authoring section
2. architect.md contains a `## Reasoning Strategy Selection` section with a 3-row selection table before the Process section
3. The table maps problem signals to strategies: Linear (CoT) for clear single-path problems, Branching (ToT) for multi-option comparison, Graph for interdependent/cyclic constraint problems
4. Both sections default to Linear unless ambiguity signals are present (keywords: "evaluate", "compare", "trade-off", multiple valid architectures, conflicting constraints)
5. The instruction is lightweight guidance (<15 lines each), not a prescriptive decision tree

## Tasks / Subtasks

- [x] Task 1: Add Reasoning Strategy Selection to planner.md (AC: #1, #3, #4, #5)
  - [x] Add `## Reasoning Strategy Selection` section before `## SDD Spec Authoring`
  - [x] Define 3-strategy table: Linear | Branching | Graph with Signal and How-to-Apply columns
  - [x] Add default rule: Linear unless goal contains ambiguity signals
  - [x] Keep section to ~10 lines
- [x] Task 2: Add Reasoning Strategy Selection to architect.md (AC: #2, #3, #4, #5)
  - [x] Add `## Reasoning Strategy Selection` section before `## Process`
  - [x] Same 3-strategy table adapted for architectural decision context
  - [x] Same default rule: Linear unless task contains ambiguity signals
  - [x] Keep section to ~10 lines

## Dev Notes

### Design Rationale

Modern LLMs already possess CoT, ToT, and graph-based reasoning capabilities latently. The selector does not implement these capabilities — it makes the selection *explicit* rather than implicit. Without explicit guidance, LLMs default to sequential reasoning even for problems where branching exploration would produce better outcomes.

The table format provides a concrete lookup mechanism: the agent reads the signal column, matches to current problem, and selects the strategy. The default-to-Linear rule prevents analysis paralysis from the selector itself.

### Strategy descriptions in context

**Linear (CoT)** — for planner: sequential task decomposition where each step naturally follows the previous. For architect: single clear technology choice where trade-offs are well-understood.

**Branching (ToT)** — for planner: decomposing a feature that has 2-3 valid structural approaches (e.g., monolith vs. microservice split). For architect: selecting between competing patterns where pros/cons must be evaluated to depth.

**Graph** — for planner: features with circular task dependencies that must be resolved before DAG creation. For architect: systems with mutual constraints (e.g., performance ↔ consistency ↔ cost triangle).

### Uncertainty in effectiveness

LLM compliance with reasoning strategy instructions is probabilistic. The instruction may not reliably change reasoning behavior in all cases. This is explicitly a low-risk addition: if ignored, the agent defaults to its natural reasoning (usually Linear anyway). If followed, it produces better-structured output for complex problems.

### Files Changed

| File | Change |
|------|--------|
| `.claude/agents/planner.md` | New `## Reasoning Strategy Selection` section (+12 lines) |
| `.claude/agents/architect.md` | New `## Reasoning Strategy Selection` section (+12 lines) |

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.6 (facilitated by Claude Opus 4.6 brainstorming analysis)

### Completion Notes List

- Reasoning Strategy Selection section added to both planner.md and architect.md
- Identical 3-row table structure; context-specific "How to Apply" column wording per agent
- Default-to-Linear rule prevents analysis paralysis
- Section placed strategically: before SDD Spec Authoring in planner (reasoning before speccing), before Process in architect (reasoning before analysis)
- Gap #14 partially closed — explicit strategy selector implemented; ToT/Graph search algorithms (full gap) remain out of scope for markdown-first template

### Change Log

- 2026-02-21: Added Reasoning Strategy Selection sections to planner.md and architect.md

### File List

- `.claude/agents/planner.md` (MODIFIED — Reasoning Strategy Selection section added)
- `.claude/agents/architect.md` (MODIFIED — Reasoning Strategy Selection section added)
