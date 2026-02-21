---
title: "Spec-Protocol Table of Contents & Story Origins"
description: "Authoritative index mapping all 18 sections of spec-protocol.md to their story origins in epics.md"
lastUpdated: "2026-02-20"
---

# Spec-Protocol Table of Contents & Story Origins

## Overview

This document is the **authoritative index** of the spec-protocol.md structure. It provides:

1. A complete table of contents with precise line numbers for all 18 sections
2. The primary story origin that defined each section
3. Key concepts per section (3-5 bullet points)
4. Cross-references to related sections
5. Slice assignment and status for each section
6. A legend explaining slice progression and section status

This TOC serves as the canonical reference for understanding how spec-protocol.md was architected from the SDD requirements, which story first defined each section, and how sections relate to one another.

---

## Section Directory

### Section 1: Spec Packet Format (Lines 11-66)
- **Story Origin**: 1.1 — Define Spec Packet YAML Format
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - YAML structure with 5 required fields: version, intent, assertions, constraints, file_scope
  - Assertion triple: id (A1–A7), positive (what MUST be true), negative (what MUST NOT be true)
  - Delimiters: `# --- SPEC ---` / `# --- END SPEC ---` enable forgiving parser fallback
  - Schema versioning strategy: Slice 1 has 5 fields; Slice 3 adds 6 more (11 total) in backward-compatible fashion
  - Field reference table with types and descriptions
- **Related Sections**: 8 (Inline Spec Delivery), 11 (Evidence Reporting)

### Section 2: Tier Examples (Lines 68-159)
- **Story Origin**: 1.1 — Define Spec Packet YAML Format (illustrated by tier examples)
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - TRIVIAL: No spec, zero overhead (typo fixes, single-line changes)
  - SIMPLE: Minimal YAML ~60 tokens, 4 required fields (adding .env to .gitignore)
  - MODERATE: Full spec + spec overview document (user authentication endpoint)
  - COMPLEX: Full spec + overview + architect pre-check (OAuth2 PKCE flow)
  - Filled YAML examples for each tier showing progression in detail
- **Related Sections**: 6 (Tier Definitions), 7 (SDD Dispatch Routing)

### Section 3: Controlled Vocabulary (Lines 162-182)
- **Story Origin**: 1.2 — Define Controlled Vocabulary & Assertion Quality Gate
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - RFC 2119 derived keywords: MUST (absolute requirement), MUST NOT (absolute prohibition), SHOULD (recommended), MAY (optional)
  - Keyword definitions with precise semantics and usage context
  - Usage rules: positive fields MUST contain exactly one keyword; negative fields use opposite keyword
  - Constraints use only MUST/MUST NOT (non-negotiable); intent field uses imperative verbs instead
  - Examples of correct usage in different assertion contexts
- **Related Sections**: 4 (Assertion Quality Gate), 5 (Constraints & Governance)

### Section 4: Assertion Quality Gate (Lines 184-269)
- **Story Origin**: 1.2 — Define Controlled Vocabulary & Assertion Quality Gate
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Core rule: Every assertion MUST name a specific observable (endpoint, file, UI element, return value, error code)
  - Banned vague terms without observable: "works," "correct," "proper," "appropriate," "handles correctly," "functions as expected"
  - Specific observable types: endpoint + HTTP status, file path + content, return value/type, error code, database state, UI element, log output
  - Double-entry validation: positive + negative fields validate requirement from both directions
  - Valid vs. invalid assertion examples with corrections
- **Related Sections**: 3 (Controlled Vocabulary), 14 (Two-Layer Verification Pipeline)

### Section 5: Constraints & Governance (Lines 272-305)
- **Story Origin**: 1.3 — Define Constraints, Governance Seed & 7x7 Rule
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - 7x7 constraint: Max 7 tasks per feature, max 7 assertions per task (forces decomposition)
  - 8 governance seed principles: External Done, Unambiguous Specs, Positive ROI, File-First State, Self-Contained Tasks, Queryable State, Spec Immutability, Ownership Boundaries
  - Governance cascade hierarchy: constitution.md > spec-protocol.md > spec templates > skills > agent freedom
  - Rationale for constraints prevents scope creep and ensures single-agent task completion
  - Optional constitution.md and templates do not degrade SDD when absent
- **Related Sections**: 16 (Constitution & Failure Pattern Library), 1 (Spec Packet Format)

