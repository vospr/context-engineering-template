# Skills Directory

Reusable instruction modules that agents can reference for domain-specific guidance.
Skills are loaded into agent context via the `skills` frontmatter field.

## Skill Inventory
| Skill | Used By | Purpose |
|-------|---------|---------|
| git-workflow | all agents | Branch naming, commit format, PR workflow |
| coding-standards | implementer | Code style, naming conventions, patterns |
| review-checklist | reviewer | Review criteria, severity classification |
| testing-strategy | tester | Test types, coverage targets, frameworks |
| architecture-principles | architect | Design constraints, component boundaries |
| tavily-setup | researcher | Tavily MCP setup, API key config, web search tools |

## Customization
All skills except `git-workflow` and `tavily-setup` are placeholders — customize for your project.
Keep each skill under 80 lines for token efficiency.
