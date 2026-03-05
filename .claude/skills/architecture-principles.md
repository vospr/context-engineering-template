# Architecture Principles

> Customize this file for your project's architectural style and constraints.

## System Type
<!-- Defaults: typical web application. Replace with your system description. -->
- **Type:** Web application {e.g., Web application, CLI tool, API service, Mobile app}
- **Architecture:** Modular monolith {e.g., Monolith, Microservices, Serverless, Modular monolith}
- **Deployment:** Docker/K8s {e.g., Docker/K8s, Vercel, AWS Lambda, bare metal}

## Technology Constraints
<!-- Defaults: common full-stack web. Replace with your hard constraints. -->
- **Must use:** PostgreSQL for persistence, Redis for caching {e.g., PostgreSQL for persistence, Redis for caching}
- **Must avoid:** No premature microservices {e.g., No ORM — use raw SQL, No GraphQL}
- **Compatibility:** Node.js 20+, browsers last 2 versions {e.g., Node.js 18+, Python 3.11+}

## Design Principles (Priority Order)
<!-- Defaults: balanced web project priorities. Reorder for YOUR project. -->
1. Simplicity — prefer boring technology {e.g., Simplicity — prefer boring technology}
2. Correctness — no silent failures {e.g., Correctness — no silent failures}
3. Maintainability — new dev productive in 1 day {e.g., Maintainability — new dev productive in 1 day}
4. Security — validate at system boundaries {e.g., Security — zero trust, validate everything}
5. Performance — p99 latency <500ms {e.g., Performance — p99 latency <200ms}

## Component Boundaries
<!-- Defaults: standard layered web app. Define your real modules. -->
```
src/
  api/        # HTTP handlers, routes, middleware
  services/   # Business logic, domain rules
  data/       # Database access, repositories
  shared/     # Shared utilities, types, constants
```

### Communication Rules
- Components communicate through defined interfaces only {e.g., Components communicate through defined interfaces only}
- No circular dependencies between components {e.g., No circular dependencies between components}
- Shared types in shared/ — no type duplication {e.g., Shared types in shared/ — no type duplication}

## Quality Attributes
<!-- Defaults: balanced web app priorities. Set your own targets. -->
| Attribute | Priority | Target |
|-----------|----------|--------|
| Scalability | MEDIUM | 1000 concurrent users {e.g., 1000 concurrent users} |
| Availability | HIGH | 99.9% uptime {e.g., 99.9% uptime} |
| Security | HIGH | OWASP top 10 compliance {e.g., OWASP top 10 compliance} |
| Performance | MEDIUM | <500ms API response {e.g., <200ms API response} |
| Observability | MEDIUM | Structured logging, error tracking {e.g., structured logging, metrics} |

## Decision Record
All architectural decisions MUST be documented as ADRs in `planning-artifacts/`.
Reference existing ADRs before proposing new architecture.

## Customization Instructions
1. Replace defaults above with your project specifics
2. Reorder design principles by your actual priorities
3. Define your real component boundaries
4. Set realistic quality attribute targets
5. Keep total under 80 lines
