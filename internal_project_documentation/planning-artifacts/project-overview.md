# Project Overview

## Purpose
This project is a reusable, markdown-first template that turns Claude Code into a context-engineered, multi-agent system. The template emphasizes orchestration behavior, quality gates, and durable execution context rather than runtime code. It is designed to start new projects with a production-style multi-agent workflow while keeping context usage controlled and recoverable through files and Git lineage.

## Scope Boundaries
- In scope: Agent orchestration rules, skills, file-based artifacts, planning and implementation artifacts, and documentation that define how the system behaves.
- Out of scope: Runtime services, external infrastructure, and application business logic for a specific product.
- Zero-runtime constraint: The system behavior is encoded in markdown files; no build or runtime dependencies are introduced by the template itself.

## Stakeholders
- Primary facilitator/maintainer: Andrey
- Users: Project teams adopting the template for multi-agent delivery

## Success Metrics (Minimal)
- New projects can start with the template and complete work with consistent multi-agent execution.
- The system remains markdown-first and zero-runtime while retaining recoverable state in files.
- Spec-driven development (SDD) can be adopted incrementally without breaking existing workflows.

## Sources
- README.md
- internal_project_documentation/brainstorming/brainstorming-session-2026-02-17.md
- internal_project_documentation/planning-artifacts/epics.md
