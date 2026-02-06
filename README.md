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

## License

MIT
