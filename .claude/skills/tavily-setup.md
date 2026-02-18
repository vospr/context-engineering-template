# Tavily MCP Integration

## Why Tavily
- RAG-optimized output: pre-summarized results ready for LLM consumption
- 60-70% fewer tokens vs raw WebSearch + WebFetch
- 800k+ developer ecosystem, 26k weekly npm downloads
- Remote HTTP mode — no local dependencies required

## Setup Options

### Option A: NPX (Recommended for Claude Code)
```bash
claude mcp add tavily -- npx -y tavily-mcp@latest
```
Then set the API key in your environment:
```bash
# Linux/Mac
export TAVILY_API_KEY="tvly-YOUR_KEY_HERE"

# Windows (PowerShell)
$env:TAVILY_API_KEY = "tvly-YOUR_KEY_HERE"

# Or add to .claude/settings.json mcpServers section:
# "tavily": {
#   "command": "npx",
#   "args": ["-y", "tavily-mcp@latest"],
#   "env": { "TAVILY_API_KEY": "tvly-YOUR_KEY_HERE" }
# }
```

### Option B: Remote HTTP (No Local Deps)
```bash
claude mcp add --transport http tavily https://mcp.tavily.com/mcp/?tavilyApiKey=tvly-YOUR_KEY_HERE
```

### Get API Key
1. Go to https://app.tavily.com
2. Sign up (free tier: 1,000 credits/month)
3. Copy your API key

## Available Tools (after setup)
- `tavily-search` — Web search with RAG-optimized summaries
- `tavily-extract` — Extract structured content from specific URLs
- `tavily-map` — Discover URLs on a domain (sitemap alternative)
- `tavily-crawl` — Deep crawl a site for comprehensive content

## Integration with Researcher Agent
Once Tavily is configured, the researcher agent can use it as an alternative to WebSearch.
Update the researcher agent's tools list to include Tavily tools when available.

The researcher still follows the local-first priority:
1. Check local artifacts and knowledge-base
2. Check Context7 for library docs
3. Use Tavily for web research (preferred over raw WebSearch)
4. Fall back to WebSearch + WebFetch if Tavily unavailable

## Cost Management
- Free tier: 1,000 credits/month (sufficient for small projects)
- Basic search: 1 credit per query
- Advanced search: 2 credits per query
- Extract: 1-5 credits depending on content size
