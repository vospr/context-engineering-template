# Knowledge Base

Curated, persistent topic files that serve as a local RAG cache for the researcher agent.

## How It Works
1. Researcher agent checks this folder BEFORE hitting the web
2. If a topic file exists and is relevant → reuse it (zero tokens spent on search)
3. Files here are version-controlled — they persist across sessions

## When to Add Files
- After a web research session produces reusable findings
- When you have domain knowledge that agents will need repeatedly
- For project-specific conventions, glossaries, or reference data

## File Format
```markdown
# {Topic Name}
**Last Updated:** YYYY-MM-DD
**Scope:** {what this covers}

## Content
{Concise, factual information — optimized for agent consumption}

## See Also
- {links to related knowledge-base files or external docs}
```

## Guidelines
- Keep files focused: one topic per file
- Keep files concise: <100 lines preferred (token efficiency)
- Update `Last Updated` date when modifying
- Delete files that become outdated or irrelevant
- Use kebab-case filenames: `topic-name.md`
