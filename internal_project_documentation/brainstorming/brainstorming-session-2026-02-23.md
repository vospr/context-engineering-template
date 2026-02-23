---
stepsCompleted: [1, 2, 3, 4]
inputDocuments:
  - context-engineering-template/.claude/skills/coding-standards.md
  - stories/matlab-coding-standards.md
  - stories/matlab-performance-optimization.md
  - stories/live-script-generation.md
  - stories/MATLAB-Coding-Guidelines-1.0.0/
session_topic: 'Dynamic AI code-quality enforcement with flexible coding standards registry integrated into Ralph loop'
session_goals: 'Design a system where the main agent detects project stack, loads rules from configurable external sources (e.g. awesome-cursorrules), produces stable artifacts, and enforces standards throughout the Ralph autonomous loop'
selected_approach: 'ai-recommended'
techniques_used: ['question-storming', 'cross-pollination', 'scamper']
ideas_generated: [27]
workflow_completed: true
session_active: false
---

# Brainstorming Session Results

**Facilitator:** Andrey
**Date:** 2026-02-23

## Session Overview

**Topic:** Dynamic AI code-quality enforcement with flexible coding standards registry integrated into Ralph loop
**Goals:** Design a system where the main agent detects project stack, loads rules from configurable external sources (e.g. awesome-cursorrules), produces stable artifacts, and enforces standards throughout the Ralph autonomous loop

### Techniques Used
- **Phase 1:** Question Storming (32 questions across 5 clusters)
- **Phase 2:** Cross-Pollination (ideas from cursorrules community, agent memory patterns, versioning systems)
- **Phase 3:** SCAMPER (applied to both coding-standards.md and Ralph integration points)

---

## Technique Execution Results

### Phase 1 — Question Storming: Key Questions Generated

**Cluster A — What does "quality" mean for AI-generated code?**
- What failure mode are we afraid of — wrong logic, inconsistent style, security holes, or unmaintainable structure?
- Who judges quality — reviewer agent, human PR reader, CI pipeline, or future maintainers?
- Is "quality" the same across all agents, or does implementer need different rules than planner?
- What does "AI ignoring standards" actually look like — hallucinated conventions, training defaults, or rules not in context?

**Cluster B — What are the real injection points?**
- At what moment in the Ralph loop does the AI "decide" how to write code?
- What context does Ralph actually see — full CLAUDE.md? Skill file? Something else?
- Is the standard applied before generation (constraints in prompt) or after (reviewer catches violations)?
- What happens when coding standards conflict with getting the task done — which wins?

**Cluster C — What can we steal from awesome-cursorrules?**
- Why do `.cursorrules` files work — is it proximity to task, format, or repetition?
- What's the difference between a rule an AI *understands* and one it *follows*?
- Which patterns are language-agnostic and transferable to any stack?
- Could we version-control standards the same way we version-control code?

**Cluster D — Ralph loop-specific questions**
- Does Ralph re-read coding standards on every iteration, or only once at startup?
- What happens to standards when Ralph compacts context — do they survive?
- What would "standards drift" look like after 50 Ralph iterations — and how would you detect it?

**Cluster E — Dynamic loading questions**
- What triggers language/project-type detection?
- Should detection happen once per session, per task, or per loop iteration?
- What if a project is polyglot — does it load multiple rule sets simultaneously?
- Who owns the sources registry — repo config, user-level config, or Beads database?
- When a remote source changes upstream, do you want auto-update or pinned versions?

---

## Idea Organization and Prioritization

### Theme 1: Standards Registry & Configuration
*The single file you edit to control all sources*

| # | Idea | Core Insight |
|---|------|-------------|
| #2 | **Sources Registry File** (`coding-standards-sources.yaml`) | Central control point — one file controls all sources |
| #8 | **Minimal Registry Format** (language → url/local + priority) | Add a new language in 3 lines |
| #12 | **Registry-as-Code** — diff-able git history | Standards governance via PRs, not tribal knowledge |
| #25 | **Section Filtering** (`include_sections:`) | Use only the React rules, skip Next.js |
| #26 | **Source Trust Levels** (community / verified / override) | CRITICAL violations only fire from trusted sources |
| #11 | **Local Override Layer** (`.claude/skills/overrides/{lang}.md`) | Local always wins, but only by explicit intent |