### Section 6: Tier Definitions (Lines 308-352)
- **Story Origin**: 1.3 — Define Constraints, Governance Seed & 7x7 Rule (tier classification)
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Classification decision table: Files touched, Risk of drift, Novelty, Coupling, Token budget
  - TRIVIAL: 1 file, zero risk, known pattern, isolated; no spec overhead
  - SIMPLE: 1–2 files, low risk, low novelty; minimal YAML packet (~60 tokens)
  - MODERATE: 2–5 files, medium risk/novelty, some cross-file; full spec + overview doc
  - COMPLEX: 5+ files or cross-boundary, high risk/novelty, multi-component; architect pre-check + spec suite
  - Conflict resolution rule: When signals conflict, classify UP to higher tier
- **Related Sections**: 2 (Tier Examples), 7 (SDD Dispatch Routing)

### Section 7: SDD Dispatch Routing (Lines 354-449)
- **Story Origin**: 2.1 — SDD Detection & Dispatch Loop Integration; 2.2 — Graduated Spec Tier Router
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Dispatch routing decision tree: Step 4 classifies both **model** (haiku/sonnet/opus) AND **spec_tier** (TRIVIAL/SIMPLE/MODERATE/COMPLEX)
  - TRIVIAL routing: Skip planner entirely, direct to implementer, no assertions
  - SIMPLE routing: Planner writes minimal spec packet, implementer reports evidence
  - MODERATE routing: Planner writes full spec + overview, implementer executes, reviewer validates
  - COMPLEX routing: Architect pre-check, planner writes spec suite, implementer executes, reviewer validates
  - Dispatch prompt templates for each tier with reference-only spec (never pasted)
- **Related Sections**: 6 (Tier Definitions), 8 (Inline Spec Delivery), 2 (Tier Examples)

### Section 8: Inline Spec Delivery Protocol (Lines 451-525)
- **Story Origin**: 2.3 — Inline Spec Packet Delivery via TaskList
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Spec packets embedded in TaskList task description; single source of truth
  - Planner embedding workflow: read spec-protocol.md, author spec packet, call TaskCreate with spec in description
  - TaskCreate description template: plain-text summary + delimited YAML spec packet
  - Implementer consumption: TaskGet → locate spec between delimiters → parse YAML → execute assertions → report evidence
  - Forgiving parser fallback: lint retry (1 cycle) → forgiving parser → BLOCKED if both fail
  - Anti-pattern: never paste spec into dispatch prompt (risks version drift)
- **Related Sections**: 7 (SDD Dispatch Routing), 11 (Evidence Reporting), 1 (Spec Packet Format)

### Section 9: Spec Overview Documents (Lines 527-621)
- **Story Origin**: 2.4 — Spec Overview Documents
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Naming convention: `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`
  - ID schemes: Feature ID (F-NNN global), Task ID (T-NNN global), Assertion ID (AN per-task)
  - Overview template: Goal, Task List table (ID/Subject/Tier/Assertions), Acceptance Criteria, Notes
  - Created for MODERATE and COMPLEX tiers only; TRIVIAL/SIMPLE have zero overhead
  - Ownership: planner creates and updates; no other agent MAY modify
  - Integration with feature tracker (Section 12) and spec packets (Section 8)
- **Related Sections**: 7 (SDD Dispatch Routing), 12 (Feature Tracker Protocol)

### Section 10: Spec Lifecycle States (Lines 623-663)
- **Story Origin**: 2.5 — Spec Lifecycle States & Evidence Reporting
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Slice 1 states: DRAFT → ACTIVE → DONE
  - DRAFT: Planner authoring (entered at TaskCreate, exited at dispatch)
  - ACTIVE: Implementer executing (entered at dispatch, exited when all assertions PASS)
  - DONE: All assertions verified; terminal state
  - Transition rules: DRAFT→ACTIVE at dispatch, ACTIVE→DONE when all assertions PASS, ACTIVE→ACTIVE on FAIL (retry), ACTIVE→BLOCKED after 3 retries
  - Immutability rule: Once ACTIVE, spec MUST NOT be modified; changes require new spec as separate task
  - Future expansion: Slice 3 adds 6 states (LINT_PASS, RATIFIED, EXECUTING, VERIFIED, GRADUATED)
- **Related Sections**: 13 (Tracker State Machine & Recovery), 15 (Expanded Lifecycle States)

