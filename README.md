# Claude Code Context Engineering Template

A lightweight, project-agnostic template that transforms Claude Code into a context-engineered multi-agent orchestration system.

## What Is This?

This template encodes **Context Engineering** — the discipline of controlling what enters an LLM's context, when, in what form, and what stays externalized. It turns Claude Code into a multi-agent system where:

- A **Main Agent** (CLAUDE.md) acts as a stateless dispatcher
- **Specialized subagents** handle research, planning, architecture, implementation, review, and testing
- **Skills** provide reusable knowledge modules that load into agent context on demand
- **Files** serve as externalized memory that survives context compaction
- **Git** provides fault tolerance and lineage tracking

## Quick Start

### 1. Copy template files to your project
```bash
cp -r CLAUDE.md .claude/ .gitignore your-project/
```

### 2. Customize placeholder skills
Edit the `[PLACEHOLDER]` files in `.claude/skills/` for your stack:
- `coding-standards.md` — your language, framework, linter, patterns
- `review-checklist.md` — your test/lint commands, quality bar
- `testing-strategy.md` — your test framework, commands, coverage targets
- `architecture-principles.md` — your system type, constraints, design principles

`git-workflow.md` is universal and works as-is.

### 3. Start Claude Code
```bash
claude
```
The Main Agent reads CLAUDE.md automatically and begins the dispatch loop.

## Architecture

```
┌─────────────────────────────────────────────┐
│  User                                        │
│  "Build a REST API for task management"      │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Main Agent (CLAUDE.md) — Stateless Kernel   │
│  read → match agent → dispatch → read result │
│  Token budget: <128k  │  Compact at 80k      │
└──┬────┬────┬────┬────┬────┬─────────────────┘
   │    │    │    │    │    │
   ▼    ▼    ▼    ▼    ▼    ▼
 [R]  [P]  [A]  [I]  [Rev] [T]
  │    │    │    │    │     │
  ▼    ▼    ▼    ▼    ▼     ▼
 Files: planning-artifacts/ + implementation-artifacts/
                   │
                   ▼
              Git (lineage + recovery)
```

**[R]**esearcher · **[P]**lanner · **[A]**rchitect · **[I]**mplementer · **[Rev]**iewer · **[T]**ester

## How It Works

### The Dispatch Loop (CLAUDE.md)
1. **Read** TaskList → find pending, unblocked tasks
2. **Match** task to agent by description
3. **Classify** complexity → select model (haiku/sonnet/opus)
4. **Dispatch** via Task tool with relevant file paths
5. **Read** result from artifacts folder
6. **Update** task status
7. **Repeat** — every 5 tasks, check token usage and compact if needed

### Communication Patterns
| Pattern | When | How |
|---------|------|-----|
| One-Shot | Default | Single agent completes task independently |
| Worker-Reviewer | Implementation | Implementer ↔ Reviewer loop, max 3 cycles |
| Parallel Fan-Out | Multi-perspective | N agents run simultaneously on non-overlapping files |

### Token Budget
- Main Agent target: **<128k tokens** from project start to finish
- Proactive compaction at **80k** every 5 tasks
- All decisions written to files immediately (survive compaction)
- Model economics: sonnet default, opus for architecture only, haiku for research

## Adding Agents

Drop a new `.md` file in `.claude/agents/` following `_agent-template.md`. The Main Agent discovers agents by reading the directory — no configuration changes needed.

## Project Structure

```
CLAUDE.md                              # Main Agent dispatch kernel (~150 lines)
.claude/
  agents/                              # Subagent definitions
    _agent-template.md                 # Convention template
    researcher.md                      # Web research (haiku)
    planner.md                         # Task DAG creation (sonnet)
    architect.md                       # System design (opus)
    implementer.md                     # Code writing (sonnet)
    reviewer.md                        # Code review (sonnet, read-only)
    tester.md                          # Test execution (sonnet)
  skills/                              # Reusable knowledge modules
    git-workflow.md                    # Universal git conventions
    coding-standards.md                # [PLACEHOLDER] language/framework
    review-checklist.md                # [PLACEHOLDER] review criteria
    testing-strategy.md                # [PLACEHOLDER] test framework
    architecture-principles.md         # [PLACEHOLDER] design constraints
  settings.json                        # Hooks for secret detection
.gitignore                             # Security defaults
planning-artifacts/                    # Created at runtime
implementation-artifacts/              # Created at runtime
```

