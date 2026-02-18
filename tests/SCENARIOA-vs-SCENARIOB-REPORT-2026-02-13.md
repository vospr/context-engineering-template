# ScenarioA vs ScenarioB vs ScenarioC vs ScenarioD Comparison Report

Date: 2026-02-13 (original), updated 2026-02-18 with ScenarioC and ScenarioD
Scope: Compare actual realizations in `ScenarioA`, `ScenarioB`, and `scenario3` (ScenarioC).

## Evaluation Method
- Reviewed structure, source code, tests, planning/implementation artifacts, and package/tooling configuration.
- Executed commands:
  - ScenarioA:
    - `npm.cmd run lint` (passes)
    - `npm.cmd test -- --coverage --runInBand` (passes; thresholds satisfied)
  - ScenarioB:
    - `npm.cmd test -- --coverage --runInBand` (passes)
    - `npm.cmd run lint` (fails because script is not defined)
  - ScenarioC:
    - `npm run lint` (passes, zero errors)
    - `npx jest --coverage --runInBand` (passes, 12/12 tests, no exclusions needed)
- Revalidated ScenarioA governance artifacts and bootstrap behavior:
  - `planning-artifacts/decisions.md`
  - `src/config/database.js`
  - `src/server.js`

## Executive Summary

ScenarioA remains the most comprehensive in scope (persistent storage, 282 tests, layered architecture), but required a post-hoc quality-fix pass to get its gates green and still relies on coverage exclusions.

ScenarioB is the simplest baseline (in-memory, no lint, 53 tests).

**ScenarioC is the best result on first-pass quality.** It delivered a clean TypeScript vertical slice in a single autonomous prompt with zero quality-gate issues out of the box: lint passes, tests pass, coverage is honest (87% with no exclusions), and none of the four quality anti-patterns found in ScenarioA were present. Its scope is narrower than A but its quality-per-line-of-code is the highest of the three.

**ScenarioD validates the SDD pipeline itself** — not code quality or scope, but whether the spec-driven development machinery (spec packets, tier routing, assertion evidence, feature tracker) works end-to-end. It targets a minimal health check endpoint specifically to keep implementation scope small while exercising all SDD behavioral contracts. ScenarioD is Case A only (requires the template with spec-protocol.md).

## Summary Table

| Dimension | ScenarioA (Post-Fix) | ScenarioB | ScenarioC | ScenarioD (Estimated) | Assessment |
|---|---|---|---|---|---|
| Language | JavaScript (ES6) | JavaScript (ES6) | **TypeScript (strict)** | JavaScript (ES6) | C has strongest type safety |
| Scope/Architecture | Layered API (app, routes, controllers, model, middleware, DB config) | Single app + in-memory array + small model helper | Layered API (types, repo, routes, app) | Minimal (app, routes/health, server) | A most comprehensive; D intentionally minimal |
| Codebase Size | 15 JS files, 3962 LOC | 6 JS files, 719 LOC | 6 TS files, ~335 LOC | ~5 files, ~100 LOC (est.) | D smallest by design |
| CE Assets | 8 agents, 7 skills, 11 planning artifacts, 15 impl artifacts | `.claude/settings.local.json` only | 6 agents, 6 skills, 1 impl artifact | 6 agents, 7 skills, spec packets + feature tracker | D exercises SDD-specific assets |
| Data Layer | SQLite with schema, constraints, indexes | In-memory array (`const todos = []`) | In-memory Map (O(1) lookups) | None (stateless health check) | A only persistent option |
| Test Volume | 282 tests, 4 suites (all passing) | 53 tests, 2 suites (all passing) | 12 tests, 1 suite (all passing) | ~4-6 tests, 1 suite (est.) | A deepest; D minimal |
| Coverage | 96.81% stmts (with 4 file exclusions) | 71.31% stmts, no thresholds | **87.14% stmts, 91.66% branch, no exclusions** | Est. >90% (tiny codebase) | C most honest coverage |
| Linting | Passes (after fix of 246 errors) | No lint script | **Passes clean from first run** | Expected clean | C best lint discipline |
| Documentation | Detailed API/ops README, status/token artifacts | General template README | Comprehensive README (415 lines) | Spec packets + evidence report + feature tracker | D artifacts are SDD-focused |
| Primary Validation Target | Code quality + scope | Baseline comparison | First-pass autonomous quality | **SDD pipeline behavioral validation** | Each scenario tests different dimension |
| First-Pass Quality | **Failed** (4 issues required fix pass) | Partial (no lint gate) | **Clean** (zero issues on first run) | Expected clean (minimal scope) | C and D expected to be clean |
| Execution Model | Multi-prompt, 13 subagent dispatches, 613k tokens | Unknown (no token artifact) | **Single prompt**, autonomous | **Single prompt**, autonomous, 47-72k tokens (est.) | C and D most token-efficient |