### Section 11: Evidence Reporting Protocol (Lines 666-732)
- **Story Origin**: 2.5 — Spec Lifecycle States & Evidence Reporting
- **Slice**: 1
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Evidence format: `- {id}: PASS|FAIL — {file}:{line} ({brief evidence})`
  - PASS evidence: Cites file:line where implementation satisfies assertion
  - FAIL evidence: Expected vs. actual comparison showing failure details
  - NOT DONE rule: Task incomplete if ANY assertion missing, ANY result is FAIL, or evidence lacks file:line reference
  - Completion flow: implementer writes evidence → dispatch loop checks all assertions PASS → transitions to DONE → circuit breaker on 3 retries
  - Tier applicability: TRIVIAL has no evidence (no spec); SIMPLE/MODERATE/COMPLEX require full evidence per assertion
- **Related Sections**: 8 (Inline Spec Delivery), 10 (Spec Lifecycle States)

### Section 12: Feature Tracker Protocol (Lines 734-862)
- **Story Origin**: 3.1 — Feature Tracker JSON Schema & Initialization
- **Slice**: 2
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - File location: `planning-artifacts/feature-tracker.json` (created at runtime, not in repo template)
  - JSON schema fields in exact order: id, title, phase, spec_overview, tasks[], verified
  - Phase values: DRAFT | ACTIVE | DONE (Slice 1); extended to 6 states in Slice 3 (with constitution.md)
  - Ownership: planner creates entries, dispatch loop updates phase/verified only
  - Slice 4 extended fields (optional): tier, token_budget, token_spent, entropy_score, assertions_total, assertions_passing
  - Integration with dispatch loop (CLAUDE.md Step 2): unverified features trigger auto-spec
  - Recovery: git checkout if corrupted; tracker reconstruction from spec overviews + TaskList state if needed
- **Related Sections**: 13 (Tracker State Machine & Recovery), 9 (Spec Overview Documents)

### Section 13: Tracker State Machine & Recovery (Lines 865-944)
- **Story Origin**: 3.2 — Tracker State Transitions & Recovery
- **Slice**: 2
- **Status**: Complete (Core Foundational)
- **Key Concepts**:
  - Post-task completion checklist: read evidence → update task status → check feature progress → check all tasks → transition if complete → check stall threshold
  - Automated DONE transition: when ALL tasks have ALL assertions PASS, set verified=true and phase=DONE
  - Feature stall detection: 3+ BLOCKED tasks in a feature trigger NEEDS_RESPEC flag
  - Graceful degradation: if tracker JSON fails to parse, system falls back to non-SDD mode; per-task SDD continues unaffected
  - Recovery procedures: Git recovery (fastest), Manual rebuild (from spec overviews + TaskList), Fresh start (lose tracking history)
  - Threshold rationale: 3 BLOCKED tasks (of 7 max per 7x7 rule) signals systemic issue
- **Related Sections**: 12 (Feature Tracker Protocol), 10 (Spec Lifecycle States)

### Section 14: Two-Layer Verification Pipeline (Lines 946-1033)
- **Story Origin**: 4.1 — Two-Layer Automated Verification Pipeline
- **Slice**: 3
- **Status**: Complete (Governance Enhancement)
- **Key Concepts**:
  - Layer 1 (automated gates): Spec Lint (7 checks), Assertion Audit (4 checks), File Scope Audit (2 checks)
  - Layer 2 (agent review): Reviewer validates evidence against code
  - Gate 1 (Spec Lint): Delimiter presence, YAML parse, required fields, assertion structure, controlled vocabulary, quality gate, 7x7 constraint
  - Gate 2 (Assertion Audit): Completeness (all IDs have results), Status present, Evidence format (file:line), FAIL detail (expected vs actual)
  - Gate 3 (File Scope Audit): No out-of-scope modifications (blocking), Completeness warning (untouched scope files)
  - Failure handling: specific feedback → 1 retry → re-run all gates → BLOCKED if retry fails
  - Tier applicability: TRIVIAL skips all gates; SIMPLE/MODERATE/COMPLEX run all 3 gates
- **Related Sections**: 4 (Assertion Quality Gate), 11 (Evidence Reporting), 15 (Expanded Lifecycle States)