## Design Principles

1. **Stateless Dispatcher** — Main Agent holds no project state; reads from files each cycle
2. **Delegated Mechanism Selection** — Subagents choose their own tools, not the dispatcher
3. **File System as Memory** — Unlimited, persistent, survives context compaction
4. **Git as Lineage** — Every state is recoverable; micro-commits as checkpoints
5. **Graduated Context Loading** — CLAUDE.md (kernel) + skills (per-agent) + files (on-demand)
6. **Self-Discovering Agent Pool** — Directory IS the registry; scales without config changes

## Context Engineering Framework

This template implements six operational principles derived from context engineering research:

### 1. Context Offloading
Project state persists in files outside the context window — `planning-artifacts/`, `implementation-artifacts/`, and a decisions log. Git micro-commits act as checkpoints and provide recoverable lineage.

### 2. Context Retrieval
The Main Agent reads only what it needs: TaskList + latest artifacts. Agents load skills on demand via `setting_sources` and `skills` fields. New agents add themselves by dropping a file in `.claude/agents/` — no configuration changes required.

### 3. Context Reduction
A <128k token budget keeps the Main Agent compact across entire projects. Complexity classification routes simple lookups to haiku and reserves expensive models for architecture decisions. Task decomposition caps each unit at 3-5 files. Proactive compaction at 80k summarizes older turns.

### 4. Context Isolation
Six specialized agents run in separate contexts with only the tools they need. Parallel fan-out dispatches multiple agents on non-overlapping files. All implementation stays on feature branches, never main.

### 5. Context Orchestration
One universal dispatch pattern governs every project stage: read → match agent → classify complexity → dispatch → process result → repeat. Three communication modes handle different scenarios (one-shot, worker-reviewer loop, parallel fan-out).

### 6. Context Governance
Reviewers follow a structured protocol: STATUS codes, numbered issues with severity ratings, and specific fix guidance for every finding. Circuit breaker caps worker-reviewer iterations at three cycles. Secret leak prevention operates in three layers: file exclusion, agent constraints, and automated hooks.

## Architectural Decisions Stress-Tested

The template was designed through three brainstorming techniques:

- **First Principles Thinking** — 15 core axioms derived from context window economics and token budgets
- **Morphological Analysis** — 12 design dimensions mapping the full parameter space under 128k constraint
- **Chaos Engineering** — 23 failure scenarios stress-tested with concrete fixes for each

Key resilience patterns:

| Failure Mode | Fix |
|--------------|-----|
| Context overflow | Proactive compaction at 80k, every 5 tasks |
| Infinite review loops | Circuit breaker: max 3 cycles → blocked status |
| Parallel file conflicts | Dependency analysis + git branch isolation |
| MCP server failures | Fallback chain: MCP → CLI → built-in → report blocked |
| Session death mid-project | Stateless dispatch + files = full resumability |
| Secret leaks | Three-layer defense: .gitignore + agent rules + hooks |

## Why This Matters

AI coding assistants write functions and refactor modules, but building complete features across sessions requires more than capability — it requires structured context. Context engineering addresses the gap. As Claude Code, OpenAI Codex, Cursor and Windsurf converge on multi-agent orchestration, this template provides a proven pattern for:

- Coordinating specialized agents without context drift
- Managing token budgets across multi-day projects
- Recovering instantly from failures via git lineage
- Scaling from 6 to unlimited agents without architecture changes

## Resources

- **Gartner (July 2025):** "Context engineering is in, and prompt engineering is out"
- **Philipp Schmid (June 30, 2025):** "The discipline of designing and building dynamic systems that provide the right information and tools, in the right format, at the right time"
- **Anthropic:** Effective context engineering for AI agents — official framework and principles
- **Model Context Protocol:** Universal standard for connecting agents to enterprise tools (97M+ monthly SDK downloads)

## License

MIT