## Detailed Findings

### ScenarioA (Post-Fix)
Strengths:
- Clear layered architecture (`src/app.js`, `src/routes/todoRoutes.js`, `src/controllers/todoController.js`, `src/models/Todo.js`).
- Persistent DB schema and indexing (`src/config/database.js`).
- Strong test breadth (unit + integration) with 282 passing tests.
- Lint gate passes (`npm.cmd run lint`).
- Coverage command passes with thresholds met (`npm.cmd test -- --coverage --runInBand`).
- Decision log aligned to implemented baseline (`planning-artifacts/decisions.md` now consistent with SQLite/Express4 current state).
- DB bootstrap error ownership moved to entrypoint (`src/server.js`), no module-level `process.exit(1)` in `src/config/database.js`.

Tradeoffs / Residual Risks:
- Coverage success now depends on explicit exclusions for:
  - `src/sample-app.js`
  - `src/sample-util.js`
  - `src/config/database.js`
  - `src/middleware/errorHandler.js`
  This is valid for gate stabilization, but means these files are outside enforced threshold scope.
- Authentication and multi-tenant boundaries remain deferred (by documented decision), so this is not a full production multi-user architecture.

Execution Complexity Evidence:
- Documented total token burn: 613,670 tokens across dispatcher + 13 subagent dispatches (`planning-artifacts/session-token-usage.md`).
- Higher operational overhead, but traceable and auditable process.

### ScenarioB
Strengths:
- Simpler code path and lower cognitive load.
- Tests pass quickly with decent baseline coverage for implemented scope.
- Security-oriented fixes in core API path (query validation, immutable update behavior, sanitization in model).

Weaknesses / Risks:
- No persistence (`src/sample-app.js` in-memory store), so not production-safe for real workloads.
- No lint script/quality gate in package scripts (`npm run lint` missing).
- Minimal orchestration and delivery artifacts (no planning/decision/status logs).
- Narrower architecture and fewer operational concerns covered.

Execution Complexity Evidence:
- No execution-token/process artifact equivalent to ScenarioA found.
- Lower build/runtime complexity appears intentional for baseline comparison.

