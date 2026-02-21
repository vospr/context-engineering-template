---
stepsCompleted: [step-01-init, step-02-discovery, step-02b-vision, step-02c-executive-summary, step-03-success, step-04-journeys, step-05-domain, step-06-innovation, step-07-project-type, step-08-scoping, step-09-functional, step-10-nonfunctional, step-11-polish]
inputDocuments:
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\brainstorming\brainstorming-session-2026-02-17.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\brainstorming\brainstorming-session-2026-02-21.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\1-1-define-spec-packet-yaml-format.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\1-2-define-controlled-vocabulary-assertion-quality-gate.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\1-3-define-constraints-governance-seed-7x7-rule.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\2-1-sdd-detection-dispatch-loop-integration.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\2-2-graduated-spec-tier-router.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\2-3-inline-spec-packet-delivery-via-tasklist.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\2-4-spec-overview-documents.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\2-5-spec-lifecycle-states-evidence-reporting.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\3-1-feature-tracker-json-schema-initialization.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\3-2-tracker-state-transitions-recovery.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\4-1-two-layer-verification-pipeline.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\4-2-expanded-lifecycle-gates.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\4-3-constitution-failure-pattern-library.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\5-1-planner-agent-spec-authoring-extension.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\5-2-reviewer-spec-review-mode.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\5-3-tester-assertion-execution-integration-modes.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\5-4-reusable-spec-templates-optional.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\6-1-cross-agent-trace-id.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\6-2-reflection-memory-loop.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\6-3-complexity-escalation-protocol.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\6-4-system-health-circuit-breakers.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\6-5-reasoning-strategy-selector.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\implementation-artifacts\tests\test-summary.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\architecture.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\constraints-risks.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\epics.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\project-overview.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\spec-protocol-toc.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\story-status-matrix.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\system-inventory.md
  - C:\Users\AndreyPopov\Documents\EPAM\Project_Temp_automated\context-engineering-template\internal_project_documentation\planning-artifacts\workflows.md
workflowType: 'prd'
documentCounts:
  briefs: 0
  research: 0
  brainstorming: 2
  projectDocs: 33
  projectContext: 0
classification:
  projectType: developer_tool
  domain: general
  complexity: medium
  projectContext: brownfield
---

# Product Requirements Document - Project_Temp_automated

**Author:** Andrey  
**Date:** 2026-02-21

## Executive Summary

This product is a markdown-first, zero-runtime context engineering template that turns Claude Code into a reliable multi-agent delivery system for long-running projects. It solves context loss and inconsistent execution by externalizing state to files, enforcing spec-driven workflows, and using role-specific agents with strict artifact ownership.

### What Makes This Special

Disciplined orchestration: inline spec packets, built-in verification, and durable artifacts (planning + implementation) that serve as system memory. The core insight is that reliability comes from protocols and file-based state, not larger models.

## Project Classification

- **Project Type:** Developer tool / framework  
- **Domain:** General software (developer tooling / orchestration)  
- **Complexity:** Medium  
- **Project Context:** Brownfield (existing system extension)

## Success Criteria

### User Success
- Users can adopt the template and complete a spec-driven workflow with no manual intervention beyond goal input.  
- Users can resume work after context loss using files alone.  
- Users can trace outcomes to explicit assertions and artifacts.  

### Business Success
- 3-month win: at least one end-to-end SDD feature slice delivered with artifacts.  
- 12-month win: multi-slice adoption (spec protocol + tracking + verification) becomes default for new projects.  

### Technical Success
- Spec packets are embedded inline and validated against controlled vocabulary.  
- Feature tracker provides continuity state without manual reconstruction.  
- Two-layer verification catches assertion failures before review cycles.  

### Measurable Outcomes
- >=1 successful feature with fully passing assertions tracked in `feature-tracker.json`.  
- 0 critical traceability gaps (Trace ID present where required).  
- 1 complete SDD execution (spec -> task -> verify -> artifact -> tracker update).

## User Journeys

