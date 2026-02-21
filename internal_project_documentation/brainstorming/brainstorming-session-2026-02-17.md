---
stepsCompleted: [1, 2, 3, 4]
session_active: false
workflow_completed: true
inputDocuments:
  - further_sdd.md
  - README.md
  - CLAUDE.md
session_topic: 'SDD orchestration principles — designing architecture that transforms user-driven dispatch into spec-driven autonomous execution'
session_goals: 'Generate breakthrough ideas for spec format, execution pipeline, verification loop, and session continuity — beyond Automaker, Anthropic, and Spec Kit'
selected_approach: 'ai-recommended'
techniques_used: ['Assumption Reversal', 'Morphological Analysis', 'Cross-Pollination']
ideas_generated: 100
ideas_by_technique:
  assumption_reversal: 8
  morphological_analysis: 5
  cross_pollination: 87
ideas_by_category:
  spec_format_structure: 18
  execution_pipeline: 16
  verification_quality: 19
  clarification_assumptions: 6
  session_continuity_tracking: 8
  agent_coordination: 12
  governance_meta_integration: 21
cross_pollination_domains: 38
context_file: 'further_sdd.md'
phase_decision: 'Phase 1 (standard spec-first) prioritized; Phase 2 (radical spec-by-discovery) deferred'
---

# Brainstorming Session Results

**Facilitator:** Andrey
**Date:** 2026-02-17

## Session Overview

**Topic:** SDD orchestration principles — designing the architecture that transforms the current "user-driven dispatch" model into a spec-driven autonomous execution system where agents work from structured specifications without continuous human guidance.

**Goals:** Generate breakthrough ideas for how specs should be structured, consumed, decomposed, executed, verified, and evolved by a multi-agent system — going beyond what Automaker, Anthropic's demo, and Spec Kit have done.

### Context Guidance

_Three reference systems analyzed: Automaker (XML spec + Kanban + auto-mode), Anthropic's Autonomous Coding Demo (feature_list.json + session loop + Puppeteer), and GitHub Spec Kit (constitution + 6-step pipeline + NEEDS CLARIFICATION markers). 15 concrete ideas already catalogued. The core gap: template has best orchestration but no structured spec format for autonomous execution._

### Session Setup

_Complex architectural brainstorming requiring deep analytical techniques. User has extensive prior research and existing ideas — session must push beyond the obvious into novel territory. Three-phase approach: deconstruct assumptions → map parameter space → import from foreign domains._

### Key Decision: Two-Phase Approach

**Phase 1 (this session):** Standard spec-first architecture — structured specifications drive autonomous agent execution within the existing template architecture.

**Phase 2 (deferred):** Radical spec-by-discovery — specs emerge from implementation rather than preceding it.

## Technique Selection

**Approach:** AI-Recommended Techniques
**Analysis Context:** SDD orchestration architecture with focus on breakthrough ideas beyond existing reference systems

**Recommended Techniques:**

- **Assumption Reversal (deep):** Flip core assumptions from Automaker, Anthropic, and Spec Kit to expose hidden design space and blind spots none of them addressed.
- **Morphological Analysis (deep):** Systematically map all parameter combinations across 6+ dimensions (spec format, decomposition, execution, verification, continuity, coordination) to find combinatorial breakthroughs.
- **Cross-Pollination (creative):** Import patterns from compiler design, manufacturing, biology, military C2, and other domains to produce ideas 50-100 that nobody in the AI-agent space is considering.

**AI Rationale:** Session requires pushing past 15 existing ideas into genuinely novel territory. Deconstruct → Map → Import sequence ensures we first break free of anchoring bias, then exhaustively explore the design space, then bring in entirely foreign perspectives. Target: 60-100+ ideas.

---

## Technique Execution: Complete Idea Inventory

### Phase 1: Assumption Reversal (Ideas #1–#8)

**#1. Graduated Spec Format Router**
_Category: Spec Format & Structure_
Extend the existing complexity classifier (CLAUDE.md Step 4) from model-only routing to a multi-output switch that also selects spec format, planning depth, and verification rigor. Add TRIVIAL tier for zero-spec direct dispatch. TRIVIAL = no spec, SIMPLE = micro-spec (3 fields), MODERATE = full structured spec, COMPLEX = spec suite with constitution gates, data contracts, risk register.

**#2. Hybrid Spec — Overview + Distributed Per-Task Criteria**
_Category: Spec Format & Structure_
Extend the planner to produce a human-readable spec overview document AND embed acceptance criteria directly into each task description. Agents consume per-task specs (context-minimal); humans and architects review the overview (big-picture). The spec overview is the source of truth for humans; per-task criteria are the source of truth for agents.

**#3. Planner as Spec Agent (No New Agent Needed)**
_Category: Agent Coordination_
Instead of adding a new spec-writer agent, extend the existing planner with spec-writing capability. The planner already decomposes goals into DAGs; now it also attaches acceptance criteria, edge cases, and NEEDS CLARIFICATION markers to each task. One agent, one pass, two outputs. Avoids agent proliferation.

**#4. Executable Acceptance Criteria (Criteria-as-Tests)**
_Category: Spec Format & Structure_
Planner writes acceptance criteria as machine-executable assertions attached to each task, not prose descriptions. The tester/verifier agent executes them directly without interpretation. Closes the gap between "what is done?" and "how do I verify?" to zero.

**#5. Inline Verification (TDD Dispatch Protocol)**
_Category: Verification & Quality_
Implementer receives executable assertions with the task and runs them during implementation, not after. Self-reports DONE only when all assertions pass. Reviewer scope narrows to quality/style/security — correctness already proven. Reduces worker-reviewer cycles from 3 max to typically 1.

**#6. Tiered Clarification Resolution (Auto-Resolve Before Escalate)**
_Category: Clarification & Assumptions_
Planner tags each NEEDS CLARIFICATION with a resolution strategy: RESEARCH (dispatch researcher), ARCHITECT (dispatch architect against constitution), CODEBASE (grep/glob), or HUMAN (escalate to user). The dispatch loop auto-resolves the first three, only blocking on HUMAN. Reduces human bottleneck by 60-80%.