**Sample registry format:**
```yaml
# coding-standards-sources.yaml
typescript:
  - url: https://raw.githubusercontent.com/PatrickJS/awesome-cursorrules/{sha}/rules/typescript/.cursorrules
    trust: community
    include_sections: [naming, imports, error-handling]
  - local: .claude/skills/overrides/typescript.md
    trust: override
    priority: high
matlab:
  - local: .claude/skills/coding-standards-matlab.md
    trust: verified
python:
  - url: https://raw.githubusercontent.com/PatrickJS/awesome-cursorrules/{sha}/rules/python/.cursorrules
    trust: community
```

---

### Theme 2: Stack Detection & Resolved Artifact
*Figure out what you are, produce a stable artifact*

| # | Idea | Core Insight |
|---|------|-------------|
| #10 | **Stack Detection Heuristics** (CLAUDE.md → manifests → extensions) | Idempotent, result overridable by hand |
| #1 | **Language-Detection Gate** → `detected-stack.json` | Auditable artifact, not a silent assumption |
| #13 | **Multi-Language Merge** (one resolved file per language) | Polyglot repos get scoped rules, not one noisy blob |
| #9 | **Loader Skill** (behavior-only, zero rules in 80-line budget) | Skill = behavior; config = content. Never mix them |
| #3 | **Cached Standards Snapshot** → `coding-standards-resolved-{lang}.md` | Diff-able, offline-safe, stable between sessions |
| #27 | **Diff-Alert on Source Change** | Never silently adopt an upstream breaking rule change |

---

### Theme 3: Fetching & Parsing External Sources
*Reach the internet, bring back usable rules*

| # | Idea | Core Insight |
|---|------|-------------|
| #21 | **SHA-Pinned Raw GitHub URLs** | Reproducible standards — no surprise upstream changes |
| #22 | **WebSearch Fallback for Discovery** | AI finds candidates, human approves, registry auto-updates |
| #23 | **Local Mirror Cache** (`.claude/standards-cache/`) | Fully offline after first fetch |
| #24 | **Source Parsing & Extraction** (imperative rules only) | Turns community prose into injectable rule lines |
| #6 | **Priority Stack with Conflict Log** | Every rule resolution is auditable |

---

### Theme 4: Ralph Loop Integration
*Make standards survive the loop*

| # | Idea | Core Insight |
|---|------|-------------|
| #14 | **Standards Checkpoint at Loop Init** (Step 0) | Standards as loop dependency, same as MCP health check |
| #15 | **Compressed Summary** (≤400 tokens) injected per dispatch | Solves context budget without losing coverage |
| #16 | **Standards Survive Compaction** (pinned in keep-list) | #1 cause of drift — fixed by one line in CLAUDE.md |
| #17 | **Per-Task `standards_scope:`** in Spec | Implementer gets only rules for the file it's editing |
| #19 | **`STANDARDS_VIOLATION` Flag** (CRITICAL blocks / ADVISORY logs) | Enforcement with teeth, not all-or-nothing |
| #20 | **Standards Pinned in Beads/Dolt DB** | Survives branch switches, file deletions, context resets |
| #18 | **Drift Detector** every 10 iterations | Catches slow erosion with a trend line, not just a feeling |

---

### Breakthrough Concepts

**#5 — Standards as a Skill with a Loader**
The 80-line `coding-standards.md` budget should be spent entirely on *behavior* (how to load, resolve, inject), not *content* (the actual rules). Content lives outside, fetched on demand. This inverts the current template design entirely.

**#16 — Standards Survive Compaction**
Simplest fix, highest leverage: one line in CLAUDE.md's compaction keep-list. Without it, every other idea here gradually fails after 40+ Ralph iterations.

