---
stepsCompleted: [1, 2, 3, 4, 5, 6]
status: 'updated'
completedAt: '2026-02-17'
updatedAt: '2026-02-21'
inputDocuments:
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/brainstorming/brainstorming-session-2026-02-17.md
  - _bmad-output/brainstorming/brainstorming-session-2026-02-21.md
---

# Claude_Template - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for the SDD (Spec-Driven Development) extension to the Claude Code Context Engineering Template, decomposing the requirements from the Architecture document into implementable stories organized by the 4-slice vertical delivery model.

## Requirements Inventory

### Functional Requirements

FR1: Graduated spec format router that classifies tasks into TRIVIAL/SIMPLE/MODERATE/COMPLEX tiers and routes accordingly
FR2: YAML spec packet format with required fields: version, intent, assertions, file_scope, constraints
FR3: Controlled vocabulary enforcement (MUST/SHOULD/MAY/MUST NOT) in all spec-related artifacts
FR4: Assertion quality gate — every assertion must name a specific observable; ban vague language ("works," "correct," "proper," "appropriate" without observable are invalid)
FR5: 7x7 constraint enforcement — max 7 tasks per feature, max 7 assertions per task
FR6: Spec packets embedded inline in TaskList task descriptions (zero extra file reads)
FR7: Spec overview documents created per feature in planning-artifacts/ following naming pattern spec-F-{NNN}-{kebab-name}-overview.md
FR8: Dispatch loop SDD detection via file presence of spec-protocol.md
FR9: 3 CLAUDE.md modifications: Step 2 (auto-spec next feature), Step 4 (spec_tier classification), Step 6 (NEEDS_RESPEC handling)
FR10: Spec lifecycle states: DRAFT → ACTIVE → DONE (Slice 1), expanding to DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED (Slice 3)
FR11: Implementer evidence reporting with assertion ID + file:line references for every assertion in the spec packet
FR12: Feature tracker JSON index file at planning-artifacts/feature-tracker.json with fields: id, title, phase, spec_overview, tasks[], verified
FR13: Two-layer verification: automated gates (lint, assertions, file audit) before agent review (Slice 3)
FR14: Agent extensions — planner gains spec authoring, reviewer gains spec review mode, tester gains assertion execution + integration verification modes (Slice 4)
FR15: Cross-agent Trace ID — every dispatch generates a `TRACE-{YYYY-MM-DD}-{HHmm}-{3-word-slug}` ID passed to all agents and included in every artifact header; reviewer/tester include UPSTREAM_TRACE on CRITICAL findings to enable causal chain tracing
FR16: Complexity escalation protocol — implementer reports ESCALATED status when discovered complexity exceeds classification; dispatch loop re-classifies and re-dispatches; max 1 escalation per task
FR17: Mandatory failure-pattern consultation — planner MUST consult failure-patterns.md before speccing any feature in a matching domain and either add preventive constraints or document why the pattern does not apply; reviewer captures new CRITICAL-issue patterns via structured output for dispatch loop to append
FR18: System health circuit breakers — dispatch loop checks every 10 tasks: >3 simultaneously BLOCKED pauses dispatch; same task dispatched >5 times escalates to user; single planning dispatch creating >15 tasks flags for user review before dispatch
FR19: Reasoning strategy selector — planner and architect explicitly select between Linear (CoT), Branching (ToT), and Graph reasoning modes based on problem characteristics before analysis begins

### NonFunctional Requirements

NFR1: Token discipline — SDD operations must fit within existing <128k budget; minimum viable spec ~60 tokens; tier budgets TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000
NFR2: Backward compatibility — SDD is opt-in via file presence detection; absence of spec-protocol.md preserves original dispatch behavior unchanged
NFR3: Zero-code constraint — all specifications, protocols, and governance are markdown/YAML files; no runtime code, no build steps, no external dependencies
NFR4: Incremental adoption — each slice is independently valuable; 5 mandatory migration steps, 2 optional; system is usable after Slice 1
NFR5: Agent isolation — agents receive only the spec fields they consume; spec views are role-specific; context minimization per dispatch