**#7. Hierarchical Feature Tracker (Tree, Not List)**
_Category: Session Continuity & Tracking_
Replace flat feature tracking with a hierarchical structure: Project → Features → Tasks → Assertions. Feature-level verification = all child tasks verified. Enables rollup progress, feature-level autonomous mode decisions, and clear "definition of done" at every level.

**#8. Zero-Handoff Session Continuity**
_Category: Session Continuity & Tracking_
Eliminate the need for explicit session handoff documents. The hierarchical feature tracker + per-task assertion results + spec overviews + decisions.md already encode complete project state. New session = read tracker, find first unverified, resume. The dispatch loop IS the continuity protocol.

### Phase 2: Morphological Analysis (Ideas #9–#13)

**#9. The Autonomous Continuation Combo**
_Category: Execution Pipeline | Dimensions: Trigger=tracker gap + Continuity=zero-handoff + DAG Evolution=continuous refinement_
The dispatch loop reads the hierarchical feature tracker, finds the next unverified feature, checks if a spec+DAG exists — if not, dispatches planner to create one. After every 5 tasks, planner re-evaluates remaining DAG. No human needed between features. The system specs, plans, executes, verifies, and advances autonomously.

**#10. The Assumption-Tracking Combo**
_Category: Clarification & Assumptions | Dimensions: Clarification=deferred with assumptions + Verification=layered + DAG Evolution=assertion-driven replan_
When the planner encounters ambiguity, it states an assumption and continues. The implementer codes against the assumption. The reviewer validates assumptions. If assumption proves wrong (assertions fail), assertion-driven replan triggers re-spec of affected tasks only. Assumptions become typed objects: `{assumption, confidence, validator, fallback}`.

**#11. The Parallel Spec Authoring Combo**
_Category: Agent Coordination | Dimensions: Authoring=collaborative multi-agent + Granularity=COMPLEX + Clarification=tiered auto-resolve_
For COMPLEX features, fan-out three agents in parallel: researcher gathers tech context, architect validates against constitution, planner drafts spec structure. Planner synthesizes all three inputs into spec overview + per-task criteria in one pass. Parallelizes spec creation using existing fan-out pattern.

**#12. The Self-Healing DAG Combo**
_Category: Verification & Quality | Dimensions: Verification=layered + DAG Evolution=assertion-driven replan + Tracker=hierarchical_
When 3+ assertion failures cluster around a shared dependency, the dispatch loop detects the pattern in the hierarchical tracker, flags the parent feature, and dispatches planner to re-spec only the affected subtree. Unaffected branches continue executing in parallel. Surgical DAG repair.

**#13. The Constitution Gate Combo**
_Category: Governance | Dimensions: Authoring=multi-agent + Granularity=COMPLEX + Verification=layered_
For COMPLEX tiers, architect agent validates spec against constitution BEFORE planner creates the DAG. Constitution gates become executable assertions. If constitution gates fail, spec is rejected back to planner before any implementation begins.

### Phase 3: Cross-Pollination (Ideas #14–#100)

#### Domain: Compiler Design

**#14. The Compiler Pipeline Pattern**
_Category: Execution Pipeline_
Model the SDD pipeline as a compiler: user goal = source code, spec = AST, task DAG = intermediate representation (IR), implementation = code generation, verification = test suite. The task DAG with embedded criteria is the IR where all optimization happens. Planner acts as "optimizer pass" — can reorder, merge, parallelize, and eliminate redundant tasks.

#### Domain: Manufacturing (Toyota Production System)

**#15. Pull-Based Dispatch**
_Category: Execution Pipeline_
Flip from push-based dispatch to pull-based: agents signal readiness, dispatch loop assigns next matching task. Zero idle time. "Andon cord" = any agent can flag BLOCKED and halt the dependent chain without waiting for the circuit breaker.

#### Domain: Biology (DNA/RNA/Protein)

**#16. Immutable Spec + Read-Only Task Copies**
_Category: Governance_
The spec overview is DNA — immutable once approved. Per-task criteria are RNA — read-only working copies. Implementers never modify the spec or criteria. If the spec needs to change, it goes through a formal "mutation" process: planner re-specs, architect validates, new criteria distributed.

#### Domain: Military C2

**#17. Mission-Type Specs (Commander's Intent Pattern)**
_Category: Spec Format & Structure_
Each task spec contains two layers: Commander's Intent (the outcome, non-negotiable) and Freedom of Action (what the agent decides independently). Explicitly separates intent (immutable) from freedom (delegated). Example: intent = "Users can authenticate with email/password and receive JWT"; freedom = "Choose middleware, session strategy, error format."

#### Domain: Air Traffic Control

**#18. Conflict Detection in Parallel Execution**
_Category: Agent Coordination_
When fan-out dispatches parallel agents, add a "conflict detection" pass: planner scans all parallel tasks for shared file dependencies, shared model modifications, or overlapping API routes. Conflicting tasks get sequenced; clean tasks run parallel. Automates the "must NOT modify same files" constraint.

#### Domain: Version Control (Git)

**#19. Spec Branching (Explore Before Committing)**
_Category: Governance_
For COMPLEX features with high uncertainty, the planner creates 2-3 spec branches — alternative decompositions of the same goal. Architect evaluates each against constitution + constraints. Winning branch gets "merged" into the feature tracker; losing branches preserved for reference.

#### Domain: Contract Law

**#20. Spec-as-Contract with Amendment Protocol**
_Category: Governance_
Formalize the spec as a legal-style contract with: Parties (which agents are bound), Deliverables (assertions), Acceptance (verification mechanism), Amendment Process (how changes are proposed/reviewed/approved), Breach (what happens when an agent violates the spec — revert + re-spec).

**#21. Escape Clauses (Graceful Spec Abandonment)**
_Category: Governance_
Every spec includes explicit escape clauses: conditions under which the spec should be abandoned rather than forced through. Example: "If implementation requires >5 new dependencies, STOP and re-spec." Prevents agents from heroically completing a bad spec.

#### Domain: Distributed Databases (Raft/Paxos)