### 1) Primary User - Project Lead (Success Path)
**Opening Scene:** Andrey needs predictable delivery across long sessions.  
**Rising Action:** He initializes the template and dispatches the planner to create a spec packet and overview.  
**Climax:** Implementer executes against assertions; reviewer validates evidence; tracker updates.  
**Resolution:** He can pause and resume with confidence that artifacts preserve state.

### 2) Primary User - Project Lead (Edge Case / Recovery)
**Opening Scene:** A task is misclassified and complexity is higher than expected.  
**Rising Action:** Implementer escalates with an ESCALATED status and recommendation.  
**Climax:** Dispatcher re-routes and updates tracker.  
**Resolution:** Rework is avoided and auditability preserved.

### 3) Implementer - Engineer
**Opening Scene:** Engineer receives a task with an inline spec packet.  
**Rising Action:** Implements within file scope and records evidence for each assertion.  
**Climax:** Assertions pass with file:line evidence.  
**Resolution:** Reviewer can validate quickly; fewer feedback loops.

### 4) Reviewer / QA
**Opening Scene:** Reviewer receives completed task with evidence.  
**Rising Action:** Validates assertions and file scope; confirms traceability.  
**Climax:** CRITICAL issue triggers new failure pattern entry.  
**Resolution:** System learns and future specs prevent recurrence.

### 5) Maintainer - Template Owner
**Opening Scene:** Maintainer evolves the template without breaking projects.  
**Rising Action:** Extends skills and agents while keeping CLAUDE.md small.  
**Climax:** Governance and templates are added without runtime dependencies.  
**Resolution:** Improvements are adoptable incrementally.

### Journey Requirements Summary
- Inline spec packets for clarity and zero extra reads.  
- Evidence reporting for assertion traceability.  
- Escalation protocol for misclassified complexity.  
- Feature tracker for continuity.  
- Failure-pattern capture for long-term improvement.  
- Maintainer guardrails (kernel size, zero runtime).

## Developer Tool Specific Requirements

### Project-Type Overview
Markdown-first, zero-runtime developer tool/framework for multi-agent orchestration. Language-agnostic; behavior defined by files, skills, and agent rules.

### Technical Architecture Considerations
- File-system-first state and traceability.  
- Inline spec packets to minimize context load.  
- Strict agent artifact ownership.  
- Git lineage as operational dependency.

### Language Matrix
- Language-agnostic (Markdown/YAML conventions).  
- No runtime SDK or package dependencies.

### Installation Methods
- Template setup (copy/clone).  
- Requires Claude Code CLI and Git.

### API Surface
- No runtime API surface; behavior defined by markdown and file paths.

### Code Examples
- Examples via internal implementation artifacts and planning artifacts.

### Implementation Considerations
- Keep CLAUDE.md under size constraint; move logic to skills.  
- Preserve backward compatibility (SDD opt-in).

## Project Scope & Phased Development

### MVP Strategy & Philosophy
**MVP Approach:** Problem-solving + platform MVP to prove spec-driven delivery end-to-end.  
**Resource Requirements:** 1-2 maintainers; part-time reviewer/tester support.

### MVP Feature Set (Phase 1)
**Core Journeys:** Project lead success path, implementer execution, reviewer validation.  
**Must-Have Capabilities:** spec protocol, tier routing, evidence reporting, feature tracking, opt-in SDD.

### Post-MVP Features
**Phase 2 (Growth):** Two-layer verification, failure-pattern loop, lifecycle gates, agent extensions.  
**Phase 3 (Expansion):** Optional constitution, reusable templates, metrics feedback, autonomous continuation.

### Risk Mitigation Strategy
**Technical Risks:** Spec complexity and governance overhead -> keep MVP minimal, enforce 7x7, move logic to skills.  
**Market Risks:** Perceived overhead -> prove continuity and reduced rework with a single end-to-end case.  
**Resource Risks:** Limited bandwidth -> prioritize automation that preserves continuity.

## Functional Requirements

