---
name: coding-standards
description: "Loader that detects the project stack and writes planning-artifacts/coding-standards-resolved.md and a short summary from local overrides and pinned, vendored community rules (no network). Use when the coding-standards file is missing or stale, or before the implementer writes code in a new stack."
---

# Coding Standards Loader

> **Skill type:** Behavior — this file contains NO coding rules. It instructs the agent to detect, resolve, and write standards dynamically.

## Step 1: Detect Stack

Scan the project to identify languages and frameworks:
1. Check CLAUDE.md for a `stack:` field
2. Check manifests: `package.json` (TypeScript/JS), `pyproject.toml`/`requirements.txt` (Python), `go.mod` (Go), `Cargo.toml` (Rust), `*.m` files (MATLAB)
3. Fall back to file extension survey (`.ts`, `.py`, `.go`, `.rs`, `.m`)

Write result to `planning-artifacts/detected-stack.json`:
```json
{ "languages": ["typescript", "python"], "detected_from": "manifests", "date": "YYYY-MM-DD" }
```

## Step 2: Resolve Sources

1. Read `coding-standards-sources.yaml` from repo root
2. For each detected language, collect matching source entries
3. Every source is a `local:` file — read it directly (skip if missing). Never fetch URLs.
4. Community rules live in `.claude/skills/coding-standards/vendored/`, pinned to one upstream commit; `vendored/MANIFEST.json` records the commit, licence and sha256 of each file
5. Sort by trust: `override` > `verified` > `community`

## Step 3: Write Resolved Standards

Merge all resolved sources into `planning-artifacts/coding-standards-resolved.md`:
- One `## {Language}` heading per detected language
- Under each heading: paste the resolved rules (override first, then verified, then community)
- Add YAML front-matter: `generated: YYYY-MM-DD`, `sources: [list of files used]`

## Step 4: Write Compressed Summary

Extract the top 15-20 most important imperative rules across all languages.
Write to `planning-artifacts/coding-standards-summary.md`:
- Target: 400 tokens max
- Format: numbered list of imperative statements ("Use X", "Never Y")
- Add front-matter: `generated: YYYY-MM-DD`

This summary survives context compaction and is referenced by agents between sessions.

## Failure Mode

- If `coding-standards-sources.yaml` is missing or empty: write a warning header to `planning-artifacts/coding-standards-resolved.md` and continue — do NOT block dispatch
- If no sources resolve for a language: note it under that language heading
## Updating Vendored Rules (Maintainers, Out of Band)

This skill never fetches anything. To move to newer community rules, a maintainer fetches them from a
specific upstream commit, replaces the files in `vendored/`, updates `commit` and each `sha256` in
`vendored/MANIFEST.json`, and re-runs `checks/run.sh` (check V2 verifies the hashes). Project-specific
rules go in `overrides/` and are listed in `coding-standards-sources.yaml` with `trust: override`.
