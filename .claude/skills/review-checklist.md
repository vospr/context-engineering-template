# Code Review Checklist

> **[PLACEHOLDER]** — Customize severity thresholds and automated checks for your project.

## Automated Checks (Run Before Manual Review)
<!-- Replace with your project's commands -->
- [ ] Linter passes: `{e.g., npm run lint}`
- [ ] Type checker passes: `{e.g., npx tsc --noEmit}`
- [ ] Tests pass: `{e.g., npm test}`
- [ ] Build succeeds: `{e.g., npm run build}`

## Code Quality Checklist

### Correctness
- [ ] Code does what the task description requires
- [ ] Edge cases handled (null, empty, boundary values)
- [ ] Error handling is appropriate (not swallowed, not excessive)
- [ ] No obvious bugs or logic errors

### Readability
- [ ] Names are clear and descriptive
- [ ] Functions are focused (single responsibility)
- [ ] No unnecessary complexity or over-engineering
- [ ] Comments explain WHY, not WHAT (if present)

### Architecture
- [ ] Follows established patterns from ADRs
- [ ] No new dependencies without justification
- [ ] Respects component boundaries
- [ ] Changes are within the scope of the task

### Testing
- [ ] New code has corresponding tests
- [ ] Tests cover the happy path and key edge cases
- [ ] Tests are deterministic (no flaky tests)
- [ ] Test names describe the behavior being verified

### Security
- [ ] No hardcoded secrets, tokens, or credentials
- [ ] User input is validated/sanitized
- [ ] No SQL injection, XSS, or command injection vectors
- [ ] Authentication/authorization checks present where needed

### Performance
- [ ] No obvious N+1 queries or unbounded loops
- [ ] Large data sets handled with pagination/streaming
- [ ] No blocking operations in async contexts

## Severity Guidelines
- **CRITICAL**: Security vulnerabilities, data corruption, crashes, incorrect business logic
- **MAJOR**: Missing error handling, missing tests, architecture violations, performance issues
- **MINOR**: Naming improvements, minor refactoring opportunities, documentation gaps

## Customization Instructions
1. Replace automated check commands with your project's actual commands
2. Add project-specific checklist items
3. Adjust severity definitions for your risk tolerance
4. Keep total under 80 lines