### Additional Requirements

- No starter template needed — this is a framework extension project; existing Claude Code Context Engineering Template is the foundation
- No new agents — extend existing 6 agents only (researcher, planner, architect, implementer, reviewer, tester) per ADR-002
- CLAUDE.md kernel must remain under 200 lines — all SDD logic lives in skills and agent definitions
- Spec immutability — specs are immutable once ratified; changes require formal amendment; in-progress tasks continue against old version (Slice 3+)
- Agent ownership boundaries — no agent modifies another agent's output files; planner writes specs, implementer writes code, reviewer writes reviews
- Failure recovery matrix — 5 explicit failure paths: malformed YAML (retry+fallback), assertion failure (circuit breaker), feature stall (re-spec), tracker corruption (git recovery), missing spec (treat as TRIVIAL)
- Forgiving parser fallback — malformed spec YAML gets 1 lint-retry cycle + forgiving parser fallback before marking BLOCKED
- Git-based recovery — feature tracker recoverable via git checkout if JSON becomes corrupted; graceful degradation to non-SDD mode
- Spec packet delimiters — `--- SPEC ---` and `--- END SPEC ---` markers required for forgiving parser
- Dispatch prompt consistency — always reference "spec packet in task description", never paste spec into dispatch prompt to avoid duplication (Pattern 5)
- Governance cascade precedence — constitution.md > spec-protocol.md > skills > agent freedom; lower-numbered layers win conflicts
- Schema versioning from Slice 1 — version field required in every spec packet; additive-only field changes across slices

### FR Coverage Map

| FR | Epic | Description |
|----|------|-------------|
| FR1 | Epic 2 | Graduated spec format router (TRIVIAL/SIMPLE/MODERATE/COMPLEX) |
| FR2 | Epic 1 | YAML spec packet format definition |
| FR3 | Epic 1 | Controlled vocabulary (MUST/SHOULD/MAY/MUST NOT) |
| FR4 | Epic 1 | Assertion quality gate — specific observables required |
| FR5 | Epic 1 | 7x7 constraint (max 7 tasks/feature, 7 assertions/task) |
| FR6 | Epic 2 | Spec packets inline in TaskList task descriptions |
| FR7 | Epic 2 | Spec overview documents per feature |
| FR8 | Epic 2 | SDD detection via spec-protocol.md file presence |
| FR9 | Epic 2 | 3 CLAUDE.md modifications for SDD dispatch |
| FR10 | Epic 2 + 4 | Lifecycle states: 3-state (Epic 2), 6-state (Epic 4) |
| FR11 | Epic 2 | Implementer evidence reporting with file:line references |
| FR12 | Epic 3 | Feature tracker JSON index |
| FR13 | Epic 4 | Two-layer verification pipeline |
| FR14 | Epic 5 | Agent extensions (planner, reviewer, tester) |

| FR15 | Epic 6 | Cross-agent Trace ID for debugging and failure tracing |
| FR16 | Epic 6 | Complexity escalation protocol (implementer → dispatch loop) |
| FR17 | Epic 6 | Mandatory failure-pattern consultation + reviewer capture loop |
| FR18 | Epic 6 | System health circuit breakers (cascade, dispatch loop, plan explosion) |
| FR19 | Epic 6 | Reasoning strategy selector (planner + architect) |

NFRs are cross-cutting and enforced across all epics: token discipline (NFR1), backward compatibility (NFR2), zero-code (NFR3), incremental adoption (NFR4), agent isolation (NFR5).

## Epic List

### Epic 1: Spec Protocol Foundation
The user has a complete, authoritative spec authoring reference that defines how to write, structure, and validate specs for any task complexity tier.
**FRs covered:** FR2, FR3, FR4, FR5
**Deliverable:** `.claude/skills/spec-protocol.md`
**Slice:** 1

