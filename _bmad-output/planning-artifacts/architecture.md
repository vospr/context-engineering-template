---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
lastStep: 8
status: 'complete'
completedAt: '2026-02-17'
inputDocuments:
  - further_sdd.md
  - brainstorming-session-2026-02-17.md
  - CLAUDE.md
  - README.md
workflowType: 'architecture'
project_name: 'Claude_Template'
user_name: 'Andrey'
date: '2026-02-17'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Philosophical Foundation: 6 Irreducible Truths

Before any design decision, these truths were derived from first principles — stripped of all assumptions from Automaker, Anthropic, Spec Kit, and the brainstorming session:

1. **An agent cannot autonomously verify its own work without a definition of "done" that exists outside its own context.** Something must state what "done" means before the agent starts working.
2. **A spec is only useful if the agent that consumes it can act on it without asking for clarification.** Specs must be precise enough that an agent can unambiguously determine pass/fail. Verifiable assertions pass this test; prose descriptions fail it.
3. **The cost of specifying must be less than the cost of not specifying.** SDD must have positive ROI at every tier — including zero cost for trivial tasks.
4. **State must survive context death.** Every fact that matters must exist in a file before the context that produced it disappears. Files are the only durable memory.
5. **Agents must not need to understand the whole to execute a part.** Task units must be self-contained: what to build, how to verify, what not to touch — nothing more.
6. **The system must be able to answer "where are we?" at any moment from files alone.** A cold-start session must reconstruct project state without replaying history.

**Architectural anchor:** SDD is not about specs. SDD is about giving agents an *external, verifiable, decomposable definition of done* that survives context death and costs less than the alternative.

### Requirements Overview

**Functional Requirements:**

The SDD extension adds a structured specification layer to the existing dispatch loop. Core functional requirements extracted from the brainstorming session's 7 tiers:

