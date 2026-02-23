# Local Standards Overrides

Files in this directory provide project-specific coding standards that
override remote and community sources.

## How It Works
- Reference these files from `coding-standards-sources.yaml` with `trust: override`
- Override sources always win over `verified` and `community` sources
- The loader skill merges overrides on top of other sources per language

## Naming Convention
Name files by language: `{language}.md` (e.g., `typescript.md`, `python.md`)

## Format
Write rules as imperative statements ("Use X", "Never Y", "Prefer Z").