### Epic 2: End-to-End Spec Execution Pipeline
Agents execute tasks from inline YAML specs with verifiable assertions. The dispatch loop detects SDD mode, classifies spec tiers, and routes accordingly — graduating from user-driven to spec-driven execution.
**FRs covered:** FR1, FR6, FR7, FR8, FR9, FR10, FR11
**Deliverables:** CLAUDE.md modifications (+3 lines), spec overview naming convention active, inline spec packets in TaskList
**Slice:** 1

### Epic 3: Feature Tracking & Session Continuity
Project progress survives context resets. A JSON feature tracker provides feature-level status visible from files alone — answering "where are we?" without replaying history.
**FRs covered:** FR12
**Deliverable:** `planning-artifacts/feature-tracker.json` + planner creates entries, dispatch loop updates phase/verified
**Slice:** 2

### Epic 4: Automated Quality Governance
Automated verification (lint, assertions, file audit) catches spec violations before agent review. Expanded lifecycle states enforce formal quality gates. Optional constitution provides immutable project principles.
**FRs covered:** FR13, FR10 (expanded 6-state lifecycle)
**Deliverables:** Two-layer verification pipeline, graduated escalation, constitution.md (optional), failure-patterns.md
**Slice:** 3

### Epic 5: Agent Specialization & Scale
Agents gain permanent spec expertise — planner authors specs natively, reviewer validates specs, tester executes assertions independently. Reusable spec templates accelerate authoring for common patterns.
**FRs covered:** FR14
**Deliverables:** Extended planner.md, reviewer.md, tester.md; optional spec-templates/ directory
**Slice:** 4

### Epic 6: Observability & Resilience
Cross-agent traceability, runtime resilience, and adaptive reasoning — closing principle gaps identified in the 40-principles assessment without adding runtime infrastructure.
**FRs covered:** FR15, FR16, FR17, FR18, FR19
**Deliverables:** Trace ID convention (all agents + dispatch), complexity escalation protocol (implementer), mandatory failure-pattern loop (planner + reviewer + CLAUDE.md), system health checks (CLAUDE.md), reasoning strategy selector (planner + architect)
**Slice:** 5

---

## Epic 1: Spec Protocol Foundation

The user has a complete, authoritative spec authoring reference that defines how to write, structure, and validate specs for any task complexity tier.

### Story 1.1: Define Spec Packet YAML Format

As a planner agent,
I want a documented YAML spec packet format with required fields and delimiters,
So that I can author machine-parseable, consistent specs for any task.

**Acceptance Criteria:**

**Given** spec-protocol.md exists in `.claude/skills/`
**When** a planner reads the spec format section
**Then** it contains the exact YAML structure with fields: version, intent, assertions (id, positive, negative), constraints, file_scope
**And** spec packets are delimited by `--- SPEC ---` and `--- END SPEC ---` markers
**And** a filled example is provided for each tier (TRIVIAL skip, SIMPLE ~60 tokens, MODERATE full, COMPLEX full + overview reference)

### Story 1.2: Define Controlled Vocabulary & Assertion Quality Gate

As a planner agent,
I want clear rules for assertion language and controlled vocabulary,
So that every spec I author is unambiguous and verifiable.

**Acceptance Criteria:**

**Given** spec-protocol.md contains a controlled vocabulary section
**When** a planner reads the vocabulary rules
**Then** it defines MUST, MUST NOT, SHOULD, MAY with precise semantics (RFC 2119 style)
**And** the assertion quality gate explicitly bans "works," "correct," "proper," "appropriate" without a specific observable
**And** every assertion must name a specific observable: an endpoint, file, UI element, return value, or error code
**And** examples of valid and invalid assertions are provided

### Story 1.3: Define Constraints, Governance Seed & 7x7 Rule

As a project lead,
I want the spec protocol to include structural constraints and a lightweight governance seed,
So that specs stay focused and the system has foundational principles from day one.

**Acceptance Criteria:**

**Given** spec-protocol.md contains a constraints and governance section
**When** a planner reads the constraints
**Then** the 7x7 rule is documented: max 7 tasks per feature, max 7 assertions per task
**And** a governance seed section contains 5-10 lightweight project principles
**And** the graduated tier definitions are documented: TRIVIAL (no spec), SIMPLE (4 required fields, ~60 tokens), MODERATE (full spec + overview), COMPLEX (architect pre-check + spec suite)
**And** the governance cascade precedence is stated: constitution.md > spec-protocol.md > skills > agent freedom