1. **Spec Format & Authoring (Tier 1-2):** Graduated spec format router extending CLAUDE.md's complexity classifier; concrete YAML spec packet format (#51); controlled vocabulary (MUST/SHOULD/MAY/MUST NOT); hybrid spec model (human-readable overview + machine-consumable per-task packets); executable acceptance criteria (assertions, not prose); 7x7 constraint (max 7 tasks/feature, 7 assertions/task)
2. **Execution Pipeline (Tier 3):** Pre-implementation checklist; inline verification (TDD dispatch — implementer runs assertions during execution); post-task artifact audit; just-in-time decomposition (spec next 3-5 tasks, not entire DAG); expediter pattern (haiku pre-check); multi-axis task classification (complexity + risk + novelty + coupling); reversibility tracking
3. **Verification & Quality (Tier 4):** Two-layer verification (innate automated + adaptive agent); feature-level integration assertions; spec-level circuit breaker; graduated escalation (Green → Yellow → Orange → Red); graduation ceremony (formal feature completion)
4. **Tracking & Continuity (Tier 5):** Hierarchical feature tracker (JSON, #52); zero-handoff continuity; multi-scale views; token budgets per feature; spec metrics dashboard
5. **Agent Extensions (Tier 6):** Planner gains spec authoring + gap detection; reviewer gains spec review mode; tester gains assertion execution + integration verification modes; compressed inter-agent signals (~20 tokens)
6. **Governance (Tier 7):** Spec immutability + mutation protocol; escape clauses; tiered clarification resolution; assumption tracking objects; failure pattern library; difficulty scaling

**Non-Functional Requirements:**

- **Token discipline:** SDD operations must fit within existing <128k budget; minimum viable spec = ~60 tokens; token budgets per feature by tier (TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000)
- **Backward compatibility:** SDD is opt-in; presence of `spec-protocol.md` triggers SDD mode; absence = original dispatch behavior unchanged
- **Zero-code constraint:** All specifications, protocols, and governance are markdown/YAML files — no runtime code, no build steps, no external dependencies
- **Incremental adoption:** 5 mandatory migration steps, 2 optional; each step independently valuable
- **Agent isolation:** Agents receive only the spec fields they consume; spec views are role-specific

**Scale & Complexity:**

- Primary domain: AI agent orchestration framework (markdown-based)
- Complexity level: HIGH — multi-tier architecture governing spec lifecycle
- Estimated architectural components: 8 (spec protocol, planner extension, reviewer extension, tester extension, feature tracker, dispatch loop changes, governance layer, verification pipeline)

### Architectural Approach: Thin Vertical Slice (Path B)

Rather than building 7 horizontal tiers sequentially (which delays end-to-end feedback), the architecture follows a vertical slice model — building the thinnest possible end-to-end pipeline first, then iteratively widening each stage with real-world feedback.

- **Slice 1 (MVP Pipeline):** Minimum viable spec (~60 tokens) + controlled vocabulary + planner spec authoring via skill + inline assertions + post-task audit. Goal: one spec flows end-to-end.
- **Slice 2 (Track & Continue):** Hierarchical feature tracker (JSON) + zero-handoff continuity + token budgets per feature. Goal: sessions survive context resets.
- **Slice 3 (Govern & Verify):** Constitution + spec ratification + two-layer verification + graduated escalation + spec-level circuit breaker. Goal: quality enforcement.
- **Slice 4 (Scale & Extend):** Full hybrid spec model + agent extensions (planner/reviewer/tester modes) + agent-specific spec views + metrics dashboard + advanced governance. Goal: production-grade SDD.

**Why vertical over horizontal:** Path A (7-tier sequential) produces a complete spec format that nobody executes until Tier 3. Path C (constitution-first) produces governance for a pipeline that doesn't exist yet. Path B delivers a working end-to-end pipeline in Slice 1, with each subsequent slice informed by real execution experience.

### Architecture Decision Records

#### ADR-001: Spec Format — YAML Packets + Markdown Overview

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Per-task format | YAML packet | Machine-parseable, lintable, agent-consumable |
| Overview format | Markdown | Human-readable, review-friendly |
| Schema strategy | Full schema defined upfront, enforcement progressive by slice | Stable contract; growing discipline |
| Slice 1 required fields | `version`, `intent`, `assertions`, `file_scope`, `constraints` | Minimum to prevent implementer drift + schema versioning |
| Slice 3+ required fields | All 11 (adds `freedom`, `assumptions`, `escape_clause`, `checksum`, `parent_feature`, `tier`) | Full governance |

*First principles validation:* Satisfies Truth 1 (external done via assertions), Truth 2 (unambiguous via YAML structure), Truth 5 (self-contained task units).

#### ADR-002: Spec Authoring — Skill-First, Agent Extension Deferred

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Slice 1 | Spec-protocol.md as skill; planner consumes it via dispatch prompt | Minimal change; easy to iterate on format |
| Slice 4 | Extend planner.md with permanent spec authoring responsibility | Only after format is proven stable through 3 slices |
| New agent | Never | No new agents — brainstorming principle #1 holds |

*First principles validation:* Satisfies Truth 3 (lowest cost authoring mechanism — no agent changes, no new dispatch paths).

#### ADR-003: Verification — Inline Assertions + Post-Task Audit (Slice 1), Two-Layer (Slice 3)

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Slice 1 | Inline assertions (implementer runs during execution) + post-task artifact audit | Highest ROI; minimal infrastructure |
| Slice 3 | Two-layer verification: automated (lint, assertions, file audit) gates agent review | 80% catch rate at 5% cost |
| Existing circuit breaker | Retained unchanged | Still catches quality failures the new layers miss |
| Tester extension | Slice 3 (assertion execution mode + integration mode) | Only after verification needs are proven |

*First principles validation:* Satisfies Truth 1 (external done criteria) and Truth 2 (unambiguous pass/fail). Post-task audit provides external check on implementer claims.

#### ADR-004: Feature Tracker — JSON Index File

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Format | JSON file at `planning-artifacts/feature-tracker.json` | Structured, git-tracked, survives context resets |
| Role | Aggregation index; specs and results in separate files | Single responsibility |
| Slice 2 required fields | `id`, `title`, `phase`, `tasks[]`, `verified` | Minimum for tracking and continuity |
| Slice 3+ fields | Adds `tier`, `token_budget`, `token_spent`, `entropy_score`, `assertions_total`, `assertions_passing` | Governance and metrics |
| TaskList relationship | TaskList remains the execution DAG; tracker is the feature-level view | Complementary, not competing |

*First principles validation:* Directly implements Truth 6 (answer "where are we?" from files alone) and Truth 4 (state survives context death).

#### ADR-005: Governance — Progressive, from Lightweight to Full Constitution

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Slice 1 | Governance section within spec-protocol.md (lightweight, 5-10 principles) | Non-blocking; immediate value |
| Slice 3 | Optional constitution.md with formal articles and Phase -1 gates | Full governance when pipeline is proven |
| Precedence rule | constitution.md > spec-protocol.md > skills > agent freedom | Defined from Slice 1, enforced progressively |
| Skills relationship | Skills = HOW; Constitution = WHY; both inform spec authoring | Complementary layers |

*First principles validation:* Satisfies Truth 3 (governance scales with complexity; no upfront cost for simple projects).

### Technical Constraints & Dependencies

- **Platform:** Claude Code CLI on any OS (Windows/Mac/Linux)
- **State persistence:** File-based only (planning-artifacts/, implementation-artifacts/, .claude/)
- **Agent model:** Extend existing 6 agents — researcher, planner, architect, implementer, reviewer, tester — no new agents
- **Dispatch loop:** CLAUDE.md kernel must remain under 200 lines; SDD logic lives in skills and agent definitions
- **Git workflow:** Feature branches; implementer micro-commits; merge to main after review
- **Existing infrastructure to leverage:** TaskList (DAG), Task tool (agent dispatch), fan-out pattern (parallel execution), circuit breaker (3-cycle max), model routing (haiku/sonnet/opus)

### Cross-Cutting Concerns

1. **Token economics permeate every decision** — spec authoring, dispatch, verification, and tracking all consume tokens; the architecture must make token cost visible and controllable at every tier
2. **Governance cascade** — constitution (if present) > spec overview > per-task criteria > agent freedom; lower-numbered decision layers win conflicts
3. **Verification layering** — cheap automated checks (lint, assertions, file audit) gate expensive agent reviews; 80% of failures caught at 5% of cost
4. **Agent context minimization** — each agent sees only its relevant spec fields; dispatch loop strips unnecessary context before passing
5. **Spec lifecycle management** — specs are immutable once ratified; changes require formal amendment; in-progress tasks continue against old version
6. **Session continuity** — the hierarchical feature tracker + per-task assertion results + spec overviews encode complete project state; new session = read tracker, find first unverified, resume
7. **Feedback-driven design** — each slice is informed by real execution experience from the previous slice; governance is designed for observed problems, not theoretical ones
8. **Progressive capability** — the system is usable after Slice 1; each subsequent slice adds value independently without requiring all slices to be complete

### Vulnerability Register (Red Team Verified)

| # | Vulnerability | Severity | Mitigation |
|---|-------------|----------|------------|
| 1 | Spec tax on trivial tasks | HIGH | TRIVIAL bypass — zero overhead; graduated router classifies before spec authoring triggers |
| 2 | LLM YAML generation failures | MEDIUM | Filled template examples in spec-protocol.md; forgiving parser fallback; max 1 lint-retry cycle |
| 3 | Self-graded assertions (Slice 1) | MEDIUM | Accepted risk with reviewer safety net; implementer must provide assertion evidence (file:line references); fully closed in Slice 3 with independent tester execution |
| 4 | Feature tracker single point of failure | MEDIUM | Git backup; rebuildable from source files + TaskList; graceful degradation to non-SDD mode if JSON unreadable |
| 5 | Slice boundary rework | LOW | Schema versioning from Slice 1 (`version` field required); additive-only field changes; spec-protocol.md as single evolution point |
| 6 | Token overhead underestimated | LOW | Graduated router (weighted avg ~80 tokens/task); token overhead monitoring triggers at 15% budget threshold (Slice 4) |

### Assertion Quality Gate

To enforce Truth 2 (unambiguous specs), spec-protocol.md includes:

> Every assertion must name a *specific observable*: an endpoint, a file, a UI element, a return value, or an error code. Assertions containing "works," "correct," "proper," or "appropriate" without a specific observable are invalid.

## Starter Template Evaluation

### Primary Technology Domain

**Markdown-based AI agent orchestration framework** — zero runtime code, no traditional tech stack. The "application" is a set of markdown/YAML files consumed by Claude Code CLI.

### Starter: Existing Template (Already In Place)

**Rationale:** This is a framework extension project, not a greenfield application. The existing Claude Code Context Engineering Template serves as the foundation.

**Existing Infrastructure (No Changes Needed):**

| Component | Current State | SDD Impact |
|-----------|--------------|------------|
| CLAUDE.md dispatch loop | 6-step cycle, <200 lines | +3 lines (ADR-005, Step 5 of migration) |
| 6 agent definitions | .claude/agents/*.md | 3 extended in Slice 4 (planner, reviewer, tester) |
| Skills directory | .claude/skills/ | +1 file: spec-protocol.md |
| Planning artifacts | planning-artifacts/ | +1 file: feature-tracker.json (Slice 2) |
| TaskList DAG | Claude Code built-in | Unchanged; complemented by feature tracker |
| Git workflow | Feature branches, micro-commits | Unchanged |
| Token management | Compaction at 80k, <128k budget | Unchanged; SDD operates within existing budget |

**SDD Additions (New Files):**

| File | Slice | Purpose |
|------|-------|---------|
| `.claude/skills/spec-protocol.md` | 1 | Spec format, vocabulary, assertion guide, governance seed |
| `planning-artifacts/feature-tracker.json` | 2 | Feature-level progress index |
| `planning-artifacts/constitution.md` | 3 (optional) | Immutable project principles with Phase -1 gates |
| `.claude/spec-templates/` | 4 (optional) | Reusable spec patterns per project type |

**Note:** No initialization command needed. SDD is activated by creating `spec-protocol.md` in an existing template project.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Spec lifecycle states (progressive: 3 states → 6 states)
- Dispatch loop integration (3 CLAUDE.md changes + file presence detection)
- File organization (spec packets inline in TaskList, overviews flat)

**Important Decisions (Shape Architecture):**
- Agent communication protocol (use existing TaskUpdate, defer signal protocol)
- Failure & recovery patterns (5 explicit failure paths)

**Deferred Decisions (Slice 3+):**
- Compressed inter-agent signal protocol
- Full spec lifecycle states (LINT_PASS, RATIFIED, GRADUATED)
- Spec-level circuit breaker (requires feature tracker)
- Token overhead monitoring threshold

### Decision 1: Spec Lifecycle — Progressive States

| Slice | States | Transitions |
|-------|--------|-------------|
| Slice 1 | DRAFT → ACTIVE → DONE | Planner writes (DRAFT), dispatch accepts (ACTIVE), assertions pass (DONE) |
| Slice 3 | DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED | Full quality gates at each transition |

Rationale: Matches vertical slice philosophy. 3 states are sufficient until governance (Slice 3) demands formal checkpoints.

### Decision 2: Dispatch Loop Integration

**SDD Detection:** File presence — if `.claude/skills/spec-protocol.md` exists, SDD mode is active. Follows template's self-discovery pattern.

**3 CLAUDE.md Modifications:**

1. **Step 2 (Select Next Task):** Add: "If no tasks AND spec-protocol.md exists AND feature-tracker.json has unverified features → dispatch planner to spec next feature"
2. **Step 4 (Classify Complexity):** Extend to multi-output: selects model AND spec_tier. TRIVIAL = no spec, direct dispatch. SIMPLE+ = planner writes spec per spec-protocol.md.
3. **Step 6 (Process Result):** Add: "If NEEDS_RESPEC → dispatch planner to re-spec affected subtree"

All SDD logic beyond these 3 lines lives in spec-protocol.md.

### Decision 3: File Organization

**Spec packets:** Inline in TaskList task descriptions. Planner embeds YAML spec (intent, assertions, file_scope, constraints) directly in task description. Agent receives spec automatically via TaskGet — zero extra file reads.

**Spec overviews:** Flat in planning-artifacts/ as `spec-{feature-id}-{name}-overview.md`. Human-readable, architect-reviewable.

**Feature tracker:** `planning-artifacts/feature-tracker.json` (ADR-004).

```
planning-artifacts/
  feature-tracker.json
  spec-F-001-auth-overview.md
  spec-F-002-api-overview.md

TaskList tasks carry YAML spec packets in descriptions.
```

Rationale: Lowest token cost. Fully aligned with existing TaskList dispatch pattern. Zero additional Read calls per task.

### Decision 4: Agent Communication Protocol

**Slice 1:** No protocol change. Agents use existing TaskUpdate to report status (completed, blocked). Detailed findings written to implementation artifacts when needed.

**Slice 3+:** Introduce compressed signal block (~20 tokens) at end of agent output for token-efficient dispatch routing.

Rationale: Zero new infrastructure in Slice 1. Existing TaskUpdate already communicates what the dispatch loop needs.

### Decision 5: Failure & Recovery Matrix

| Failure | Detection | Response | Slice |
|---------|-----------|----------|-------|
| Malformed spec YAML | Spec lint on planner output | Retry once with error → forgiving parser fallback → BLOCKED if both fail | 1 |
| Assertions fail | Implementer reports, reviewer confirms | Existing circuit breaker (3 cycles max) → BLOCKED | 1 |
| Feature stalls (3+ BLOCKED tasks) | Dispatch loop scans feature-tracker.json | Flag feature for re-spec, planner re-evaluates decomposition | 2 |
| Feature tracker corrupt | JSON parse fails on load | Graceful degradation to non-SDD mode; git checkout recovers | 2 |
| Planner produces no spec | Output contains no assertions | Treat as TRIVIAL (direct dispatch); log warning | 1 |

### Cross-Decision Dependencies

- Decision 3 (inline specs) simplifies Decision 4 (no signal protocol needed in Slice 1) — the task description carries everything
- Decision 1 (progressive states) aligns with Decision 5 (failure handling grows with slices)
- Decision 2 (3 CLAUDE.md changes) depends on Decision 3 (spec_tier classification triggers spec authoring inline)

## Implementation Patterns & Consistency Rules

### Pattern 1: Spec Packet Authoring (Planner Output)

**Conflict risk:** Planner writes YAML differently each time — inconsistent field ordering, varying assertion styles, missing required fields.

**Pattern:**
```yaml
# Every spec packet in a task description MUST follow this exact structure:
# --- SPEC ---
version: 1
intent: "[imperative verb] [specific observable outcome]"
assertions:
  - id: A1
    positive: "[subject] [MUST/MUST NOT] [specific observable]"
    negative: "[subject] [MUST NOT/MUST] [opposite observable]"
constraints:
  - "[MUST/MUST NOT] [specific constraint]"
file_scope:
  - path/to/file.ext
# --- END SPEC ---
```

**Rules:**
- Spec packet delimited by `--- SPEC ---` and `--- END SPEC ---` markers (enables forgiving parser)
- `intent` starts with imperative verb, names specific outcome
- Each assertion has both `positive` and `negative` (double-entry, ADR-001)
- Assertions use controlled vocabulary: MUST, MUST NOT, SHOULD, MAY
- Assertion quality gate: must name a specific observable — no "works correctly"
- Max 7 assertions per task (7x7 constraint)
- `file_scope` lists only files the implementer may modify

### Pattern 2: Implementer Evidence Reporting

**Conflict risk:** Implementers report "done" with varying levels of proof. Some provide file:line references, others just say "completed."

**Pattern:**
```
## Assertion Results
- A1: PASS — src/auth/login.ts:42 (POST handler returns 200)
- A2: PASS — src/auth/login.ts:58 (returns 401 for invalid credentials)
- A3: PASS — src/auth/login.test.ts:15-28 (test covers both cases)
```

**Rules:**
- Every assertion ID from the spec packet MUST appear in results
- Each result: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
- FAIL results MUST include what was expected vs what happened
- Missing assertion results = task is NOT DONE

### Pattern 3: Spec Overview Naming & Structure

**Conflict risk:** Inconsistent file naming for spec overviews.

**Pattern:**
```
planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md
```

**Rules:**
- Feature IDs: `F-001`, `F-002`, etc. — zero-padded 3 digits
- Task IDs: `T-001`, `T-002`, etc. — globally unique across features
- Assertion IDs: `A1`, `A2`, etc. — unique within a task only
- Overview file always contains: feature title, goal summary, task list with IDs, acceptance criteria summary

### Pattern 4: Feature Tracker Entry Format

**Conflict risk:** JSON entries with inconsistent field ordering or missing fields.

**Pattern (Slice 2):**
```json
{
  "id": "F-001",
  "title": "User Authentication",
  "phase": "ACTIVE",
  "spec_overview": "planning-artifacts/spec-F-001-auth-overview.md",
  "tasks": ["T-001", "T-002", "T-003"],
  "verified": false
}
```

**Rules:**
- `phase` values: DRAFT | ACTIVE | DONE (Slice 1 states only)
- `tasks` array references TaskList task IDs
- `verified` flips to `true` only when ALL task assertions pass
- Fields are always in the order shown above

### Pattern 5: Dispatch Prompt Templates

**Conflict risk:** Main agent phrases dispatch prompts differently each time, causing agents to receive inconsistent context.

**Pattern for SDD dispatch:**
```
Implement task T-{id}: {task subject}

Spec packet is embedded in the task description. Read it via TaskGet.
Follow all assertions. Report evidence per assertion ID.
Constraints in the spec are non-negotiable.
Freedom not listed in constraints is yours to decide.
```

**Rules:**
- Always reference "spec packet in task description" — never paste the spec into the dispatch prompt (avoids duplication)
- Always remind agent to report per assertion ID
- Never add instructions that contradict the spec's constraints

### Pattern 6: State Transitions & Ownership

**Conflict risk:** Agents update feature tracker or task status inconsistently.

**Rules:**
- Only the **planner** creates feature tracker entries and spec overviews
- Only the **dispatch loop** (main agent) changes feature `phase`
- Only the **implementer** marks tasks as completed via TaskUpdate
- Only the **dispatch loop** flips `verified` to true after checking all assertion results
- No agent modifies another agent's output files

### Enforcement Guidelines

**All agents MUST:**
- Follow spec packet structure exactly (Pattern 1)
- Report assertion evidence with file:line references (Pattern 2)
- Use controlled vocabulary (MUST/SHOULD/MAY/MUST NOT) in all spec-related text
- Respect file_scope — never modify files not listed in the spec packet

**Pattern Enforcement:**
- Spec lint (automated): validates YAML structure, required fields, assertion quality gate
- Post-task audit (automated): verifies all assertion IDs have results, file_scope respected
- Reviewer (agent): validates assertion evidence matches actual code changes
- Patterns documented in spec-protocol.md as the single source of truth

**Anti-Patterns:**
- Writing assertions without specific observables: "Authentication works properly"
- Reporting PASS without file:line evidence: "A1: PASS — looks good"
- Modifying files outside file_scope without updating the spec
- Planner creating tasks without embedded spec packets (for SIMPLE+ tiers)

## Project Structure & Boundaries

### Complete Project Directory Structure

```
project-root/
├── CLAUDE.md                                    # Dispatch loop kernel (+3 lines for SDD)
├── README.md                                    # Project documentation
├── .gitignore                                   # Includes .env*, credentials.*, secrets/
│
├── .claude/
│   ├── agents/                                  # Self-discovering agent pool
│   │   ├── researcher.md                        # Web search, tech evaluation
│   │   ├── planner.md                           # Task DAG + spec authoring (Slice 4: permanent extension)
│   │   ├── architect.md                         # System design, tech selection
│   │   ├── implementer.md                       # Code writing, file editing
│   │   ├── reviewer.md                          # Code review + spec review (Slice 4: dual mode)
│   │   └── tester.md                            # Test execution + assertion execution (Slice 4: triple mode)
│   │
│   ├── skills/
│   │   ├── spec-protocol.md                     # [NEW: Slice 1] SDD core — format, vocabulary, assertions, governance seed
│   │   ├── coding-standards.md                  # Existing project-specific coding rules
│   │   └── testing-strategy.md                  # Existing testing approach
│   │
│   └── spec-templates/                          # [NEW: Slice 4, optional] Reusable spec patterns
│       ├── rest-crud-endpoint.yaml              # Template for REST CRUD features
│       ├── auth-flow.yaml                       # Template for auth features
│       └── data-pipeline.yaml                   # Template for data processing features
│
├── planning-artifacts/
│   ├── feature-tracker.json                     # [NEW: Slice 2] Feature-level progress index
│   ├── constitution.md                          # [NEW: Slice 3, optional] Immutable project principles
│   ├── spec-F-001-{name}-overview.md            # [NEW: Slice 1] Per-feature spec overviews
│   ├── spec-F-002-{name}-overview.md
│   ├── decisions.md                             # Architectural/technology decision log
│   ├── project-status.md                        # Current phase, milestones, blockers
│   ├── session-context.md                       # Token compaction summaries
│   └── knowledge-base/                          # Shared context artifacts between agents
│       ├── README.md
│       └── failure-patterns.md                  # [NEW: Slice 3] Learning from past failures
│
├── implementation-artifacts/
│   └── (created at runtime by implementer/reviewer/tester)
│
└── docs/                                        # Project documentation (if applicable)
```

### Architectural Boundaries

**Agent Ownership Boundaries:**

| File/Artifact | Creator | Modifier | Reader |
|---------------|---------|----------|--------|
| CLAUDE.md | Human | Human only | Main agent (dispatch loop) |
| spec-protocol.md | Human/Architect | Human/Architect | Planner, Reviewer |
| spec-F-*-overview.md | Planner | Planner only | Architect, Reviewer, Human |
| Task descriptions (spec packets) | Planner | Planner only | Implementer, Reviewer, Tester |
| feature-tracker.json | Planner (entries) | Dispatch loop (phase, verified) | All agents, dispatch loop |
| constitution.md | Human/Architect | Human only (amendment protocol) | Planner, Reviewer, Architect |
| implementation code | Implementer | Implementer only | Reviewer, Tester |
| decisions.md | Any agent | Append-only | All agents |

**Key boundary rule:** No agent modifies another agent's output files. The planner writes specs; the implementer writes code; the reviewer writes reviews. Cross-boundary communication happens through the dispatch loop, not direct file modification.

**Dispatch Loop Boundaries:**

```
Main Agent (CLAUDE.md)
  │
  ├─→ Reads: feature-tracker.json, TaskList, spec-protocol.md (existence check)
  ├─→ Writes: feature-tracker.json (phase transitions, verified flag)
  ├─→ Dispatches: all 6 agents via Task tool
  │
  └─→ SDD Decision Point (Step 4):
       ├─ spec-protocol.md absent → standard dispatch (current behavior)
       └─ spec-protocol.md present → SDD dispatch:
            ├─ TRIVIAL → direct dispatch, no spec
            ├─ SIMPLE  → planner writes minimal spec packet in task description
            ├─ MODERATE → planner writes full spec + overview
            └─ COMPLEX → architect pre-check → planner writes spec suite + overview
```

### Data Flow: Spec Lifecycle

```
User Goal
  → Dispatch Loop classifies complexity (spec_tier)
  → Planner reads spec-protocol.md skill
  → Planner creates:
      ├─ Spec overview (planning-artifacts/spec-F-NNN-name-overview.md)
      ├─ Tasks with embedded YAML spec packets (TaskCreate)
      └─ Feature tracker entry (feature-tracker.json)
  → Dispatch Loop picks next task (TaskList)
  → Pre-task: spec lint validates YAML in task description
  → Implementer reads task (TaskGet — spec packet included)
  → Implementer executes against assertions
  → Implementer reports evidence (Pattern 2)
  → Post-task audit: checks assertion results + file_scope
  → Reviewer validates evidence against code
  → Dispatch Loop: all tasks DONE? → check assertions → flip verified
```

### Integration Points

**Internal (between SDD components):**
- spec-protocol.md → planner (skill consumption)
- Task descriptions → implementer (spec packet delivery)
- feature-tracker.json → dispatch loop (progress queries)
- constitution.md → planner, reviewer (constraint propagation, Slice 3)

**External (unchanged from current template):**
- TaskList API → dispatch loop (built-in Claude Code)
- Task tool → agent dispatch (built-in Claude Code)
- Git → all agents (state persistence, recovery)
- MCP servers → researcher, tester (if configured)

### Slice Delivery Map

| Slice | New Files | Modified Files | New Capabilities |
|-------|-----------|----------------|------------------|
| **1** | spec-protocol.md | CLAUDE.md (+3 lines) | Spec authoring, inline assertions, post-task audit |
| **2** | feature-tracker.json | (none) | Feature tracking, zero-handoff continuity, token budgets |
| **3** | constitution.md (opt), failure-patterns.md | (none) | Governance gates, two-layer verification, escalation |
| **4** | spec-templates/ (opt) | planner.md, reviewer.md, tester.md | Agent extensions, spec views, metrics |

## Architecture Validation Results

### Coherence Validation: PASS

- All 10 decisions (5 ADRs + 5 operational decisions) are mutually compatible
- All 6 patterns align with architectural decisions
- Project structure supports all decisions and patterns
- No contradictions found
- Clarification: spec-protocol.md should explicitly state planner creates tracker entries, dispatch loop updates status fields

### Requirements Coverage: PASS

- All 6 functional requirement areas mapped to specific decisions and slices
- All 5 non-functional requirements covered by architectural mechanisms
- Every brainstorming tier (1-7) has a home in the 4-slice delivery plan
- No orphan requirements

### Implementation Readiness: PASS

- 10 architectural decisions with rationale and first-principles validation
- 6 implementation patterns with concrete examples and anti-patterns
- Complete directory structure with agent ownership boundaries
- Spec lifecycle data flow documented end-to-end
- Red Team verified: 6 vulnerabilities, all mitigated

### Gap Analysis: NO CRITICAL GAPS

| Gap | Priority | Description | Resolution |
|-----|----------|-------------|------------|
| GAP-1 | Important | spec-protocol.md is the first implementation deliverable | Create from this architecture doc |
| GAP-2 | Nice-to-have | No concrete example of a complete spec overview | Create during Slice 1 testing |
| GAP-3 | Nice-to-have | Token budgets are estimates, not validated | Calibrate by Slice 4 metrics |

### Architecture Completeness Checklist

**Requirements Analysis**
- [x] Project context analyzed (brainstorming session + further_sdd.md + 4-system comparison)
- [x] Scale and complexity assessed (HIGH — multi-tier framework)
- [x] Technical constraints identified (zero-code, <128k tokens, backward compatible)
- [x] Cross-cutting concerns mapped (8 concerns)

**Architectural Decisions**
- [x] 5 ADRs documented with first-principles validation
- [x] 5 operational decisions with rationale
- [x] All decisions Red Team stress-tested
- [x] Vulnerability register maintained (6 entries, all mitigated)

**Implementation Patterns**
- [x] 6 consistency patterns with concrete examples
- [x] Anti-patterns documented
- [x] Enforcement mechanisms defined
- [x] Controlled vocabulary established (MUST/SHOULD/MAY/MUST NOT)

**Project Structure**
- [x] Complete directory tree with slice annotations
- [x] Agent ownership boundaries for every artifact
- [x] Dispatch loop boundary diagram
- [x] Spec lifecycle data flow
- [x] Slice delivery map (4 slices)

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** HIGH

**Key Strengths:**
- Grounded in 6 irreducible first principles — not borrowed patterns
- Adversarially tested (Red Team found no critical vulnerabilities)
- Backward compatible by design (file presence detection)
- Lowest possible token cost (inline specs, graduated router, TRIVIAL bypass)
- Aligned with existing template architecture (extends, doesn't replace)
- Progressive delivery (4 slices, each independently valuable)

**Areas for Future Enhancement (Post Slice 1):**
- Compressed inter-agent signal protocol (Slice 3+)
- Token overhead monitoring and calibration (Slice 4)
- Spec template library for common patterns (Slice 4)
- Formal constitution with Phase -1 gates (Slice 3)

### Implementation Handoff

**AI Agent Guidelines:**
- This architecture document is the source of truth for all SDD implementation
- Follow all patterns exactly as documented
- Respect agent ownership boundaries (Pattern 6)
- Use controlled vocabulary in all spec-related artifacts

**First Implementation Priority: Create spec-protocol.md (Slice 1)**

Contents derived from this architecture document:
1. Spec packet YAML format (Pattern 1)
2. Controlled vocabulary (MUST/SHOULD/MAY/MUST NOT)
3. Assertion quality gate (ban vague language, require specific observables)
4. Graduated tier definitions (TRIVIAL/SIMPLE/MODERATE/COMPLEX)
5. Filled template examples for each tier
6. Governance seed (5-10 project principles)
7. 7x7 constraint (max 7 tasks/feature, 7 assertions/task)
8. Forgiving parser fallback rules

### README Update Condition

When a template project is realized through any test scenario execution (Scenario A, B, C, or D), the **target project's README.md** MUST be updated to reflect the realized case. This is an architectural principle, not a one-time manual step.

**Rule:** The implementer agent, as the final step of a successful scenario execution, MUST append or update a "Validation Results" section in the realized project's `README.md` containing:

1. Which scenario was executed (A/B/C/D)
2. Key metrics (tokens used, test results, behavioral check scores)
3. Artifacts created (file list)
4. Pass/fail verdict against the scenario's criteria

**Rationale:** Satisfies Truth 6 — a cold-start session reading the project's README can immediately determine what was built, how it was validated, and what passed. The README is the first file any human or agent reads; it must reflect the project's realized state, not just the template's aspirational structure.

**Scope:** This applies to the target project directory (e.g., `scenarioD/README.md`), NOT to the template repository's README. The template README documents the framework; realized project READMEs document what was actually built and validated.

**Implementation:** Add this as a final step in the implementer agent's post-execution checklist and in each scenario's guidance document under "Deliverables."