### Section 15: Expanded Lifecycle States & Graduated Escalation (Lines 1035-1138)
- **Story Origin**: 4.2 — Expanded Lifecycle States & Graduated Escalation
- **Slice**: 3
- **Status**: Complete (Governance Enhancement)
- **Key Concepts**:
  - Slice 3 6-state lifecycle: DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
  - LINT_PASS: Section 14 Gate 1 passes (planner retry if fails)
  - RATIFIED: Reviewer approves spec quality (planner revises on NEEDS_CHANGES)
  - EXECUTING: Implementer works against immutable spec
  - VERIFIED: All assertions PASS + Gates 1-3 pass (graduated escalation on failure)
  - GRADUATED: Feature-level terminal state (ALL tasks VERIFIED)
  - Graduated escalation: Green (pass) → Yellow (warnings) → Orange (MUST violations, reviewer escalation) → Red (3 failures, BLOCKED)
  - Three circuit breaker layers: Task (3 worker-reviewer cycles), Spec (3 BLOCKED tasks), Feature (stall detection)
  - Backward compatibility: Slice 1 3-state model remains valid for projects without governance
  - Activation requirement: 6-state lifecycle activates ONLY when constitution.md exists
- **Related Sections**: 10 (Spec Lifecycle States), 16 (Constitution & Failure Pattern Library)

### Section 16: Constitution & Failure Pattern Library (Lines 1141-1287)
- **Story Origin**: 4.3 — Optional Constitution & Failure Pattern Library
- **Slice**: 3
- **Status**: Complete (Optional Governance)
- **Key Concepts**:
  - Constitution protocol: `planning-artifacts/constitution.md` contains immutable project principles (optional)
  - Article format: Principle (one-sentence rule), Rationale (WHY), Enforcement (which gate, which agent), Violation response
  - Phase -1 gates: Constitution checks run BEFORE spec lifecycle (before DRAFT → LINT_PASS)
  - Governance cascade enforcement: constitution (highest) > spec-protocol > templates > skills > agent freedom
  - Ownership: only humans can create and amend constitution (formal amendment protocol)
  - Failure pattern library: `planning-artifacts/knowledge-base/failure-patterns.md` (append-only)
  - Categories: spec-quality, assertion-gaps, scope-violations, decomposition-failures, governance-gaps
  - Status transitions: active → mitigated → resolved; IDs sequential (FP-001, FP-002, etc.)
  - Population: Red escalation, feature stall, reviewer findings trigger new entries
- **Related Sections**: 15 (Expanded Lifecycle States), 5 (Constraints & Governance)

### Section 17: Spec Templates Protocol (Lines 1290-1378)
- **Story Origin**: 5.4 — Reusable Spec Templates (Optional)
- **Slice**: 4
- **Status**: Complete (Optional Acceleration)
- **Key Concepts**:
  - Location: `.claude/spec-templates/` directory; templates are git-tracked, human-created
  - Template structure: pattern_name, description, typical_tier, intent_template, assertions, constraints, file_scope_patterns
  - Placeholder conventions: {entity}, {endpoint}, {file}, {id} (filled by planner, not blindly copied)
  - Planner consumption: Check templates for match → load as starting point → adapt → resolve all placeholders
  - Anti-blind-copy rule: Planner adapts every assertion to specific feature; removes inapplicable assertions; adds unique behaviors
  - Template lifecycle: Creation (humans/architects), Evolution (failure patterns inform updates), Governance (below spec-protocol in cascade)
  - Template sketches: rest-crud-endpoint (4 assertions), auth-flow (5 assertions), data-pipeline (3 assertions)
  - Tier applicability: SIMPLE rarely uses; MODERATE primary use case; COMPLEX templates provide starting point
- **Related Sections**: 5 (Constraints & Governance), 16 (Constitution & Failure Pattern Library)

### Section 18: Metrics Dashboard (Slice 4) (Lines 1381-1418)
- **Story Origin**: (Implied from Epic 5 scale context; no explicit story in epics.md but aligns with Story 5.1-5.3 agent extension theme)
- **Slice**: 4
- **Status**: Complete (Optional Observability)
- **Key Concepts**:
  - Token tracking: dispatch loop updates token_spent after each dispatch; alert at 85% of budget
  - Token budgets by tier: TRIVIAL=500, SIMPLE=2000, MODERATE=8000, COMPLEX=25000; baseline ~80 tokens/task
  - Assertion metrics: Pass rate (assertions_passing / assertions_total); target 100% for DONE features
  - Entropy score: (spec_amendments + respec_count) / assertions_total; <0.2 stable, 0.2–0.5 acceptable, >0.5 unstable
  - Spec quality metrics: Vague term rate (target 0%), Double-entry compliance (target 100%), File scope accuracy (target 0% violations)
  - When to use: Optional for Slice 1–2; recommended for MODERATE+ in Slice 4; tracked in feature-tracker.json extended fields
  - Dashboard view: read feature-tracker.json and compute metrics per feature using provided formulas
