# Git Workflow Standards

## Branch Strategy
- **main/master**: Protected. Always deployable. Never commit directly.
- **feature/{name}**: All implementation work. One branch per feature/project.
- **fix/{name}**: Bug fixes branched from main.

## Branch Lifecycle
1. Create branch from main: `git checkout -b feature/{name} main`
2. Implement with micro-commits (see below)
3. Full review approval required before merge
4. Merge to main with: `git merge --no-ff feature/{name}`
5. Delete branch after merge

## Commit Conventions

### Format
```
[T-{task-id}] {imperative verb} {what changed}
```

### Examples
- `[T-3] Add user authentication middleware`
- `[T-3] Fix token refresh logic for expired sessions`
- `[T-5] Create database migration for user roles`
- `[T-5] Address review: add input validation to signup`

### Rules
- Imperative mood ("Add" not "Added" or "Adds")
- First line max 72 characters
- Each commit must leave the project in a buildable state
- One logical change per commit

## Micro-Commits as Checkpoints
Make frequent small commits during implementation:
- After each file is complete and working
- Before starting a risky change
- After passing a test suite
- After addressing reviewer feedback

This creates recovery points. If something breaks, rollback is cheap.

## Secret Prevention
Before EVERY commit, verify:
- No .env files staged
- No credentials, API keys, or tokens in code
- No *.key or *.pem files staged
- No hardcoded passwords or connection strings
- Use environment variables for all secrets

## Merge Process
1. Ensure all tests pass on feature branch
2. Reviewer has given APPROVED status
3. Rebase on latest main if needed: `git rebase main`
4. Merge with no-ff: `git merge --no-ff feature/{name}`
5. Push main and delete feature branch
