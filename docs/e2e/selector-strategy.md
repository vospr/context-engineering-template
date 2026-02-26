# UI Selector Strategy Checklist

## Metadata

- Owner: Frontend Lead
- Status: N/A (Path A)
- Priority: P1
- Last Updated: 2026-02-26
- Reviewer: QA Lead

## Goal

Define stable UI locator rules for maintainable E2E tests.

## Checklist

- [x] Preferred locator order defined.
- [x] `data-testid` naming convention defined.
- [ ] Rules for dynamic content selectors defined. (Blocked: no UI surface)
- [x] Rules for avoiding brittle CSS/XPath selectors defined.
- [ ] Shared helper approach documented. (Blocked: no test framework)
- [x] Accessibility locator usage documented.

## Standard

## Locator Priority
1. Role + accessible name
2. Label/text
3. `data-testid`
4. Stable attribute fallback

## Naming Convention
- Pattern: `area-element-purpose`
- Example: `auth-login-submit`

## Do/Do Not
- Do:
  - Use semantic locators first.
  - Add explicit `data-testid` only when needed.
- Do Not:
  - Use nth-child selectors.
  - Depend on styling classes.

## Current State

Path A targets template workflow/system E2E and has no UI surface. This artifact remains out of scope unless Path B is selected later.

## Sign-off
- [ ] Frontend Lead approved
- [ ] QA Lead approved