**#22 — WebSearch Discovery with Human Approval Gate**
The agent proposes new sources for unknown languages; you approve before they enter the registry. This is how the registry grows organically without requiring you to know every community standards repo.

---

## Prioritization Results

### Top Priority — Foundation (implement first, unlocks everything)
1. **#9 + #2** — Loader Skill + Sources Registry
2. **#16** — Standards Survive Compaction (one line, massive leverage)
3. **#15** — Compressed Summary injected per dispatch

### Quick Wins (this week, standalone value)
- **#10** — Stack detection heuristics → `detected-stack.json`
- **#11** — Local override folder (zero tooling, just a convention)
- **#21** — Pin existing sources to SHA

### Advanced / Later Sprint
- **#20** — Beads/Dolt DB integration for standards persistence
- **#18** — Drift detector (needs iterations to be useful)
- **#22** — WebSearch discovery (needs registry to exist first)

---

## Action Plans

### Action Plan 1 — Build the Foundation (this week)
1. Create `coding-standards-sources.yaml` at repo root (MATLAB + one community source as first entries)
2. Rewrite `coding-standards.md` skill as a loader (behavior only, ≤80 lines)
3. Add stack detection to main agent session init → writes `detected-stack.json`
4. Loader produces `coding-standards-resolved-{lang}.md` + `coding-standards-summary.md`

**Success indicator:** Running main agent produces two new files in `planning-artifacts/` with zero manual steps.

### Action Plan 2 — Ralph Loop Integration (next sprint)
1. Add Step 0 to Ralph's loop: check resolved standards exist before any dispatch
2. Add `coding-standards-summary.md` to CLAUDE.md compaction keep-list
3. Add `standards_scope:` field to planner's task spec template
4. Add `STANDARDS_VIOLATION` to reviewer agent output format

**Success indicator:** Ralph runs 20 iterations; coding standards still referenced on iteration 20.

### Action Plan 3 — External Source Fetching (following sprint)
1. Implement SHA-pinned URL fetching in the loader skill
2. Add `.claude/standards-cache/` local mirror with TTL in frontmatter
3. Add `include_sections:` filtering support to registry entries
4. Add WebSearch discovery fallback with human approval gate

**Success indicator:** Add a new language to the registry → loader auto-fetches, parses, and caches rules, no other changes needed.

---

## Session Summary and Insights

### The Architecture That Emerged

```
coding-standards-sources.yaml          ← you edit this (registry)
         ↓ loader skill reads
detected-stack.json                    ← auto-generated, overridable
         ↓ fetches + extracts
.claude/standards-cache/{lang}-{sha}   ← local mirror, offline-safe
         ↓ merges + prioritizes
coding-standards-resolved-{lang}.md    ← full rules, reviewers read this
         ↓ summarizes (≤400 tokens)
coding-standards-summary.md            ← survives compaction, pinned
         ↓ Ralph injects per task (scoped by standards_scope:)
implementer dispatch                   ← gets only relevant language rules
         ↓ reviewer checks
STANDARDS_VIOLATION flag               ← CRITICAL blocks / ADVISORY logs
         ↓ every 10 iterations
standards-drift-{date}.md             ← trend detection, not just feelings
```

### Key Insights
- The current `coding-standards.md` template has the wrong design: it stores content when it should store behavior
- Standards drift (followed early, ignored late) is the core failure mode to design against — not initial adoption
- The registry pattern (one editable file → dynamic loading) solves both the flexibility ask and the editability ask in a single mechanism
- SHA pinning for external sources is non-negotiable for reproducible agent behavior

### Creative Breakthroughs
- Reframing the 80-line skill budget as "behavior budget not content budget" unlocks the whole architecture
- Treating `coding-standards-summary.md` as a first-class compaction artifact (alongside `project-status.md`) is the highest-leverage single change
- Using Beads/Dolt as the persistent store for `detected-stack` and `active-sources` makes the system branch-aware for free