---

## Epic 2: End-to-End Spec Execution Pipeline

Agents execute tasks from inline YAML specs with verifiable assertions. The dispatch loop detects SDD mode, classifies spec tiers, and routes accordingly — graduating from user-driven to spec-driven execution.

### Story 2.1: SDD Detection & Dispatch Loop Integration

As a main agent (dispatch loop),
I want to detect SDD mode via file presence and route tasks through spec-aware classification,
So that SDD activates automatically when spec-protocol.md exists without breaking non-SDD projects.

**Acceptance Criteria:**

**Given** the dispatch loop reads CLAUDE.md
**When** `.claude/skills/spec-protocol.md` exists
**Then** SDD mode is active and Step 4 classifies both model AND spec_tier (TRIVIAL/SIMPLE/MODERATE/COMPLEX)
**And** when spec-protocol.md is absent, the dispatch loop behaves identically to the original template
**And** CLAUDE.md remains under 200 lines after modifications
**And** Step 2 modification is added: "If no tasks AND spec-protocol.md exists AND feature-tracker.json has unverified features → dispatch planner to spec next feature"
**And** Step 6 modification is added: "If NEEDS_RESPEC → dispatch planner to re-spec affected subtree"

### Story 2.2: Graduated Spec Tier Router

As a main agent,
I want a graduated complexity router that classifies tasks into spec tiers and routes accordingly,
So that trivial tasks have zero overhead while complex tasks get full spec treatment.

**Acceptance Criteria:**

**Given** SDD mode is active and a new task needs classification
**When** the dispatch loop evaluates task complexity
**Then** TRIVIAL tasks are dispatched directly with no spec (zero overhead)
**And** SIMPLE tasks trigger planner to write a minimal spec packet (~60 tokens, 4 required fields) inline in task description
**And** MODERATE tasks trigger planner to write full spec packet + spec overview document
**And** COMPLEX tasks trigger architect pre-check before planner writes spec suite + overview
**And** the router extends (not replaces) the existing model selection in Step 4

### Story 2.3: Inline Spec Packet Delivery via TaskList

As a planner agent,
I want to embed YAML spec packets directly in TaskList task descriptions,
So that implementers receive specs automatically via TaskGet with zero extra file reads.

**Acceptance Criteria:**

**Given** a planner has been dispatched to spec a SIMPLE+ task
**When** the planner creates the task via TaskCreate
**Then** the task description contains a YAML spec packet delimited by `--- SPEC ---` and `--- END SPEC ---`
**And** the spec packet follows the exact format from spec-protocol.md (Pattern 1)
**And** the implementer can read the full spec via TaskGet without any additional Read calls
**And** the dispatch prompt references "spec packet in task description" (never pastes the spec)

### Story 2.4: Spec Overview Documents

As a project lead,
I want human-readable spec overview documents created per feature,
So that I can review feature-level scope and acceptance criteria without parsing YAML.

**Acceptance Criteria:**

