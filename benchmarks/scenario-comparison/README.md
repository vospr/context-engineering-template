# Scenario comparison (February 2026)

Four runs of Claude Code on small Node.js tasks, with and without this template, written up between
2026-02-13 and 2026-02-18. The reports were deleted from the repo on 2026-02-19 (commit `48f565e`,
branch `sdd-engineering`) and are restored here **unchanged** from the commit before the deletion
(`48f565e^`). `checks/run.sh` check B1 verifies they are byte-identical to that commit.

| File | What it is |
|---|---|
| [SCENARIOA-vs-SCENARIOB-REPORT-2026-02-13.md](SCENARIOA-vs-SCENARIOB-REPORT-2026-02-13.md) | Main report: A/B/C/D compared on scope, tests, coverage, lint, tokens |
| [comparison.md](comparison.md) | A vs B by context-engineering stage (offloading, retrieval, isolation, ...) |
| [SCENARIOD-execution-estimate.md](SCENARIOD-execution-estimate.md) | Scenario D plan and per-agent token estimate |

## The scenarios

| | Task | Setup | Prompts |
|---|---|---|---|
| A | Todo REST API | Full template, dispatcher + 13 subagent dispatches | Multiple, plus a fix session |
| B | Todo REST API | Bare project, no agents/skills | Not recorded |
| C | Todo REST API | Template assets, one autonomous prompt | 1 |
| D | `GET /health` endpoint | Template in SDD mode; tests the spec pipeline, not code quality | 1 |

## What the numbers say

From the main report:

- **A** is the broadest result (SQLite, 282 tests, 3,962 LOC) but **failed first-pass quality**: 246 lint
  errors and a failing coverage gate had to be fixed afterwards, and coverage still relies on 4 file exclusions.
- **B** is the simplest: in-memory store, 53 tests, 71.31% statement coverage, no lint script.
- **C** is the cleanest first pass: TypeScript strict, 12 tests, lint clean on the first run,
  87.14% statements / 91.66% branches with no exclusions, none of A's four quality issues.
- **D** checks the SDD machinery: 19 of 22 behavioural checks effective (18 pass, 1 fail, 2 partial), 6/6 tests.

Tokens:

| | Tokens | Status of the figure |
|---|---|---|
| A | **613,670** | Logged in the run's `planning-artifacts/session-token-usage.md` (cited by the report) |
| B | unknown | Not recorded: no token artifact |
| C | "est. <100k" | Estimate, not logged |
| D | ~58,000–87,000 | Estimate. First estimated at 47,000–72,000, then revised and relabelled "Actual Metrics" in commit `af1a84d`; the range matches the per-agent estimate table in `SCENARIOD-execution-estimate.md` |

## Limits: read these before quoting a number

1. **One run per scenario, self-assessed** by the same author who built the template.
2. **The 613,670 figure is the only logged token count**, and its source file `session-token-usage.md`
   is not in this repo: it lived in the run's own folder and was never committed on any branch.
3. **There is no baseline token number.** Scenario B's tokens are unknown, so the data cannot say
   "the template costs N× a bare run".
4. **C and D tokens are estimates.** The ratio A ÷ C is at least 6.1× if C's "<100k" estimate holds.
   A ÷ D is 7.1–10.6× against the 58k–87k estimate, but D is a different, smaller task.
   "Roughly 10× the tokens" is therefore an order-of-magnitude reading of a logged figure against estimates,
   not a measurement.
5. The report cites files on the author's machine (`C:\Users\...\ScenarioA` and others) that are
   not in this repo. The scenario code itself was never committed.
6. Scenario D's guidance file and a later Scenario E guide existed on other branches; they are prompts
   rather than results and are not restored here.

What the data does support: on one task, the full multi-prompt pipeline (A) bought scope, traceability
and auditable artifacts. It did not buy better first-pass code; the single-prompt run (C) was cleaner.
It also used an order of magnitude more tokens than the single-prompt runs were estimated to need.

## Re-running

Not re-runnable as committed: the scenario projects and prompts lived outside the repo.
A re-runnable benchmark (fixed prompt, logged token counts for all arms incl. a bare baseline) is the
obvious next step and is not done.
