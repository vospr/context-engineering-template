# Planning Artifacts Directory

Runtime output from planning-phase agents (researcher, planner, architect).
Files are created during project execution — not checked into the template.

## File Types
- `YYYY-MM-DD-research-{topic}.md` — Research reports (researcher agent)
- `YYYY-MM-DD-plan-{feature}.md` — Task DAGs and plans (planner agent)
- `YYYY-MM-DD-adr-{topic}.md` — Architecture Decision Records (architect agent)
- `YYYY-MM-DD-arch-{component}.md` — Component architecture docs

## State Files
- `project-status.md` — Current phase, milestones, blockers
- `session-context.md` — Token compaction summaries
- `mcp-health.md` — MCP server availability
- `decisions.md` — All architectural/technology decisions log

## Subdirectories
- `knowledge-base/` — Curated, persistent topic files for RAG (checked in)

## RAG Note
Researcher agent checks this directory FIRST before web search.
Research reports < 7 days old are reused to save tokens.