- **Related Sections**: 12 (Feature Tracker Protocol), 9 (Spec Overview Documents)

---

## Legend & Navigation Guide

### Slice Assignment

All 18 sections are distributed across the 4 slices of the SDD architecture:

| Slice | Purpose | Status | Sections |
|-------|---------|--------|----------|
| **Slice 1** | Minimal viable SDD — specs, dispatch, inline delivery, evidence | Complete & Mandatory | 1–2, 3–11 (11 sections) |
| **Slice 2** | Feature tracking and session continuity | Complete & Recommended | 12–13 (2 sections) |
| **Slice 3** | Automated quality governance, expanded lifecycle, optional constitution | Complete & Optional | 14–16 (3 sections) |
| **Slice 4** | Agent specialization, spec templates, metrics dashboard | Complete & Optional | 17–18 (2 sections) |

**Key Note:** Slice 1 (Sections 1–11) is complete and sufficient for full SDD operation. Slices 2–4 are enhancements that activate when their artifacts exist (feature-tracker.json for Slice 2, constitution.md for Slice 3 governance gates).

### Section Status Categories

| Status | Meaning | Sections |
|--------|---------|----------|
| **Core Foundational** | Essential to Slice 1 SDD operation; always active when spec-protocol.md exists | 1–11 |
| **Governance Enhancement** | Adds automated gates, expanded states, optional constitution; activates when Slice 3+ governance is enabled | 14–16 |
| **Optional Acceleration** | Reusable templates and metrics; improves efficiency but SDD functions fully without them | 17–18 |

### Story-to-Section Mapping

This table shows which story in epics.md first defined each section:

| Story ID | Story Title | Sections Defined |
|----------|-------------|------------------|
| **1.1** | Define Spec Packet YAML Format | 1, 2 |
| **1.2** | Define Controlled Vocabulary & Assertion Quality Gate | 3, 4 |
| **1.3** | Define Constraints, Governance Seed & 7x7 Rule | 5, 6 |
| **2.1** | SDD Detection & Dispatch Loop Integration | 7 |
| **2.2** | Graduated Spec Tier Router | 7 (reinforces) |
| **2.3** | Inline Spec Packet Delivery via TaskList | 8 |
| **2.4** | Spec Overview Documents | 9 |
| **2.5** | Spec Lifecycle States & Evidence Reporting | 10, 11 |
| **3.1** | Feature Tracker JSON Schema & Initialization | 12 |
| **3.2** | Tracker State Transitions & Recovery | 13 |
| **4.1** | Two-Layer Automated Verification Pipeline | 14 |
| **4.2** | Expanded Lifecycle States & Graduated Escalation | 15 |
| **4.3** | Optional Constitution & Failure Pattern Library | 16 |
| **5.1** | Planner Agent Spec Authoring Extension | (implied in Section 8 planner workflow) |
| **5.2** | Reviewer Spec Review Mode | (implied in Sections 14, 15 reviewer gates) |
| **5.3** | Tester Assertion Execution & Integration Modes | (implied in Section 11 evidence format) |
| **5.4** | Reusable Spec Templates (Optional) | 17 |
| **(Metrics)** | Implied from Epic 5 scale context | 18 |

### Epic-to-Section Alignment

| Epic | Focus | Sections | Status |
|------|-------|----------|--------|
| **Epic 1** | Spec Protocol Foundation (YAML format, vocabulary, constraints, 7x7) | 1–6 | Slice 1, Complete |
| **Epic 2** | End-to-End Spec Execution Pipeline (detection, routing, delivery, evidence) | 7–11 | Slice 1, Complete |
| **Epic 3** | Feature Tracking & Session Continuity (JSON tracker, state machine, recovery) | 12–13 | Slice 2, Complete |
| **Epic 4** | Automated Quality Governance (verification gates, expanded lifecycle, constitution) | 14–16 | Slice 3, Complete |
| **Epic 5** | Agent Specialization & Scale (agent extensions, templates, metrics) | 17–18 | Slice 4, Complete |

### Cross-Section Dependencies

Understanding how sections relate to one another:

