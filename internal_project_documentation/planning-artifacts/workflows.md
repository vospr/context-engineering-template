# Core Workflows

## 1. Dispatch Loop (Baseline Template Workflow)
The main agent acts as a stateless dispatcher. It reads the current state, selects the next task, matches the best agent, classifies complexity, dispatches, processes results, and repeats. This loop is intentionally minimal and depends on file-based artifacts for continuity.

## 2. Spec-Driven Development (SDD) Workflow
When the spec protocol is present, the system shifts to spec-driven execution:
- Planner authors spec packets (YAML) and, for larger work, a human-readable spec overview.
- Spec packets are embedded inline in task descriptions to avoid extra file reads.
- Implementer executes against assertions and reports evidence with file and line references.
- Reviewer/tester validate according to the spec and quality gates.

## 3. Thin Vertical Slice Delivery
Work is organized into slices that build capabilities progressively:
- Slice 1: Spec packets, controlled vocabulary, inline assertions, post-task audit.
- Slice 2: Feature tracker for continuity and zero-handoff resumption.
- Slice 3: Governance and verification gates (optional constitution).
- Slice 4: Scaled agent extensions and reusable spec templates.

## 4. Dynamic Coding Standards Loading
Before the dispatch loop runs, Step 0 checks if resolved coding standards are current:
- If `planning-artifacts/coding-standards-resolved.md` is missing or stale → dispatch implementer with coding-standards loader skill
- Loader detects stack, resolves sources from `coding-standards-sources.yaml`, merges by trust priority, writes resolved + summary artifacts
- Non-blocking: if the loader fails, dispatch continues normally
- Cache population for remote sources is a separate one-time researcher dispatch or manual step

## 5. Planning and Epics
Requirements are decomposed into epics and stories that map to the delivery slices. This provides a structured path from architecture decisions to implementable tasks.

## Sources
- README.md
- internal_project_documentation/planning-artifacts/epics.md
