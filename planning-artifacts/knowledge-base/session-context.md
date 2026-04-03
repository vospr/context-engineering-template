# Session Context — Compaction Log

Entries below are structured YAML summaries of compacted conversation turns.
Full turn history is available in git. Parse `component_type` to determine
compaction eligibility for future compaction cycles.

## Compaction Priority Order

Compress earlier-listed component_type entries first:
1. `history` — general conversation turns
2. `plan` — superseded planning entries
3. `review` — completed review cycles
4. `test` — passed test runs
5. `spec_packet` — **never compress** (pinned)
6. `failure_patterns` — **never compress** (pinned)

## Schema

Each compacted turn entry:

```yaml
- turn_id: "{UUID or sequential turn number}"
  timestamp: "YYYY-MM-DDTHH:MM:SSZ"
  agent: "researcher | planner | architect | implementer | reviewer | tester"
  task_id: "T-{NNN} | none"
  trace: "TRACE-{YYYY-MM-DD}-{HHmm}-{slug}"
  component_type: "spec_packet | plan | history | failure_patterns | review | test"
  status: "COMPLETED | NEEDS_CHANGES | BLOCKED"
  key_decisions:
    - "{decision 1 — max 80 chars}"
    - "{decision 2 — max 80 chars}"
    - "{decision 3 — max 80 chars}"
```

---

```yaml
[]
```
