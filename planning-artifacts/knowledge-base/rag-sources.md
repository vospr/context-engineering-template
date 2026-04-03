# RAG Sources for Coding Agents
**Last Updated:** 2026-02-12
**Scope:** Available RAG layers in this template and how to use them

## RAG Layer Priority (researcher checks in this order)

### 1. Local Research Artifacts
- **Path:** `planning-artifacts/YYYY-MM-DD-research-*.md`
- **Freshness:** Reuse if < 7 days old
- **Cost:** 0 tokens (already in local files)

### 2. Knowledge Base (this folder)
- **Path:** `planning-artifacts/knowledge-base/*.md`
- **Freshness:** Managed manually, check `Last Updated` field
- **Cost:** 0 tokens for search, ~100-500 tokens to read

### 3. Context7 (library/framework docs)
- **Tools:** `resolve-library-id` → `get-library-docs`
- **Best for:** API docs, code examples, library-specific questions
- **Cost:** ~500-2000 tokens per query (MCP call + response)

### 4. Directory CLAUDE.md Indexes
- **Paths:** `.claude/agents/CLAUDE.md`, `.claude/skills/CLAUDE.md`, `planning-artifacts/CLAUDE.md`
- **Best for:** Understanding project structure without reading all files
- **Cost:** ~100-200 tokens per index file

### 5. Tavily MCP (web search)
- **Setup:** Requires API key — see `.claude/skills/tavily-setup.md`
- **Best for:** Current events, recent releases, comparisons, community feedback
- **Cost:** ~1000-3000 tokens per search (pre-summarized results)
- **Advantage over WebSearch:** Returns RAG-optimized summaries, not raw HTML

### 6. WebSearch + WebFetch (fallback)
- **Built-in tools, no setup needed**
- **Best for:** When Tavily unavailable or for niche/deep queries
- **Cost:** ~2000-8000 tokens per search+fetch cycle (raw content)

## Token Savings Estimate
| Approach | Tokens per research task |
|----------|------------------------|
| WebSearch only (old) | 5,000 - 15,000 |
| Local-first + Context7 | 500 - 3,000 |
| Local-first + Tavily | 1,000 - 5,000 |
| Full RAG stack | 500 - 5,000 (avg ~2,000) |

Expected savings: **60-80% token reduction** on research tasks.
