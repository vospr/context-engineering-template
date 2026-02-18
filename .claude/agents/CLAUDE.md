# Agents Directory

Specialized subagent definitions for the multi-agent orchestration framework.
Each `.md` file defines one agent with frontmatter (name, tools, model) and behavioral instructions.

## Agent Inventory
| Agent | Model | Role |
|-------|-------|------|
| researcher | haiku | Web/local research, technology evaluation, Context7 library docs |
| planner | sonnet | Task DAG creation, dependency analysis, project planning |
| architect | opus | System design, ADRs, technology selection |
| implementer | sonnet | Code writing, file editing, test writing, micro-commits |
| reviewer | sonnet | Code review, quality checks, structured feedback |
| tester | sonnet | Test execution, validation, bug reports |

## Key Patterns
- `_agent-template.md` — Copy this to create new agents
- Agents write artifacts to `planning-artifacts/` or `implementation-artifacts/`
- Researcher checks local sources (artifacts, knowledge-base, Context7) before web search