- **Foundation**: Sections 1–6 (Spec Packet, Tiers, Vocabulary, Quality Gate, Constraints) provide the spec language and classification foundation.
- **Execution**: Sections 7–11 (Dispatch, Delivery, Overviews, Lifecycle, Evidence) implement spec-driven task execution.
- **Persistence**: Sections 12–13 (Feature Tracker, State Machine) enable session continuity and recovery.
- **Governance**: Sections 14–16 (Verification, Expanded Lifecycle, Constitution) add quality gates and formal principles.
- **Scale**: Sections 17–18 (Templates, Metrics) accelerate authoring and provide observability.

### Quick Reference by Use Case

**I'm a planner writing a spec:**
- Start with Sections 1 (format), 3 (vocabulary), 4 (quality gate), 6 (tiers)
- Use Section 2 (examples) as templates
- Create spec overview per Section 9
- Update feature tracker per Section 12

**I'm an implementer executing a spec:**
- Read Section 8 (how to receive spec via TaskList)
- Understand Section 11 (evidence reporting format)
- Reference Section 10 (lifecycle states)

**I'm a reviewer validating work:**
- Understand Sections 14–15 (verification gates, escalation) if Slice 3 is active
- Check evidence against Section 11 format
- Validate assertions match Section 4 quality rules

**I'm a project lead setting governance:**
- Read Section 5 (governance seed principles)
- Understand Section 6 (tier classification decision table)
- Create constitution.md per Section 16 (optional but recommended)

**I'm debugging a spec failure:**
- Check Section 14 (automated gates) for lint/audit failures
- Review Section 13 (stall detection, recovery procedures)
- Consult Section 16 (failure pattern library) for lessons learned

---

## Appendix: Line Range Reference

This appendix provides the exact line number boundaries for each section for quick lookup:

| Section | Lines | Title |
|---------|-------|-------|
| 1 | 11–66 | Spec Packet Format |
| 2 | 68–159 | Tier Examples |
| 3 | 162–182 | Controlled Vocabulary |
| 4 | 184–269 | Assertion Quality Gate |
| 5 | 272–305 | Constraints & Governance |
| 6 | 308–352 | Tier Definitions |
| 7 | 354–449 | SDD Dispatch Routing |
| 8 | 451–525 | Inline Spec Delivery Protocol |
| 9 | 527–621 | Spec Overview Documents |
| 10 | 623–663 | Spec Lifecycle States |
| 11 | 666–732 | Evidence Reporting Protocol |
| 12 | 734–862 | Feature Tracker Protocol |
| 13 | 865–944 | Tracker State Machine & Recovery |
| 14 | 946–1033 | Two-Layer Verification Pipeline |
| 15 | 1035–1138 | Expanded Lifecycle States & Graduated Escalation |
| 16 | 1141–1287 | Constitution & Failure Pattern Library |
| 17 | 1290–1378 | Spec Templates Protocol |
| 18 | 1381–1418 | Metrics Dashboard (Slice 4) |

---

## Document Metadata

- **Purpose**: Authoritative index mapping spec-protocol.md sections to story origins
- **Source Documents**:
  - `/spec-protocol.md` (Sections 1–18)
  - `/docs/planning-artifacts/epics.md` (Story origins and acceptance criteria)
- **Maintained By**: Planning/Architecture team
- **Last Updated**: 2026-02-20
- **Location**: `/docs/planning-artifacts/spec-protocol-toc.md`

### Related Documents

- **epics.md** - The complete epic and story breakdown that defined all 18 sections
- **story-status-matrix.md** - Track which stories are implemented, in-progress, or pending
- **spec-protocol.md** - The full protocol document (referenced throughout this TOC)
- **CLAUDE.md** - Main agent dispatch loop (implements Sections 7, modified per Section 2)
- **feature-tracker.json** - Runtime feature index (Section 12 schema)

---

## Footer: Using This TOC

This document is a **navigation aid and authoritative reference**. Use it to:

1. **Understand spec-protocol.md structure** — See the 18 sections in logical order with their relationships
2. **Trace requirements back to stories** — Understand which epic/story originally defined each section
3. **Quick lookup by topic** — Use the cross-section dependencies to find related sections
4. **Onboard new team members** — Share this TOC to help them understand SDD architecture at a glance
5. **Identify scope of a change** — When modifying spec-protocol.md, check which sections are affected and which stories must be re-validated

This TOC is itself governed by the Spec Protocol (Section 5 immutability rule): once published, changes require a new version or amendment notation.
