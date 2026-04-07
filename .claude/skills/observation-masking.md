# Observation Masking — Proactive Context Hygiene

Inspired by Atelier Pipeline ADR-0011. Reduces context usage by 40-60% through structured replacement of superseded tool outputs.

## When to Mask

Mask after EACH of these trigger points:
1. **After processing a subagent return** — the raw output is captured in an artifact file; mask the inline copy
2. **After a phase transition** — all previous phase tool outputs are stale
3. **Before dispatching a new subagent** — clean context for the next agent
4. **At cleanup threshold** — if estimated context > 60k tokens

## What to Mask (Always)

| Category | Example | Replacement |
|----------|---------|-------------|
| Superseded file reads | A file read 10 turns ago, re-read 2 turns ago | `[masked: Read {path}, {N} lines, turn {T}. Re-read if needed]` |
| Completed phase outputs | Planner output after implementer started | `[masked: planner artifact saved to {path}]` |
| Verbose bash output after verdict | Full test output after PASS recorded | `[masked: Bash {cmd}, {N} lines, turn {T}. PASS recorded]` |
| Git diff after review | Full diff output after reviewer processed it | `[masked: git diff, {N} lines. Review saved to {artifact_path}]` |
| Research agent summaries after consumption | Haiku scout results after main agent used them | `[masked: research summary consumed, {N} lines]` |

## Priority Rule

**Never-mask always wins.** If an item appears on both the "Always Mask" and "Never Mask" lists (e.g., a planner output that is both "completed phase output" and "most recent read per path"), keep it unmasked.

## What to NEVER Mask

These items must always remain in raw form:
- **Agent reasoning** — the actual analysis and decisions in agent outputs
- **Most recent file read per unique path** — always keep the latest version
- **Most recent Bash output per unique command** — always keep the latest
- **Most recent Grep result per unique query** — always keep the latest
- **Active BLOCKER/MUST-FIX references** — unresolved issues stay visible
- **pipeline-state.md content** — always current
- **session-context.md references** — compaction summaries stay
- **Failure pattern warnings** — injected patterns survive until session end

## Masking Placeholder Format

```
[masked: {tool_name} {target}, {line_count} lines, turn {turn_number}. Re-read: {recovery_hint}]
```

Examples:
- `[masked: Read src/auth/handler.ts, 245 lines, turn 12. Re-read: Read src/auth/handler.ts]`
- `[masked: Bash npm test, 89 lines, turn 8. PASS — re-run if needed]`
- `[masked: Agent implementer output, 340 lines, turn 15. Artifact: implementation-artifacts/2026-04-06-impl-T-003.md]`

## Integration with Compaction

Masking is **proactive** (before hitting limits). Compaction is **reactive** (at 80k).

Priority order:
1. Mask superseded observations (this skill) — target: stay under 60k
2. If still > 80k after masking: compact via CLAUDE.md Step 7

## Token Savings Estimate (Illustrative)

These figures are estimates based on typical session verbosity. Actual savings vary.

| Session Phase | Without Masking (est.) | With Masking (est.) | Savings (est.) |
|--------------|----------------------|--------------------|--------------------|
| After 3 tasks | ~40k tokens | ~18k tokens | ~55% |
| After 5 tasks | ~70k tokens | ~30k tokens | ~57% |
| After 8 tasks | ~110k (compaction triggered) | ~48k tokens | ~56% |

Expected result: 2-3x more tasks per session before hitting context limits.
