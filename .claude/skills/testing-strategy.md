<!-- STATUS: TEMPLATE — replace {e.g., ...} placeholders before use -->
# Testing Strategy

> Customize this file for your project's test framework and conventions.

## Test Framework
<!-- Defaults: Node.js/TypeScript stack. Adjust for your stack. -->
- **Framework:** Jest {e.g., Jest, Vitest, Pytest, Go testing, Cargo test}
- **Assertion library:** built-in (Jest expect) {e.g., built-in, Chai, assertpy}
- **Mocking:** jest.mock {e.g., jest.mock, unittest.mock, testify/mock}

## Test Commands
<!-- Defaults: npm-based. Replace with your project's actual commands. -->
```bash
# Unit tests
npm test {e.g., npm test, pytest tests/unit, go test ./...}

# Integration tests
npm run test:integration {e.g., npm run test:integration, pytest tests/integration}

# End-to-end tests
npx playwright test {e.g., npm run test:e2e, playwright test}

# Coverage report
npm run test:coverage {e.g., npm run test:coverage, pytest --cov=src}

# Single test file
npx jest path/to/test {e.g., npx jest path/to/test, pytest path/to/test.py}
```

## Test Organization
<!-- Defaults: standard layout. Adjust paths for your project. -->
```
tests/
  unit/          # Fast, isolated, no external dependencies
  integration/   # Tests with databases, APIs, file system
  e2e/           # Full user flow tests
  fixtures/      # Shared test data
```

## Naming Conventions
<!-- Defaults: TypeScript/Jest conventions. -->
- **Test files:** `*.test.ts` {e.g., *.test.ts, test_*.py, *_test.go}
- **Test names:** `"should {behavior} when {condition}"` {e.g., "should return 404 when user not found"}
- **Describe blocks:** `describe('{ComponentName}', ...)` {e.g., describe('UserService', ...)}

## Mocking Strategy
- Mock external services (APIs, databases) in unit tests
- Use real implementations in integration tests
- Never mock the system under test
- Prefer dependency injection over monkey-patching

## Coverage Requirements
<!-- Defaults: industry-standard thresholds. Adjust for your risk tolerance. -->
- **Minimum coverage:** 80% {e.g., 80%, 70%, 90%}
- **Critical paths:** 100% for auth, payment {e.g., 100% for auth, payment, data mutations}
- **New code:** must include tests {e.g., must include tests, no exceptions}

## CI/CD Integration
<!-- Defaults: PR-gated pipeline. Adjust for your CI setup. -->
- Tests run on: every PR {e.g., every push, PR only, nightly}
- Pipeline: lint → typecheck → unit → integration → e2e {e.g., lint → typecheck → unit → integration → e2e}
- Blocking: any failure blocks merge {e.g., any failure blocks merge, only critical}

## Customization Instructions
1. Replace defaults above with your project's actual commands and tools
2. Add project-specific test patterns or utilities
3. Remove test types you don't use
4. Keep total under 80 lines