**#22. Consensus-Based Spec Approval**
_Category: Clarification & Assumptions_
For COMPLEX specs, require multi-agent consensus before execution. Fan-out: researcher validates feasibility, architect validates design, planner validates decomposability. Each returns APPROVE/REJECT/ABSTAIN. Spec proceeds only with 2/3 approval.

**#23. Eventual Consistency for Parallel Features**
_Category: Agent Coordination_
When multiple features execute in parallel, allow controlled overlap in shared files and add a reconciliation agent pass after completion. Relaxes the strict no-overlap constraint with a formal reconciliation step, enabling more parallelism.

#### Domain: Game Design

**#24. The Spec Execution Game Loop**
_Category: Execution Pipeline_
Formalize the dispatch loop as an explicit state machine: IDLE → SPEC_NEEDED → SPECCING → SPEC_REVIEW → PLANNING → EXECUTING → VERIFYING → FEATURE_DONE → IDLE. Each phase has explicit entry/exit conditions and failure transitions. Makes the autonomous pipeline debuggable.

**#25. Difficulty Scaling (Adaptive Complexity)**
_Category: Governance_
If the implementer consistently passes assertions on first try, the planner reduces spec detail for subsequent tasks. If assertions fail repeatedly, planner increases spec detail. The system learns the optimal spec granularity for the current project's complexity.

#### Domain: Supply Chain Management

**#26. Full Traceability Chain**
_Category: Verification & Quality_
Every line of code traces back to a specific assertion, which traces to a task, which traces to a spec requirement. Bidirectional traceability: from any code line → assertion → task → spec AND back.

**#27. Just-In-Time Spec Decomposition**
_Category: Execution Pipeline_
Instead of fully decomposing the entire spec into a DAG upfront, spec the next 3-5 tasks in detail, leave the rest as "planned but not specced." As tasks complete and new information emerges, spec the next batch with updated context.

#### Domain: Music Composition

**#28. Spec Orchestration Score (Agent-Specific Views)**
_Category: Agent Coordination_
The planner produces agent-specific "parts" — each agent sees only what it needs. Implementer sees: task intent, assertions, file scope, freedom. Reviewer sees: assertions, constitution constraints, security checklist. Same underlying spec, different views per role.

**#29. Tempo Control (Execution Speed Governance)**
_Category: Execution Pipeline_
Add explicit pacing rules based on project phase. Early: slow tempo with more review, clarification, architect checks. Mid: normal tempo with standard dispatch. Late: fast tempo with minimal overhead.

#### Domain: Epidemiology

**#30. Bug Propagation Analysis**
_Category: Verification & Quality_
When an assertion fails, trace the "infection" — identify all tasks that share dependencies with the failed task. Flag them for re-verification even if previously passed. Catches cascading failures before they spread.

**#31. Herd Immunity Threshold**
_Category: Verification & Quality_
A feature doesn't need 100% of tasks verified to advance. If 80% of assertions pass and the remaining 20% are MINOR/isolated, the dispatch loop can advance while creating fix-tasks for remaining issues.

#### Domain: Education (Bloom's Taxonomy)

**#32. Progressive Spec Depth**
_Category: Execution Pipeline_
The first task in a feature is always an exploration task — the agent reads the codebase, understands existing patterns, writes an analysis. Only after this "learning" task does the planner create implementation tasks.

#### Domain: Accounting (Double-Entry Bookkeeping)

**#33. Double-Entry Spec Tracking**
_Category: Verification & Quality_
Every spec requirement has two entries: the assertion (what must be true) and the counter-assertion (what must NOT be true). Forces comprehensive testing — every behavior explicitly states what it excludes.

#### Domain: Cartography

**#34. Multi-Scale Spec Views**
_Category: Session Continuity & Tracking_
The spec exists at four zoom levels auto-generated from the same data: Project level (dashboard), Feature level (spec overview with rollup), Task level (per-task criteria), Assertion level (individual pass/fail with evidence).

#### Domain: Template's Own Architecture

**#35. Self-Discovering Spec Templates**
_Category: Governance_
Just as agents auto-discover by dropping .md files in `.claude/agents/`, spec templates auto-discover by dropping files in `.claude/spec-templates/`. Different project types get different templates.

**#36. Skill-Augmented Specs**
_Category: Governance_
When the planner creates a spec, it reads relevant skills (coding-standards.md, testing-strategy.md) and injects project-specific constraints into per-task criteria automatically. Skills become the "constitution" without needing a separate file.

**#37. Circuit Breaker at Spec Level**
_Category: Verification & Quality_
If 3+ tasks within the same feature hit BLOCKED status, the entire feature spec is flagged for re-evaluation. Planner re-specs with lessons learned. Circuit breaker elevated from task-level to feature-level.

**#38. Assertion Inheritance (Parent → Child)**
_Category: Spec Format & Structure_
In the hierarchical feature tracker, parent-level assertions automatically propagate to child tasks. Feature-level assertion "All API endpoints return proper error codes" gets inherited by every child task touching an API endpoint.

#### Domain: Restaurant Kitchen (Brigade System)

**#39. The Ticket System (Atomic Spec Units)**
_Category: Spec Format & Structure_
Model each task as a kitchen "ticket" — self-contained and atomic. A ticket NEVER says "see the full menu" — it has everything the agent needs. Atomicity test: "Can this task be executed in total isolation?"

**#40. The Expediter Pattern (Pre-Delivery Quality Gate)**
_Category: Verification & Quality_
Add an "expediter" pass between implementation and delivery. A fast, cheap comparison of task deliverables against spec intent, run on haiku. Catches "implemented the wrong thing entirely" at minimal token cost.

#### Domain: Immune System

**#41. Two-Layer Verification (Innate + Adaptive)**
_Category: Verification & Quality_
Layer 1 (innate): cheap, fast checks on every task — linting, type checking, assertion execution, file verification. Automated, no agent needed. Layer 2 (adaptive): expensive checks only when Layer 1 passes — reviewer for quality, architect for constitution. Layer 1 catches 80% of failures at 5% of the cost.

**#42. Immune Memory (Pattern Library from Past Failures)**
_Category: Governance_
When the system resolves a failure, write a pattern entry to `planning-artifacts/knowledge-base/failure-patterns.md`. Future planner runs check this library when creating specs and preemptively add constraints/assertions. Learning loop: failures → patterns → better specs → fewer failures.