**Given** a planner is speccing a MODERATE or COMPLEX feature
**When** the planner creates the spec overview
**Then** it is saved at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`
**And** the overview contains: feature title, goal summary, task list with IDs, acceptance criteria summary
**And** feature IDs follow the pattern F-001, F-002 (zero-padded 3 digits)
**And** task IDs follow the pattern T-001, T-002 (globally unique across features)

### Story 2.5: Spec Lifecycle States & Evidence Reporting

As an implementer agent,
I want clear lifecycle states and a structured evidence reporting format,
So that I know when a task transitions from DRAFT to ACTIVE to DONE and how to prove assertion compliance.

**Acceptance Criteria:**

**Given** a task with an embedded spec packet is dispatched to an implementer
**When** the implementer completes the task
**Then** every assertion ID from the spec packet appears in the results section
**And** each result follows the format: `{id}: PASS|FAIL — {file}:{line} ({brief evidence})`
**And** FAIL results include what was expected vs what happened
**And** missing assertion results mean the task is NOT DONE
**And** the spec transitions DRAFT → ACTIVE (on dispatch) → DONE (all assertions PASS)

---

## Epic 3: Feature Tracking & Session Continuity

Project progress survives context resets. A JSON feature tracker provides feature-level status visible from files alone — answering "where are we?" without replaying history.

### Story 3.1: Feature Tracker JSON Schema & Initialization

As a main agent starting a new session,
I want a JSON feature tracker that I can read to reconstruct project state,
So that I can answer "where are we?" without replaying conversation history.

**Acceptance Criteria:**

**Given** a planner creates a new feature
**When** the planner writes to `planning-artifacts/feature-tracker.json`
**Then** each entry contains fields in this exact order: id, title, phase, spec_overview, tasks[], verified
**And** `phase` uses Slice 1 values: DRAFT | ACTIVE | DONE
**And** `tasks` references TaskList task IDs
**And** `verified` is false until ALL task assertions pass
**And** the file is valid JSON parseable by any standard parser

### Story 3.2: Tracker State Transitions & Recovery

As a dispatch loop,
I want the feature tracker to update automatically as tasks progress and recover gracefully from corruption,
So that project state is always accurate and the system never gets permanently stuck.

**Acceptance Criteria:**

**Given** the dispatch loop processes task results
**When** all tasks for a feature report PASS on all assertions
**Then** the dispatch loop flips `verified` to true and `phase` to DONE
**And** only the planner creates tracker entries; only the dispatch loop updates phase and verified
**And** if feature-tracker.json fails to parse, the system degrades gracefully to non-SDD mode
**And** the tracker is recoverable via `git checkout` if corrupted
**And** a feature with 3+ BLOCKED tasks is flagged for re-spec

---

## Epic 4: Automated Quality Governance

Automated verification (lint, assertions, file audit) catches spec violations before agent review. Expanded lifecycle states enforce formal quality gates. Optional constitution provides immutable project principles.

### Story 4.1: Two-Layer Automated Verification Pipeline

As a dispatch loop,
I want automated verification gates (spec lint, assertion audit, file scope check) that run before dispatching a reviewer,
So that 80% of spec violations are caught at 5% of the cost of agent review.

**Acceptance Criteria:**

**Given** an implementer completes a task with a spec packet
**When** the post-task verification runs
**Then** spec lint validates YAML structure and required fields in the spec packet
**And** assertion audit confirms every assertion ID has a result (PASS or FAIL with evidence)
**And** file scope audit verifies the implementer only modified files listed in `file_scope`
**And** failures at the automated layer block reviewer dispatch with a specific error
**And** the implementer gets one retry cycle before the task is marked BLOCKED

### Story 4.2: Expanded Lifecycle States & Graduated Escalation

As a project lead,
I want formal lifecycle states with quality gates at each transition and graduated escalation for failures,
So that spec integrity is enforced progressively and problems surface early.

**Acceptance Criteria:**

**Given** SDD mode is active with governance enabled
**When** a spec moves through its lifecycle
**Then** it follows: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
**And** each transition has a defined gate (lint passes, reviewer approves, all assertions pass, feature-level check)
**And** graduated escalation applies: Green (all pass) → Yellow (minor issues) → Orange (major issues, reviewer escalation) → Red (BLOCKED, user escalation)
**And** the spec-level circuit breaker halts a feature after 3 consecutive BLOCKED tasks

### Story 4.3: Optional Constitution & Failure Pattern Library

As a project lead,
I want an optional constitution with immutable principles and a failure pattern library that captures lessons learned,
So that governance scales with project maturity and past mistakes aren't repeated.

**Acceptance Criteria:**

**Given** the project has reached governance maturity (post Slice 2)
**When** a `planning-artifacts/constitution.md` is created
**Then** it contains formal articles defining immutable project principles with Phase -1 gates
**And** the governance cascade applies: constitution.md > spec-protocol.md > skills > agent freedom
**And** `planning-artifacts/knowledge-base/failure-patterns.md` captures categorized failure patterns with root cause and resolution
**And** constitution is optional — SDD functions fully without it
**And** only humans can amend the constitution (formal amendment protocol)

---

## Epic 5: Agent Specialization & Scale

Agents gain permanent spec expertise — planner authors specs natively, reviewer validates specs, tester executes assertions independently. Reusable spec templates accelerate authoring for common patterns.

### Story 5.1: Planner Agent Spec Authoring Extension

As a planner agent,
I want permanent spec authoring capability built into my agent definition,
So that I author specs natively without consuming the spec-protocol.md skill each time.

**Acceptance Criteria:**

**Given** planner.md is extended with spec authoring responsibility
**When** the planner is dispatched to create a feature
**Then** it natively authors spec packets following Pattern 1 format
**And** it creates spec overview documents following Pattern 3 naming
**And** it creates feature tracker entries following Pattern 4 format
**And** it performs gap detection — identifying missing requirements or ambiguous criteria before speccing
**And** the planner only specs the next 3-5 tasks (just-in-time decomposition), not the entire DAG

### Story 5.2: Reviewer Spec Review Mode

As a reviewer agent,
I want a spec review mode that validates spec quality alongside code quality,
So that I catch spec-level issues (vague assertions, missing observables, scope violations) during review.

**Acceptance Criteria:**

**Given** reviewer.md is extended with spec review mode
**When** the reviewer is dispatched in spec review mode
**Then** it validates assertion evidence matches actual code changes (file:line references are accurate)
**And** it checks that all assertions use controlled vocabulary and name specific observables
**And** it verifies file_scope was respected — no modifications outside listed files
**And** it provides structured feedback per the existing reviewer protocol (STATUS: APPROVED | NEEDS_CHANGES | BLOCKED)

### Story 5.3: Tester Assertion Execution & Integration Modes

As a tester agent,
I want assertion execution mode and integration verification mode,
So that I can independently verify implementer claims and check feature-level integration.

**Acceptance Criteria:**

**Given** tester.md is extended with two new modes
**When** dispatched in assertion execution mode
**Then** the tester independently re-executes each assertion from the spec packet against the actual codebase
**And** results are compared against implementer-reported evidence
**And** discrepancies are flagged as NEEDS_INVESTIGATION
**When** dispatched in integration verification mode
**Then** the tester checks feature-level assertions from the spec overview
**And** verifies cross-task interactions work correctly
**And** reports integration results per feature ID

### Story 5.4: Reusable Spec Templates (Optional)

As a project lead,
I want reusable spec templates for common patterns (REST CRUD, auth flows, data pipelines),
So that spec authoring for common feature types is faster and more consistent.

**Acceptance Criteria:**

**Given** `.claude/spec-templates/` directory exists
**When** a planner is speccing a feature matching a known pattern
**Then** it can reference a template as a starting point (e.g., `rest-crud-endpoint.yaml`)
**And** templates contain pre-filled assertions, file_scope patterns, and constraints for the pattern
**And** templates are optional — SDD functions fully without them
**And** the planner adapts templates to the specific feature, never copies blindly

---

## Epic 6: Observability & Resilience

Cross-agent traceability, runtime resilience, and adaptive reasoning — closing principle gaps identified in the 40-principles assessment without adding runtime infrastructure. All changes are pure markdown additions consistent with the zero-code constraint (NFR3) and the 200-line CLAUDE.md limit.

### Story 6.1: Cross-Agent Trace ID Convention

As the main agent and all subagents,
I want a Trace ID generated at every dispatch and included in every artifact,
So that cross-agent failures can be diagnosed by grepping a single ID across all artifact files.

**Closes:** Principle gaps #9 (Safe and Debuggable Agent Loop) and #33 (Debugging Failures Across Interacting Agents).

**Acceptance Criteria:**

**Given** the dispatch loop executes Step 5
**When** a task is dispatched to any agent
**Then** a `TRACE-{YYYY-MM-DD}-{HHmm}-{3-word-slug}` ID is generated and passed as part of task context
**And** every agent artifact includes a `**Trace:**` header field with the received Trace ID
**And** reviewer feedback format includes `TRACE:` at the top and `UPSTREAM_TRACE:` on every CRITICAL issue
**And** tester report headers include `**Trace:**` and every failure entry includes `**Upstream Trace:**`
**And** timeline reconstruction requires no tooling — a grep across artifacts/ directories returns a complete ordered timeline

### Story 6.2: Reflection Memory Loop

As the planner agent and dispatch loop,
I want failure-patterns.md to be mandatorily consulted before speccing and automatically updated after CRITICAL reviews,
So that the system learns from past failures without requiring manual curation.

**Closes:** Principle gap #29 (Memory Structure for Reflection and Self-Improvement).

**Acceptance Criteria:**

**Given** `planning-artifacts/knowledge-base/failure-patterns.md` exists
**When** the planner begins speccing a feature
**Then** it MUST search failure-patterns.md for domain matches — this is not advisory
**And** for each matching pattern: either add a spec constraint preventing recurrence, or document why the pattern does not apply
**When** a review results in NEEDS_CHANGES or BLOCKED with at least one CRITICAL issue
**Then** the reviewer outputs a `## New Failure Patterns` section (Pattern, Trigger, Prevention, Task Ref)
**And** the dispatch loop appends these entries to failure-patterns.md
**And** the reviewer remains read-only — no Write tool access required

