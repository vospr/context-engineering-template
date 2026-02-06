# Testing Strategy

> **[PLACEHOLDER]** — Customize this file for your project's test framework and conventions.

## Test Framework
<!-- Replace with your project's test setup -->
- **Framework:** {e.g., Jest, Pytest, Go testing, Cargo test}
- **Assertion library:** {e.g., built-in, Chai, assertpy}
- **Mocking:** {e.g., jest.mock, unittest.mock, testify/mock}

## Test Commands
<!-- Replace with actual commands -->
```bash
# Unit tests
{e.g., npm test, pytest tests/unit, go test ./...}

# Integration tests
{e.g., npm run test:integration, pytest tests/integration}

# End-to-end tests
{e.g., npm run test:e2e, playwright test}

# Coverage report
{e.g., npm run test:coverage, pytest --cov=src}

# Single test file
{e.g., npx jest path/to/test, pytest path/to/test.py}
```

## Test Organization
<!-- Replace with your structure -->
```
tests/
  unit/          # Fast, isolated, no external dependencies
  integration/   # Tests with databases, APIs, file system
  e2e/           # Full user flow tests
  fixtures/      # Shared test data
```

## Naming Conventions
<!-- Replace with your conventions -->
- **Test files:** `{e.g., *.test.ts, test_*.py, *_test.go}`
- **Test names:** `{e.g., "should {behavior} when {condition}"}`
- **Describe blocks:** `{e.g., describe('{ComponentName}', ...)}`

## Mocking Strategy
- Mock external services (APIs, databases) in unit tests
- Use real implementations in integration tests
- Never mock the system under test
- Prefer dependency injection over monkey-patching

## Coverage Requirements
<!-- Set your thresholds -->
- **Minimum coverage:** {e.g., 80%}
- **Critical paths:** {e.g., 100% for auth, payment}
- **New code:** {e.g., must include tests}

## CI/CD Integration
<!-- Replace with your CI setup -->
- Tests run on: {e.g., every push, PR only}
- Pipeline: {e.g., lint → typecheck → unit → integration → e2e}
- Blocking: {e.g., any failure blocks merge}

## Customization Instructions
1. Replace all `{placeholder}` values with your project specifics
2. Add project-specific test patterns or utilities
3. Remove test types you don't use
4. Keep total under 80 lines