#### Domain: Telecommunications (Packet Switching)

**#43. Spec Packets (Header + Payload + Checksum)**
_Category: Spec Format & Structure_
Formalize per-task spec as a packet: Header (task ID, feature parent, dependencies, agent type, tier), Payload (intent, assertions, freedom, constraints, file scope), Checksum (hash of spec content to detect if spec changed mid-execution).

**#44. Packet Reassembly (Feature Integration Pass)**
_Category: Verification & Quality_
When all tasks in a feature are individually verified, run feature-level integration assertions that test cross-task interactions. Individual task assertions test units; feature assertions test the assembled whole.

#### Domain: Thermodynamics

**#45. Entropy Detection (Spec Decay Monitoring)**
_Category: Session Continuity & Tracking_
Add an "entropy score" to each feature: how many of its assertions still pass if re-run? If score drops below threshold (70%), flag for re-verification or re-spec. Catches regressions from cross-feature side effects.

**#46. Energy Budget for Spec Operations**
_Category: Session Continuity & Tracking_
Assign explicit token budgets per feature by complexity tier: TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000. If a feature exceeds budget by 50%, flag it as misclassified or poorly decomposed.

#### Domain: Neural Architecture

**#47. Agent Specialization Profiles for Spec Consumption**
_Category: Agent Coordination_
Each agent definition includes a spec consumption profile — which spec fields it reads and which it ignores. The dispatch loop strips the spec to only needed fields before passing.

**#48. Working Memory Limit per Agent**
_Category: Spec Format & Structure_
Cap active assertions per task at 7 (cognitively-grounded). If a task needs more than 7 assertions, it must be decomposed further. Hard constraint in the spec template.

#### Domain: Film Production

**#49. The Dailies Review (Incremental Progress Visibility)**
_Category: Session Continuity & Tracking_
After every N tasks (say 5), auto-generate a brief progress summary appended to the spec overview. Lightweight, non-blocking progress visibility.

