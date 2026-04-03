# Pipeline State — Recovery Cache

This file is a **fast recovery cache** (ADR-004), NOT the sole source of truth.
If missing or stale (>1 hour), derive state from TaskList + git log + session-context.md.

```yaml
phase: idle
last_step: none
current_task_id: none
branch: main
timestamp: 2026-04-03T00:00:00Z
last_agent: none
blocked_tasks: []
pipeline_tier: none
```

## Schema

| Field | Type | Description |
|-------|------|-------------|
| `phase` | string | Current pipeline phase: `idle`, `planning`, `implementing`, `reviewing`, `testing`, `shipping` |
| `last_step` | string | Last completed dispatch loop step (e.g., `Step 5 - dispatch`) |
| `current_task_id` | string | Active task ID (e.g., `T-001`) or `none` |
| `branch` | string | Current working branch |
| `timestamp` | ISO 8601 | Last update time — used for 1hr TTL cache invalidation |
| `last_agent` | string | Last dispatched agent type |
| `blocked_tasks` | list | Task IDs currently blocked with reasons |
| `pipeline_tier` | string | Current pipeline tier: `Micro`, `Small`, `Medium`, `Large`, or `none` |

## TTL Rule

- If `timestamp` is < 1 hour old → use cached state
- If `timestamp` is > 1 hour old OR file missing → derive from TaskList + git log + session-context.md, then overwrite this file