### Spec Authoring & Protocol
- FR1: Planner can define a YAML spec packet with required fields (version, intent, assertions, constraints, file_scope).  
- FR2: Spec packets can be embedded inline in task descriptions with explicit delimiters.  
- FR3: Specs can enforce controlled vocabulary (MUST/SHOULD/MAY/MUST NOT).  
- FR4: Specs can enforce assertion quality (specific observables required).  
- FR5: Specs can enforce 7x7 constraints (max 7 tasks/feature, max 7 assertions/task).  

### Dispatch & Routing
- FR6: Dispatch loop can detect SDD mode via `spec-protocol.md` presence.  
- FR7: Dispatch loop can classify spec tiers (TRIVIAL/SIMPLE/MODERATE/COMPLEX).  
- FR8: Dispatch loop can route tasks based on spec tier and model complexity.  
- FR9: Dispatch loop can re-dispatch tasks when NEEDS_RESPEC is signaled.  
- FR10: Dispatch loop can re-classify and re-dispatch on ESCALATED complexity.  

### Spec Execution & Evidence
- FR11: Implementer can execute tasks against inline spec packets.  
- FR12: Implementer can report assertion evidence with file:line references.  
- FR13: Task completion can require PASS/FAIL evidence for every assertion.  

### Spec Overview & Lifecycle
- FR14: Planner can generate spec overview documents per feature.  
- FR15: Feature specs can transition through defined lifecycle states (DRAFT -> DONE; expanded states when governance enabled).  

### Feature Tracking & Continuity
- FR16: System can maintain a feature tracker with id, title, phase, spec_overview, tasks, verified.  
- FR17: Dispatch loop can update feature tracker phase and verified status automatically.  
- FR18: System can recover from tracker corruption by falling back to non-SDD mode.  

### Verification & Quality Gates
- FR19: System can run spec lint checks on packets before review.  
- FR20: System can audit assertion evidence completeness before review.  
- FR21: System can enforce file_scope constraints against actual changes.  
- FR22: System can trigger two-layer verification (automated then agent review).  

### Agent Specialization
- FR23: Planner can author specs, overview docs, and tracker entries as part of planning.  
- FR24: Reviewer can validate spec compliance and assertion evidence.  
- FR25: Tester can execute assertions independently of implementer evidence.  
- FR26: Tester can run feature-level integration verification.  

### Observability & Resilience
- FR27: Dispatch can generate and propagate a Trace ID for every task.  
- FR28: Artifacts can include Trace IDs for cross-agent debugging.  
- FR29: Reviewer/tester can report upstream trace for CRITICAL issues.  
- FR30: System can enforce escalation protocols and circuit breakers.  
- FR31: Planner can consult failure-patterns and add preventive constraints or document exceptions.  

### Governance & Extensibility
- FR32: Governance can enforce precedence (constitution > spec-protocol > skills > agent freedom).  
- FR33: System can support optional constitution and reusable spec templates.  
- FR34: System can preserve backward compatibility when SDD is absent.  

## Non-Functional Requirements

### Performance
- NFR1: Spec packet parsing and task dispatch remain lightweight enough to keep the main agent under the token budget (<128k total, proactive compaction at ~80k).  
- NFR2: Core workflows avoid unnecessary file reads; inline spec packets are required.  

### Reliability & Continuity
- NFR3: Project state is recoverable from file artifacts and Git history without prior session context.  
- NFR4: System degrades gracefully to non-SDD mode if tracker corruption or malformed specs are detected.  

### Security & Governance
- NFR5: Secret leak prevention enforced via `.gitignore` rules and pre-tooling checks.  
- NFR6: Governance precedence remains consistent (constitution > spec-protocol > skills > agent freedom).  

### Usability (Developer Experience)
- NFR7: Workflow rules are expressed in markdown with zero runtime dependencies.  
- NFR8: CLAUDE.md remains under size constraint; added logic moves to skills.  

### Scalability (Process Scale)
- NFR9: Multi-slice adoption is supported without breaking backward compatibility.