**#50. The Director's Cut vs Theatrical Release**
_Category: Verification & Quality_
For COMPLEX features, present the user with feature summary + key implementation decisions before marking DONE. User can accept (theatrical release) or request changes (director's cut). Lightweight human checkpoint only for complex features.

#### Domain: Synthesis

**#51. The Spec Template Itself (Concrete Format)**
_Category: Spec Format & Structure_
Lock down the actual YAML structure for per-task specs:

```yaml
intent: "What must be true when this task is done"
tier: SIMPLE | MODERATE | COMPLEX
assertions:
  - id: A1
    positive: "POST /login returns 200 with valid credentials"
    negative: "POST /login does NOT return 200 with invalid credentials"
    type: API | UNIT | INTEGRATION | MANUAL
freedom:
  - "Choose middleware framework"
  - "Choose error message format"
constraints:
  - "MUST use existing auth module"
  - "MUST NOT add new dependencies"
assumptions:
  - id: AS1
    statement: "Assuming bcrypt for password hashing"
    confidence: HIGH | MEDIUM | LOW
    resolver: RESEARCH | ARCHITECT | CODEBASE | HUMAN
file_scope:
  - src/auth/login.ts
  - src/auth/login.test.ts
escape_clause: "If >3 new dependencies required, STOP and re-spec"
parent_feature: F-001
checksum: sha256:abc123
```

Synthesis of ideas #2, #4, #10, #16, #17, #21, #33, #43 into one concrete format.

**#52. The Feature Tracker Schema (Concrete Format)**
_Category: Session Continuity & Tracking_
Lock down the hierarchical feature tracker:

```json
{
  "project": "project-name",
  "constitution_ref": "planning-artifacts/constitution.md",
  "features": [
    {
      "id": "F-001",
      "title": "User Authentication",
      "spec_overview": "planning-artifacts/specs/F-001-auth-overview.md",
      "phase": "EXECUTING",
      "tier": "MODERATE",
      "token_budget": 8000,
      "token_spent": 3200,
      "entropy_score": 0.95,
      "tasks": ["T-001", "T-002", "T-003"],
      "assertions_total": 12,
      "assertions_passing": 8,
      "herd_immunity_threshold": 0.8,
      "verified": false
    }
  ]
}
```

Synthesizes ideas #7, #31, #45, #46.

#### Domain: Ecology (Keystone Species)

**#53. Keystone Task Identification**
_Category: Governance_
Planner marks certain tasks as "keystone" — tasks that cascade to 3+ dependents if they fail. Keystone tasks get elevated treatment: COMPLEX-tier spec even if simple, mandatory architect pre-check, zero-tolerance on assertion failures.

**#54. Mutualism Between Agents (Shared Context Artifacts)**
_Category: Agent Coordination_
When any agent discovers something relevant, it writes a shared context artifact to `planning-artifacts/knowledge-base/`. All future agents can access it. Bidirectional knowledge flow — any agent contributes, all agents consume.

#### Domain: Chess (Opening Theory)

**#55. Spec Playbook (Reusable Spec Patterns)**
_Category: Spec Format & Structure_
Build a library of common spec patterns in `.claude/spec-templates/` with pre-written assertions, standard file scopes, common assumptions, and known edge cases per pattern type (rest-crud-endpoint.yaml, auth-flow.yaml, etc.).

**#56. Opening Book → Middlegame → Endgame Phases**
_Category: Execution Pipeline_
Model feature execution as three phases: Opening (first 30% — establish patterns, high spec detail, slow tempo, architect oversight), Middlegame (middle 50% — core implementation, normal tempo, parallel execution), Endgame (final 20% — integration, edge cases, feature assertions, entropy check, user checkpoint).

#### Domain: Linguistics

**#57. Spec Linting (Syntax) vs Spec Review (Semantics)**
_Category: Execution Pipeline_
Separate cheap automated "spec lint" (all fields present? positive+negative assertions? file scope exists? checksum computed?) from expensive semantic review by architect (intent matches assertions? constraints compatible? constitution violated?).

**#58. Spec Vocabulary (Controlled Language)**
_Category: Spec Format & Structure_
Define controlled vocabulary using RFC 2119 conventions: MUST = assertion (mandatory, tested), SHOULD = preference (reviewer checks), MAY = freedom of action (agent decides), MUST NOT = negative assertion (forbidden).

#### Domain: Archaeology

**#59. Spec Archaeology (Decision Layer Tracking)**
_Category: Governance_
Every spec decision carries its stratum: Layer 0 (user goal), Layer 1 (planner interpretation), Layer 2 (architect constraints), Layer 3 (implementer assumptions), Layer 4 (reviewer modifications). Lower-numbered layer wins in conflicts.

#### Domain: Beekeeping (Waggle Dance)

**#60. Compressed Spec Signals Between Agents**
_Category: Agent Coordination_
Define a minimal inter-agent signaling protocol: SIGNAL (DONE/BLOCKED/NEEDS_RESPEC/ASSUMPTION_INVALID), EVIDENCE (assertion results summary), DISCOVERIES (new facts), NEXT_HINT. Dispatch loop reads the signal (~20 tokens) to decide routing; reads full artifact only if signal indicates something unexpected.

#### Domain: Surgery (Operating Room Protocol)

**#61. Pre-Implementation Checklist (Surgical Time-Out)**
_Category: Execution Pipeline_
Before implementer starts, dispatch loop runs mandatory 5-point check: spec checksum matches? target files exist? no other agent modifying same files? all blockedBy tasks VERIFIED (not just DONE)? token budget not exceeded?

**#62. Instrument Count (Post-Task Artifact Audit)**
_Category: Verification & Quality_
After every task completes, verify all expected outputs exist: files listed in file_scope modified? assertions answerable? no unexpected files created outside scope? git commit made with proper format?

#### Domain: Jazz Improvisation

**#63. Structured Improvisation Zones**
_Category: Spec Format & Structure_
Within the spec, explicitly mark "chord changes" (rigid, must follow) and "solo sections" (free to improvise). Identify specific decision points with constraint + freedom pairs.

**#64. Call and Response (Agent Dialogue Protocol)**
_Category: Agent Coordination_
For COMPLEX tasks, allow planner-implementer dialogue before execution: planner sends spec (call), implementer proposes approach (response), planner validates and approves/adjusts (call), implementer executes approved approach.

#### Domain: Weather Forecasting

**#65. Confidence Scoring for Spec Assertions**
_Category: Verification & Quality_
Each assertion carries a confidence score: HIGH (tests known stable interfaces), MEDIUM (depends on implementation choices), LOW (depends on external factors or unresolved assumptions). Verifier treats failures differently by confidence.

**#66. Forecast Horizon (Spec Validity Window)**
_Category: Governance_
Each spec has an explicit validity window — "valid for N tasks" or "expires if not started within 48 hours." After the window, planner must refresh the spec against current codebase state.

#### Domain: Firefighting (ICS)

**#67. Span of Control Rule (Max 7 Tasks per Feature)**
_Category: Governance_
Hard cap: no feature may contain more than 7 tasks. If decomposition exceeds 7, MUST split into sub-features. Combined with idea #48: max 7 tasks per feature, max 7 assertions per task. The "7±2" rule governs the entire spec hierarchy.

**#68. Incident Escalation Protocol (Graduated Response)**
_Category: Verification & Quality_
Four escalation tiers: Green (assertion fails, implementer retries ~500 tokens), Yellow (2+ assertions fail, reviewer investigates root cause), Orange (3+ tasks blocked, planner re-specs subtree), Red (feature-level assertions all failing, architect evaluates fundamental approach).

#### Domain: Photography (Exposure Triangle)

**#69. The Spec Triangle (Scope × Detail × Speed)**
_Category: Governance_
Every spec involves a three-way trade-off: Scope (how many features/tasks), Detail (how precise assertions/constraints), Speed (how fast the loop executes). TRIVIAL = narrow scope, low detail, max speed. COMPLEX = wide scope, max detail, slow speed.

#### Domain: Library Science

**#70. Multi-Axis Task Classification**
_Category: Execution Pipeline_
Add classification axes beyond complexity: Risk (LOW reversible / HIGH destructive), Novelty (ROUTINE / NOVEL needing exploration), Coupling (ISOLATED / COUPLED affecting shared resources). High-risk gets architect pre-check. Novel starts with exploration. Coupled gets conflict detection.

**#71. Cross-Reference Index (Assertion → Code → Test Map)**
_Category: Verification & Quality_
Maintain auto-generated index file `implementation-artifacts/traceability-index.md` mapping assertion IDs to source code line ranges to test file line ranges.

#### Domain: Diplomacy (Treaty Negotiation)

**#72. Spec Ratification Protocol**
_Category: Governance_
For MODERATE/COMPLEX tiers, spec requires explicit ratification: planner drafts (proposal), architect reviews against constitution (legal review), for COMPLEX user reviews overview (citizen ratification). Ratified spec gets version number and becomes immutable.

**#73. Withdrawal Clause (Feature Abandonment Protocol)**
_Category: Governance_
Formal feature abandonment: any agent proposes withdrawal with evidence, dispatch loop pauses tasks, planner evaluates salvage vs abandon, if abandoned all tasks marked WITHDRAWN, partial code preserved on branch. Killing a bad feature is a valid first-class outcome.

#### Domain: Origami

**#74. Fold Verification (Early Task Assertions Are Critical)**
_Category: Verification & Quality_
Weight verification toward early tasks in the DAG — first 2-3 tasks get most rigorous verification (layered: innate + adaptive + integration). Later tasks get lighter verification because foundations are proven.

#### Domain: Mycelium Networks

**#75. Resource Rebalancing Based on Task Difficulty**
_Category: Execution Pipeline_
If a task consumes more tokens than budgeted, dispatch loop reduces spec detail for upcoming easy tasks and redirects saved tokens to the struggling task's retry/respec budget. Token budget becomes dynamic and self-balancing.

#### Domain: Integration (CLAUDE.md Changes)

**#76. CLAUDE.md Changes (Minimal Kernel Extension)**
_Category: Governance_
Phase 1 modifies CLAUDE.md in exactly 3 places: Step 2 (add "if no tasks AND unverified features, dispatch planner"), Step 4 (extend to multi-output switch), Step 6 (add "if NEEDS_RESPEC, dispatch planner for subtree"). Everything else lives in skills and agent definitions.

**#77. New Skill: spec-protocol.md**
_Category: Governance_
Create `.claude/skills/spec-protocol.md` containing spec packet format, graduated tier definitions with token budgets, assertion writing guide, controlled vocabulary, escape clause patterns, assumption format/resolver types.

**#78. Planner Agent Extension**
_Category: Agent Coordination_
Extend planner.md with: new responsibility (write spec overview + distribute per-task criteria), new inputs (spec-protocol skill, constitution, feature tracker), new outputs (spec overview file + enriched task descriptions), new trigger (feature tracker gap detection for autonomous continuation).

**#79. Reviewer Agent Extension (Spec Validation Mode)**
_Category: Agent Coordination_
Extend reviewer.md with dual mode: Code review mode (existing) and Spec review mode (new — reviews spec against constitution, checks assertion completeness, validates controlled vocabulary, verifies file scope, runs spec lint).

**#80. Tester Agent Extension (Assertion Execution Mode)**
_Category: Agent Coordination_
Extend tester.md with three modes: Test suite mode (existing), Assertion execution mode (receives assertions, generates minimal test code, reports pass/fail per assertion ID), Integration verification mode (runs feature-level assertions after all tasks complete).

**#81. Migration Path (v1 → v2)**
_Category: Governance_
Five mandatory steps: add spec-protocol.md, update planner.md, update reviewer.md, update tester.md, add 3 lines to CLAUDE.md. Two optional: add constitution.md, add spec-templates/ directory. Existing projects continue working.

**#82. Backward Compatibility (Spec-Optional Mode)**
_Category: Governance_
Dispatch loop detects whether spec protocol is installed (does spec-protocol.md exist?). If yes: full SDD pipeline. If no: original user-driven dispatch. SDD is an opt-in pluggable capability, not a requirement.

#### Domain: Edge Cases

**#83. The Empty Spec Problem**
_Category: Clarification & Assumptions_
When user goal is too vague for even a TRIVIAL spec, add goal refinement protocol: if planner can't create a spec with at least 1 assertion, return GOAL_TOO_VAGUE with suggested refinement questions.

**#84. The Spec Explosion Problem**
_Category: Clarification & Assumptions_
When a COMPLEX feature decomposes into 30+ tasks (exceeding 7-task cap), add scope negotiation: planner presents options — execute as planned across sub-features, reduce to MVP subset, or split into separate features.

**#85. The Contradictory Assertions Problem**
_Category: Verification & Quality_
Add contradiction detection to spec lint: before execution, check all assertions pairwise for logical conflicts. Flag contradictions for planner to resolve before dispatch.

**#86. The Orphan Assertion Problem**
_Category: Verification & Quality_
After DAG creation, verify every feature-level requirement traces to at least one task-level assertion. Orphans = coverage gaps. Planner must add tasks or redistribute assertions.

#### Domain: Astronomy (Orbital Mechanics)

**#87. Course Correction Windows**
_Category: Execution Pipeline_
Define explicit evaluation points: after task 1 (intent check), after 50% (progress check), after all tasks before feature verification (integration check). Between windows, uninterrupted execution.

#### Domain: Pottery

**#88. The Point of No Return (Reversibility Tracking)**
_Category: Execution Pipeline_
Tag each task with reversibility: REVERSIBLE (code additions, new files), SEMI-REVERSIBLE (schema changes with migrations), IRREVERSIBLE (data migrations, external deployments). Dispatch loop sequences IRREVERSIBLE tasks last, requires explicit user approval even in autonomous mode.

#### Domain: Geology (Plate Tectonics)

**#89. Interface-First Specification**
_Category: Spec Format & Structure_
Planner specs interfaces between tasks first, internals second. API contracts, data schemas, event formats get specified and assertion-tested before internal implementation. Interface-first enables maximum safe parallelism.

**#90. Seismic Monitoring (Interface Change Detection)**
_Category: Verification & Quality_
When a task modifies a file that defines an interface, dispatch loop triggers automatic re-run of all assertions for dependent tasks. Catches interface-breaking changes immediately during execution.

#### Domain: Meta / Self-Reference

**#91. The Spec Spec (Self-Describing Protocol)**
_Category: Governance_
The spec protocol itself (spec-protocol.md) should be written AS a spec — with its own assertions and acceptance criteria. Self-consistency as a design principle.

**#92. Spec Metrics Dashboard (Feedback Loop)**
_Category: Session Continuity & Tracking_
Track spec quality metrics: avg assertions per task by tier, first-pass success rate, assumption validation rate, escape clause trigger rate, token budget accuracy. Write to `planning-artifacts/spec-metrics.md` after each feature. Planner reads to calibrate future specs.

**#93. Spec Versioning (Semantic Versions)**
_Category: Governance_
Specs use semantic versioning: v1.0.0 = initial ratified, v1.1.0 = minor amendment, v2.0.0 = major re-spec. Task packets reference specific version. If spec amended mid-execution, in-progress tasks continue against old version; new tasks use new version.

**#94. Agent Self-Assessment (Capability Declaration)**
_Category: Agent Coordination_
Each agent declares capabilities: max_complexity, spec_fields_consumed, output_format, known_limitations. Dispatch loop checks capabilities before dispatch.

**#95. The Null Spec (Exploration-Only Tasks)**
_Category: Spec Format & Structure_
Spec format supports `type: EXPLORATION` with zero assertions, producing a knowledge artifact instead of code. Formalizes exploration as a legitimate spec type.

**#96. Spec Inheritance from Constitution**
_Category: Spec Format & Structure_
If constitution.md exists, every spec automatically inherits its constraints. Constitution = global assertions; Spec = local assertions; Verification checks both.

**#97. The Minimum Viable Spec**
_Category: Spec Format & Structure_
Define the absolute floor: intent + 2 assertions + file_scope. ~60 tokens. This is SIMPLE tier. If a task can't produce even this, it's TRIVIAL (no spec needed). Proves the token cost of SDD can be as low as 60 tokens per task.

**#98. Spec Diffing (What Changed Between Versions)**
_Category: Execution Pipeline_
When a spec is amended, auto-generate a diff showing new assertions, modified constraints, removed freedoms. Implementer of affected tasks receives the diff, not the full new spec. Token-efficient change notification.

**#99. The Graduation Ceremony (Feature Completion Protocol)**
_Category: Verification & Quality_
When a feature reaches VERIFIED: all assertions re-run (regression check), traceability index verified complete, spec overview marked IMPLEMENTED with date, git tag created, spec metrics updated, feature permanently locked in tracker.

**#100. The Phase 1 Meta-Architecture (Full Pipeline)**
_Category: Governance_
The entire Phase 1 system as one coherent pipeline:

```
User Goal → Goal Refinement → Validated Goal → Planner+Spec Protocol →
Spec Overview + Per-Task Packets → Spec Lint + Review → Ratified Spec →
DAG Creation → Feature Tracker → Pre-Dispatch Checklist → Cleared Task →
Implementer + Inline Assertions → Code + Evidence → Post-Task Audit →
Verified Deliverables → Reviewer → Quality-Approved Code →
Feature Integration → Feature Verification → Graduation →
Completed Feature → Metrics Update → Self-Tuning System
```

Every arrow is a dispatch, every box is an agent or automated check, every output is a file.

---

## Idea Organization and Prioritization

### Thematic Architecture: 7 Implementation Tiers

The 100 ideas organize into 7 implementation tiers, where each tier builds on the previous:

#### TIER 1: Core Infrastructure (Build First) — 8 ideas

| # | Idea | Why Core |
|---|------|----------|
| #1 | Graduated Spec Format Router | Extends existing CLAUDE.md:31-34 classifier |
| #51 | Spec Packet Format (YAML) | The concrete per-task spec structure |
| #97 | Minimum Viable Spec | Defines the floor (~60 tokens) |
| #58 | Controlled Vocabulary (RFC 2119) | MUST/SHOULD/MAY/MUST NOT |
| #77 | spec-protocol.md Skill | Single shared reference file |
| #76 | CLAUDE.md Changes (3 Lines) | Minimal kernel modification |
| #3 | Planner as Spec Agent | No new agent needed |
| #82 | Backward Compatibility | Opt-in, non-breaking |

**Pattern:** Extends existing infrastructure; no new agents; minimal changes to kernel.

#### TIER 2: Spec Authoring Pipeline (Build Second) — 9 ideas

| # | Idea | Role |
|---|------|------|
| #2 | Hybrid Spec (Overview + Per-Task) | Two artifacts for two audiences |
| #4 | Executable Acceptance Criteria | Assertions are tests, not prose |
| #17 | Commander's Intent | Intent (immutable) vs Freedom (delegated) |
| #33 | Double-Entry (Positive + Negative) | Every assertion paired with negation |
| #38 | Assertion Inheritance | Parent assertions propagate to children |
| #48 | Max 7 Assertions per Task | Hard decomposition constraint |
| #67 | Max 7 Tasks per Feature | Hard hierarchy constraint |
| #57 | Spec Lint vs Spec Review | Cheap structural check first |
| #72 | Spec Ratification Protocol | Draft → Review → Ratify → Immutable |

**Pattern:** Defines how specs are written, validated, and locked.

#### TIER 3: Execution Pipeline (Build Third) — 8 ideas

| # | Idea | Role |
|---|------|------|
| #5 | Inline Verification (TDD Dispatch) | Implementer runs assertions during execution |
| #24 | State Machine | Explicit phase transitions with failure paths |
| #61 | Pre-Implementation Checklist | 5-point check before dispatch |
| #62 | Post-Task Artifact Audit | Verify all expected outputs exist |
| #27 | Just-In-Time Decomposition | Spec next 3-5 tasks, not the entire DAG |
| #40 | Expediter (Haiku Pre-Check) | Cheap "right thing built?" gate |
| #70 | Multi-Axis Classification | Complexity + Risk + Novelty + Coupling |
| #88 | Reversibility Tracking | IRREVERSIBLE tasks last |

**Pattern:** Controls how tasks flow from spec to verified delivery.

#### TIER 4: Verification & Quality (Build Fourth) — 7 ideas

| # | Idea | Role |
|---|------|------|
| #41 | Two-Layer Verification | Innate (cheap automated) + Adaptive (expensive agent) |
| #44 | Feature Integration Pass | Cross-task assertions after all tasks verified |
| #37 | Circuit Breaker at Spec Level | 3+ BLOCKED → re-evaluate feature |
| #68 | Graduated Escalation | Green → Yellow → Orange → Red |
| #99 | Graduation Ceremony | Formal feature completion protocol |
| #74 | Early-Heavy Verification | First 2-3 tasks get most rigorous checks |
| #85 | Contradiction Detection | Spec lint catches conflicting assertions |

**Pattern:** Multi-layered quality system from cheap to expensive.

#### TIER 5: Tracking & Continuity (Build Fifth) — 6 ideas

| # | Idea | Role |
|---|------|------|
| #7/#52 | Hierarchical Feature Tracker | Project → Features → Tasks → Assertions (JSON) |
| #8 | Zero-Handoff Continuity | Artifacts ARE the state |
| #34 | Multi-Scale Views | 4 zoom levels from same data |
| #49 | Dailies Review | Auto-summary every N tasks |
| #46 | Token Budgets per Feature | Granular token discipline |
| #92 | Spec Metrics Dashboard | Self-tuning feedback loop |

**Pattern:** Complete project state in files; no session-dependent memory.

#### TIER 6: Agent Extensions (Build Sixth) — 6 ideas

| # | Idea | Role |
|---|------|------|
| #78 | Planner Extension | Spec authoring + gap detection |
| #79 | Reviewer Extension | Dual mode: code review + spec review |
| #80 | Tester Extension | Three modes: test + assertion + integration |
| #47 | Consumption Profiles | Agents declare which spec fields they read |
| #60 | Compressed Signals | ~20 token inter-agent protocol |
| #28 | Agent-Specific Spec Views | Same spec, different views per role |

**Pattern:** Existing agents gain new modes; no new agents created.

#### TIER 7: Governance & Enhancement (Build Last / Optional) — 13 ideas

| # | Idea | Role |
|---|------|------|
| #16 | Spec Immutability + Mutation Protocol | DNA pattern — formal amendments |
| #21 | Escape Clauses | Conditions for abandoning a spec |
| #6 | Tiered Clarification Resolution | Auto-resolve before escalating to human |
| #10 | Assumption Tracking Objects | Typed assumptions with validators |
| #35 | Self-Discovering Spec Templates | `.claude/spec-templates/` directory |
| #55 | Spec Playbook | Reusable patterns per project type |
| #42 | Immune Memory | Failure pattern library |
| #25 | Difficulty Scaling | Adaptive spec detail |
| #81 | Migration Path | 5 mandatory + 2 optional steps |
| #53 | Keystone Task Identification | Critical path protection |
| #73 | Withdrawal Clause | Feature abandonment protocol |
| #54 | Shared Context Artifacts | Knowledge base between agents |
| #36 | Skill-Augmented Specs | Auto-inject project-specific constraints |

**Pattern:** Refinements and optimizations after core pipeline works.

### Deferred to Phase 2 (Radical / Advanced)

| # | Idea | Why Defer |
|---|------|-----------|
| #9 | Autonomous Continuation | Needs tracker + spec pipeline working |
| #11 | Parallel Spec Authoring | Needs spec protocol established |
| #19 | Spec Branching | Advanced — needs basic spec flow |
| #23 | Eventual Consistency | Needs conflict detection working |
| #64 | Call and Response | Enhancement — not core |
| #93 | Spec Versioning | Needs immutability protocol |
| #15 | Pull-Based Dispatch | Architectural shift — Phase 2 |
| #14 | Compiler Pipeline | Mental model, not implementation |

### Remaining Ideas (Valuable but Not Tier-Critical)

Ideas #26, #29, #30, #31, #32, #39, #43, #45, #50, #56, #59, #63, #65, #66, #69, #71, #75, #83, #84, #86, #87, #89, #90, #91, #94, #95, #96, #98, #100 — These contribute valuable patterns and edge-case handling. Many are incorporated into the tier architecture implicitly (e.g., #43 is part of #51, #31 is part of #52). Others become relevant as enhancements after the core pipeline is proven.

---

### Prioritization Results

**Top 3 High-Impact Ideas:**
1. **#51 Spec Packet Format** — The single concrete artifact everything else depends on
2. **#1 Graduated Spec Format Router** — Leverages existing infrastructure with minimal change
3. **#5 Inline Verification (TDD Dispatch)** — Reduces worker-reviewer cycles from 3 to 1

**Easiest Quick Wins:**
1. **#77 spec-protocol.md** — One new file, immediate value
2. **#76 CLAUDE.md 3-line change** — Minimal risk, enables everything
3. **#82 Backward Compatibility** — Presence detection makes SDD opt-in

**Most Innovative Breakthroughs:**
1. **#41 Two-Layer Verification** — 80% of failures caught at 5% cost
2. **#8 Zero-Handoff Continuity** — Artifacts ARE state, no overhead
3. **#97 Minimum Viable Spec** — 60 tokens proves SDD cost is negligible

---

### Action Planning

**Implementation Sequence (The Migration Path):**

**Step 1: Create spec-protocol.md** (#77)
- Write `.claude/skills/spec-protocol.md` containing:
  - Spec packet YAML format (#51)
  - Graduated tier definitions (#1) with token budgets (#46)
  - Controlled vocabulary (#58)
  - Assertion writing guide (positive + negative) (#33)
  - 7×7 constraints (#48, #67)
  - Escape clause patterns (#21)
  - Minimum viable spec definition (#97)

**Step 2: Update planner.md** (#78)
- Add spec authoring responsibility
- Reference spec-protocol.md skill
- Define two outputs: spec overview + per-task criteria
- Add feature tracker gap detection trigger

**Step 3: Update reviewer.md** (#79)
- Add spec review mode alongside existing code review
- Add spec lint checks (#57)
- Reference spec-protocol.md for validation rules

**Step 4: Update tester.md** (#80)
- Add assertion execution mode
- Add integration verification mode
- Define pass/fail reporting format per assertion ID

**Step 5: Modify CLAUDE.md** (#76)
- Step 2: "if no tasks AND unverified features → dispatch planner"
- Step 4: Extend complexity classifier to multi-output switch
- Step 6: "if NEEDS_RESPEC → dispatch planner for subtree"

**Optional Step 6:** Add constitution.md (#96)
**Optional Step 7:** Add `.claude/spec-templates/` directory (#35, #55)

---

## Session Summary and Insights

**Key Achievements:**
- 100 breakthrough ideas generated across 38 domains using 3 analytical techniques
- Ideas organized into 7 implementation tiers with clear build sequence
- Concrete YAML spec format (#51) and JSON tracker schema (#52) designed
- Migration path proven to require only 5 mandatory steps
- Backward compatibility guaranteed — SDD is opt-in
- Phase 1 vs Phase 2 boundary clearly defined

**Key Architectural Decisions:**
1. No new agents — extend planner, reviewer, tester
2. Spec is two artifacts — human overview + agent packets
3. Assertions are tests — no interpretation gap
4. 7×7 constraint — max 7 tasks/feature, 7 assertions/task
5. SDD is opt-in — spec-protocol.md presence triggers it
6. 60-token floor — minimum viable spec costs less than one reviewer message
7. Three CLAUDE.md changes — minimal kernel, maximum capability

**Session Reflections:**
- Assumption Reversal was most architecturally productive — identified the core building blocks
- Morphological Analysis revealed powerful combinations (especially Self-Healing DAG #12)
- Cross-Pollination from 38 domains produced the highest volume and most unexpected insights
- The synthesis ideas (#51, #52, #100) proved that 100 divergent ideas converge into a coherent, implementable architecture
- Phase 1 is achievable as an incremental, backward-compatible extension — not a rewrite