### Story 6.3: Complexity Escalation Protocol

As the implementer agent and dispatch loop,
I want a structured escalation path when a task's actual complexity exceeds its classification,
So that mis-classified tasks re-route rather than producing forced bad implementations.

**Closes:** Principle gap #16 (Reactive vs Deliberative Architecture — dynamic switching heuristics).

**Acceptance Criteria:**

**Given** an implementer is executing a task
**When** it discovers the task is significantly more complex than classified (e.g., >5 files required, hidden dependency cycles)
**Then** it stops, writes an ESCALATED partial note with: Original Classification, Discovered Complexity, Recommendation (RESPEC | SPLIT | ARCHITECT_REVIEW)
**And** it sets the task to BLOCKED with reason: `Complexity escalation — {summary}`
**And** the dispatch loop re-classifies the task (Step 4) and re-dispatches based on the Recommendation
**And** a task may only be escalated once — a second discovery proceeds with best effort and MAJOR flags

### Story 6.4: System Health Circuit Breakers

As the main agent dispatch loop,
I want system-level health checks that detect pathological multi-agent interaction patterns,
So that cascade failures, infinite dispatch loops, and plan explosions are caught before wasting resources.

**Closes:** Principle gap #32 (Emergent Behaviors in Multi-Agent Systems).

