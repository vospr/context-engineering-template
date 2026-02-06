# Architecture Principles

> **[PLACEHOLDER]** — Customize this file for your project's architectural style and constraints.

## System Type
<!-- Replace with your system description -->
- **Type:** {e.g., Web application, CLI tool, API service, Mobile app}
- **Architecture:** {e.g., Monolith, Microservices, Serverless, Modular monolith}
- **Deployment:** {e.g., Docker/K8s, Vercel, AWS Lambda, bare metal}

## Technology Constraints
<!-- List hard constraints -->
- **Must use:** {e.g., PostgreSQL for persistence, Redis for caching}
- **Must avoid:** {e.g., No ORM — use raw SQL, No GraphQL}
- **Compatibility:** {e.g., Must support Node.js 18+, browsers last 2 versions}

## Design Principles (Priority Order)
<!-- Rank by importance for YOUR project -->
1. {e.g., Simplicity — prefer boring technology}
2. {e.g., Correctness — no silent failures}
3. {e.g., Maintainability — new dev productive in 1 day}
4. {e.g., Performance — p99 latency <200ms}
5. {e.g., Security — zero trust, validate everything}

## Component Boundaries
<!-- Define your system's modules -->
```
{component-1}/    # {responsibility}
{component-2}/    # {responsibility}
{component-3}/    # {responsibility}
shared/           # {shared utilities, types}
```

### Communication Rules
- {e.g., Components communicate through defined interfaces only}
- {e.g., No circular dependencies between components}
- {e.g., Shared types in shared/ — no type duplication}

## Quality Attributes
<!-- Set priorities: HIGH, MEDIUM, LOW -->
| Attribute | Priority | Target |
|-----------|----------|--------|
| Scalability | {HIGH/MED/LOW} | {e.g., 1000 concurrent users} |
| Availability | {HIGH/MED/LOW} | {e.g., 99.9% uptime} |
| Security | {HIGH/MED/LOW} | {e.g., OWASP top 10 compliance} |
| Performance | {HIGH/MED/LOW} | {e.g., <200ms API response} |
| Observability | {HIGH/MED/LOW} | {e.g., structured logging, metrics} |

## Decision Record
All architectural decisions MUST be documented as ADRs in `planning-artifacts/`.
Reference existing ADRs before proposing new architecture.

## Customization Instructions
1. Replace all `{placeholder}` values with your project specifics
2. Reorder design principles by your actual priorities
3. Define your real component boundaries
4. Set realistic quality attribute targets
5. Keep total under 80 lines