### ScenarioC (New — Case A with SDD Template)
Strengths:
- **TypeScript with strict mode** — strongest type safety of all three scenarios.
- **Zero first-pass quality issues** — lint passes, tests pass, coverage honest, no exclusions.
- Clean layered architecture: `types/todo.ts` → `repositories/todo.repository.ts` → `routes/todo.routes.ts` → `app.ts`.
- DTO pattern (`CreateTodoDto`, `UpdateTodoDto`) for request payloads — proper API design.
- In-memory Map with O(1) lookups (better data structure than ScenarioB's array).
- UUID v4 for IDs (vs sequential/auto-increment in A/B).
- Full CE template deployed (6 agents, 6 skills, spec-protocol.md).
- **Single-prompt autonomous execution** — entire slice delivered without follow-up interaction.
- Micro-commit discipline with `[T-id]` prefixes.
- Pre-commit hook for secret leak prevention in `.claude/settings.json`.
- Proper 404 JSON handler (not default Express HTML).

Weaknesses / Risks:
- No persistent storage (in-memory Map, same class of limitation as ScenarioB).
- Only 12 tests (covers all CRUD + lifecycle, but fewer edge cases than A's 282).
- No test isolation — singleton repository not reset between tests (potential test pollution).
- No input type validation beyond string checks (no Joi/Zod schema).
- No pagination on GET /todos.
- No graceful shutdown handler.
- Placeholder skills not customized (`coding-standards.md`, `testing-strategy.md`, `architecture-principles.md` are templates).
- No `planning-artifacts/decisions.md` or `project-status.md` created.

Quality Gate Evidence:
```
Lint:  npm run lint → 0 errors (clean pass)
Tests: 12 passed, 12 total
Coverage (no exclusions):
  Statements: 87.14%
  Branches:   91.66%
  Functions:  84.61%
  Lines:      86.95%
```

Uncovered lines are limited to:
- `app.ts:11,15-16` (global error handler — untested but correct pattern)
- `todo.repository.ts:36` (branch: update non-existent item, partially tested)
- `todo.routes.ts:12,24,39,56,65,77` (catch blocks for 500 errors — hard to trigger in tests)

### ScenarioD (Estimated — SDD Behavioral Validation)

**Focus:** Validates the SDD spec-driven development pipeline, not code quality or implementation scope.

**What It Proves (22 Behavioral Checks):**
- Spec packets authored with YAML format, controlled vocabulary (MUST/MUST NOT), and double-entry assertions
- Tier classification (SIMPLE) with reasoning referencing spec-protocol.md decision table
- Evidence reporting in `{id}: PASS|FAIL — {file}:{line}` format covering all assertion IDs
- Feature tracker (`feature-tracker.json`) created with valid schema and correct phase state
- Session continuity: cold-start session can reconstruct state from files alone
- Agent orchestration: planner, implementer, and verifier dispatched

**Key Difference from Other Scenarios:**
- Scenarios A/B/C test whether the agent can **build software** (code quality, tests, scope)
- Scenario D tests whether the **SDD machinery orchestrates correctly** (spec lifecycle, tier routing, assertion evidence, feature tracking)

**Pre-Execution Fix:**
The initial attempt revealed 11 confirmation prompts in `.claude/settings.local.json` that blocked autonomous execution. These have been resolved by adding 12 new bash permission patterns (git -C, cd, npm install, test, mkdir, curl, timeout, node, kill, bash -c, etc.).

**Expected Metrics:**
- Tokens: ~47,000–72,000 (well within 128k budget)
- Interaction count: 1 (single prompt)
- Agents dispatched: planner, implementer, tester/reviewer
- Behavioral checks: 20-22 / 22 expected (≥18 required)

## ScenarioC vs ScenarioA Quality Issues Assessment

The four quality issues documented in `SCENARIOA_quality_issues.md` were:

| Quality Issue | ScenarioA (Pre-Fix) | ScenarioC |
|---|---|---|
| 1. Lint gate fails (246 errors) | **FAILED** — linebreak-style + unused args | **NOT PRESENT** — lint clean from first run |
| 2. Coverage gate fails | **FAILED** — sample files with 0% coverage | **NOT PRESENT** — 87% coverage, no exclusions |
| 3. Hard `process.exit(1)` in module | **PRESENT** in `src/config/database.js` | **NOT PRESENT** — no process.exit anywhere |
| 4. Decision log inconsistent | **PRESENT** — docs say PostgreSQL, code uses SQLite | **NOT PRESENT** — no contradictory decision docs |

**Verdict: ScenarioC avoids all four ScenarioA quality anti-patterns.** The SDD template and TypeScript strict mode appear to have enforced better discipline from the start.

## Scoring (1-5)

| Scenario | Implementation Complexity | Quality (Current State) | Production Readiness | First-Pass Quality | SDD Pipeline Validation |
|---|---:|---:|---:|---:|---:|
| ScenarioA (Post-Fix) | 5.0 | 4.3 | 3.8 | 2.0 | N/A |
| ScenarioB | 2.0 | 3.0 | 1.5 | 3.0 | N/A |
| ScenarioC | 3.0 | 4.5 | 2.5 | **5.0** | N/A |
| ScenarioD (Est.) | 1.0 | N/A | N/A | 4.5 (est.) | **5.0 (est.)** |

Interpretation:
- **Complexity:** A >> C > B. ScenarioA has broadest architectural scope; ScenarioC is a well-structured middle ground.
- **Quality:** ScenarioC edges out A on current quality because its coverage is honest (no exclusions) and TypeScript strict mode eliminates classes of bugs. A has higher raw coverage number but relies on exclusions.
- **Production readiness:** A leads because of persistent storage and deeper test coverage. C is a solid foundation but needs a database and more tests.
- **First-pass quality (new metric):** ScenarioC is the only scenario that delivered green quality gates on the first run with zero post-hoc fixes required. This is the strongest differentiator.

## Efficiency Comparison

| Metric | ScenarioA | ScenarioB | ScenarioC | ScenarioD (Est.) |
|---|---|---|---|---|
| Token burn | 613,670 | Unknown | Single-prompt (est. <100k) | Est. 47,000–72,000 |
| User interactions | Multiple prompts + fix session | Unknown | **1 (single prompt)** | **1 (single prompt)** |
| Subagent dispatches | 13 | N/A | Autonomous | 4-6 (planner, implementer, tester/reviewer) |
| Quality fix passes needed | 1 full pass (4 issues) | N/A | **0** | **0** (expected) |
| Time to green gates | Multiple sessions | Never (no lint gate) | **First session** | **First session** (expected) |
| Behavioral checks | N/A | N/A | N/A | **20-22 / 22** (expected) |

## Recommended Next Actions
1. ScenarioA: decide whether coverage exclusions are permanent policy or interim.
   - If permanent, document rationale in README/quality policy.
   - If interim, add focused tests for `database.js` and `errorHandler.js`, then re-include them.
2. ScenarioA: align README/setup text with updated architecture decisions for full governance consistency.
3. ScenarioB: if promoted beyond baseline, add persistent datastore, lint/coverage thresholds, and structured error/ops conventions.
4. ScenarioC: add persistent datastore (SQLite or PostgreSQL) to match A's production readiness.
5. ScenarioC: add test isolation (`beforeEach` repository reset) and expand edge-case tests.
6. ScenarioC: fill in placeholder skills with project-specific content.
7. ScenarioC: create `planning-artifacts/decisions.md` to document architecture choices.
8. ScenarioD: execute in clean state with updated permissions and validate 22 behavioral checks.
9. ScenarioD: after execution, update this report with actual metrics replacing estimates.
10. ScenarioD: update README.md with validation results section.

## Key Evidence References
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\package.json`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\.eslintrc.json`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\src\config\database.js`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\src\server.js`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\src\models\Todo.js`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\planning-artifacts\session-token-usage.md`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioA\planning-artifacts\decisions.md`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioB\package.json`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioB\src\sample-app.js`
- `C:\Users\AndreyPopov\Documents\EPAM\ScenarioB\src\models\todo.js`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\package.json`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\tsconfig.json`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\.eslintrc.json`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\src\types\todo.ts`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\src\repositories\todo.repository.ts`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\src\routes\todo.routes.ts`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\src\app.ts`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\tests\todo.test.ts`
- `C:\Users\AndreyPopov\Documents\EPAM\scenario3\implementation-artifacts\2026-02-18-impl-todo-api.md`
- `C:\Users\AndreyPopov\Documents\EPAM\Project_Template_backup\tests\SCENARIOD-guidance.md`
- `C:\Users\AndreyPopov\Documents\EPAM\Project_Template_backup\tests\SCENARIOD-execution-estimate.md`
- `C:\Users\AndreyPopov\Documents\EPAM\Project_Template_backup\tests\Screen1.png` through `Screen11.png`
- `C:\Users\AndreyPopov\Documents\EPAM\scenarioD\` (target execution directory)

## Scenario Comparison Matrix

| Aspect | Scenario A | Scenario B | Scenario C | Scenario D |
|--------|-----------|-----------|-----------|-----------|
| **Focus** | Full-scope implementation | Baseline comparison | Autonomous first-pass quality | SDD pipeline behavioral validation |
| **What it proves** | Agent can build comprehensive API | Bare minimum without template | Agent delivers clean code in one prompt | SDD spec lifecycle works end-to-end |
| **Template required** | Yes (Case A) | No (Case B) | Yes (Case A) | Yes (Case A only) |
| **Prompt count** | Multiple | Unknown | 1 | 1 |
| **Key artifact** | Working API + 282 tests | Simple API + 53 tests | Clean TypeScript + 12 tests | Spec packets + evidence + feature tracker |
| **Pass gate** | Code quality, coverage thresholds | Tests pass | Zero first-pass issues | 22 behavioral checks (≥18 to pass) |
| **SDD-specific** | No | No | No | **Yes** |