**Acceptance Criteria:**

**Given** the dispatch loop has completed 10 tasks
**When** system health checks run
**Then** if >3 tasks are simultaneously BLOCKED, dispatch pauses and user receives a summary before continuing
**And** if the same task ID has been dispatched >5 times, it is marked BLOCKED and escalated with full dispatch history
**And** if a single planning dispatch created >15 tasks, those tasks are flagged for user review before any are dispatched
**And** all checks use TaskList data already read at Step 1 — no new state tracking required

### Story 6.5: Reasoning Strategy Selector

As the planner and architect agents,
I want explicit guidance on when to use Linear, Branching, and Graph reasoning strategies,
So that complex problems are approached with the appropriate reasoning mode rather than always defaulting to sequential thinking.

**Closes:** Principle gap #14 (Chain-of-Thought vs Tree-of-Thought vs Graph Planning).

**Acceptance Criteria:**

**Given** planner.md and architect.md contain a `## Reasoning Strategy Selection` section
**When** an agent begins analysis
**Then** it selects from: Linear (CoT) for clear single-path problems, Branching (ToT) for multi-option comparison, Graph for interdependent/cyclic constraint problems
**And** the default is Linear unless ambiguity signals are present (keywords: "evaluate", "compare", "trade-off"; multiple valid architectures; conflicting constraints)
**And** the section is lightweight guidance (<15 lines per agent), not a prescriptive decision tree
