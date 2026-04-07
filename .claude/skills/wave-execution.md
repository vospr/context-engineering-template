# Wave-Based Execution (ADR-002)

Waves group related tasks for batch execution and single-commit delivery. This reduces commit noise and agent invocations vs. per-task commits.

## When to Use Waves

| Pipeline Tier | Commit Strategy | Wave Grouping |
|---------------|----------------|---------------|
| **Micro** | Single commit (no wave) | N/A |
| **Small** | Single commit (no wave) | N/A |
| **Medium** | Wave commits | Planner groups related tasks using judgment |
| **Large** | Wave commits | Each ADR step = one wave |

## Wave Invariants (MUST NOT violate)

1. **No intra-wave dependencies** — Tasks within a wave MUST NOT depend on each other's output. If Task B needs Task A's result, they go in separate waves.
2. **No intra-wave file overlap** — Tasks within a wave MUST NOT modify the same files. If two tasks touch the same file, they go in separate waves.

## Wave Metadata Schema

The planner creates wave metadata when grouping tasks:

```yaml
waves:
  - wave_id: "W-1"
    wave_tasks: ["T-001", "T-002", "T-003"]
    wave_commit_message: "[W-1] {imperative description of wave changes}"
    independence_verified: true
    file_overlap_verified: true

  - wave_id: "W-2"
    wave_tasks: ["T-004", "T-005"]
    wave_commit_message: "[W-2] {imperative description of wave changes}"
    independence_verified: true
    file_overlap_verified: true
```

## Wave Execution Flow

For each wave:
1. **Implementer** executes all tasks in the wave (order within wave is flexible since tasks are independent)
2. **Reviewer** reviews the cumulative wave diff
3. **Blind Reviewer** (Medium/Large) reviews wave diff in parallel
4. If NEEDS_CHANGES → implementer fixes within same wave, re-review
5. **Tester** validates wave acceptance criteria
6. If all pass → single commit with wave commit message: `[W-{id}] {description}`
7. Proceed to next wave

## Commit Message Format

- Wave commits: `[W-{id}] {imperative} {what-changed}`
- Micro/Small (non-wave): `[T-{id}] {imperative} {what-changed}`

## File-Dependency Analysis (Automated Wave Extraction)

Before grouping tasks into waves, the planner MUST perform file-dependency analysis:

### Step 1: Build File-Touch Map
For each task, list all files it will create or modify:
```yaml
task_files:
  T-001: [src/auth/handler.ts, src/auth/types.ts]
  T-002: [src/db/schema.sql, src/db/migrations/001.sql]
  T-003: [src/auth/handler.ts, src/auth/middleware.ts]  # overlaps T-001!
  T-004: [src/api/routes.ts]
  T-005: [tests/auth.test.ts]
```

### Step 2: Detect Overlap
Build overlap matrix — any shared file = dependency:
- T-001 ↔ T-003: OVERLAP (src/auth/handler.ts) → same wave FORBIDDEN
- T-001 ↔ T-002: no overlap → can be in same wave
- T-002 ↔ T-004: no overlap → can be in same wave

### Step 3: Group into Waves
Apply greedy coloring: tasks with zero file overlap go in the same wave.
Check ALL N*(N-1)/2 pairwise combinations per wave:
```
Wave 1 candidates: [T-001, T-002, T-004]
  Check T-001 ↔ T-002: no overlap ✓
  Check T-001 ↔ T-004: no overlap ✓
  Check T-002 ↔ T-004: no overlap ✓
  → All 3 pairs clean → Wave 1 confirmed

Wave 2: [T-003, T-005]
  T-003 overlaps T-001 (Wave 1) → must be later wave
  Check T-003 ↔ T-005: no overlap ✓
  → Wave 2 confirmed
```

### Step 4: Validate Wave Invariants
For each wave, verify:
- [ ] No intra-wave file overlap (Step 2 matrix confirms)
- [ ] No intra-wave data dependencies (task outputs don't feed other wave tasks)
- [ ] Wave order respects cross-wave dependencies

## Parallel Execution (When Available)

If Agent tool supports parallel dispatch:
- Tasks within a wave can be dispatched simultaneously (run_in_background: true)
- Each task gets its own agent instance
- Merge order after wave completion: sequential by task ID
- On partial wave failure: successful tasks' results kept, failed task retried sequentially

## Planner Responsibilities

When creating task plans for Medium/Large features:
1. Build file-touch map for all tasks (Step 1 above)
2. Run file-dependency analysis to detect overlaps (Step 2)
3. Group independent, non-overlapping tasks into waves (Step 3)
4. Validate wave invariants (Step 4)
5. Generate wave metadata with verified invariants
6. Order waves by dependency (earlier waves complete before later ones start)
