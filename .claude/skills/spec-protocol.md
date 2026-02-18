# Spec-Driven Development Protocol

> This file activates SDD mode when present in `.claude/skills/`. Its existence triggers spec-aware dispatch routing.

## Purpose

This protocol defines how structured specifications are authored, formatted, and consumed by agents in the Claude Code Context Engineering Template. It provides the canonical spec packet format, controlled vocabulary, assertion quality rules, tier definitions, and governance principles that all spec-related artifacts MUST follow.

---

## 1. Spec Packet Format

### YAML Structure

Every spec packet embedded in a TaskList task description MUST use the following exact structure:

```yaml
# --- SPEC ---
version: 1
intent: "[imperative verb] [specific observable outcome]"
assertions:
  - id: A1
    positive: "[subject] [MUST/MUST NOT] [specific observable]"
    negative: "[subject] [MUST NOT/MUST] [opposite observable]"
  - id: A2
    positive: "[subject] [MUST/MUST NOT] [specific observable]"
    negative: "[subject] [MUST NOT/MUST] [opposite observable]"
constraints:
  - "[MUST/MUST NOT] [specific constraint]"
file_scope:
  - path/to/file.ext
# --- END SPEC ---
```

### Field Reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `version` | YES | integer | Schema version. Always `1` for Slice 1. |
| `intent` | YES | string | Starts with imperative verb, names a specific observable outcome. |
| `assertions` | YES | array | 1-7 assertion objects. Each has `id`, `positive`, `negative`. |
| `assertions[].id` | YES | string | Unique within task: A1, A2, A3... up to A7. |
| `assertions[].positive` | YES | string | What MUST be true. Uses controlled vocabulary. Names a specific observable. |
| `assertions[].negative` | YES | string | The opposite — what MUST NOT be true. Validates double-entry. |
| `constraints` | YES | array | Non-negotiable rules the implementer MUST follow. |
| `file_scope` | YES | array | Exhaustive list of files the implementer MAY modify. |

### Delimiters

Spec packets MUST be delimited by these exact markers:

- **Start:** `# --- SPEC ---`
- **End:** `# --- END SPEC ---`

These markers enable the forgiving parser to extract specs even from malformed YAML. If the YAML between markers fails to parse, the system retries once with error feedback, then falls back to the forgiving parser before marking the task BLOCKED.

### Schema Versioning

The `version` field is required from Slice 1. Future slices add fields additively:

- **Slice 1:** `version`, `intent`, `assertions`, `constraints`, `file_scope` (5 fields)
- **Slice 3+:** Adds `freedom`, `assumptions`, `escape_clause`, `checksum`, `parent_feature`, `tier` (11 fields total)

Agents MUST ignore unrecognized fields. Agents MUST NOT require fields not defined for their slice version.

---

## 2. Tier Examples

### TRIVIAL — No Spec (Zero Overhead)

Tasks classified as TRIVIAL receive no spec packet. The dispatch loop routes them directly to the implementer with a standard prompt. Examples: typo fixes, single-line config changes, adding a log statement.

**No YAML is generated. No assertions. No overhead.**

### SIMPLE — Minimal Spec (~60 tokens)

```yaml
# --- SPEC ---
version: 1
intent: "Add .env to .gitignore to prevent secret leaks"
assertions:
  - id: A1
    positive: ".gitignore MUST contain a line matching .env*"
    negative: ".gitignore MUST NOT be missing .env* pattern"
constraints:
  - "MUST NOT remove existing .gitignore entries"
file_scope:
  - .gitignore
# --- END SPEC ---
```

### MODERATE — Full Spec

```yaml
# --- SPEC ---
version: 1
intent: "Create user authentication endpoint that validates credentials and returns a JWT token"
assertions:
  - id: A1
    positive: "POST /api/auth/login MUST return 200 with a valid JWT token when credentials are correct"
    negative: "POST /api/auth/login MUST NOT return 200 when credentials are invalid"
  - id: A2
    positive: "POST /api/auth/login MUST return 401 with error message when credentials are invalid"
    negative: "POST /api/auth/login MUST NOT return 401 when credentials are valid"
  - id: A3
    positive: "JWT token MUST expire after 24 hours"
    negative: "JWT token MUST NOT be valid after 24 hours"
  - id: A4
    positive: "Password MUST be compared using bcrypt with cost factor 12"
    negative: "Password MUST NOT be compared using plain text or weak hashing"
constraints:
  - "MUST use existing auth middleware pattern from src/middleware/auth.ts"
  - "MUST NOT store plain text passwords"
  - "MUST NOT introduce new dependencies without architect approval"
file_scope:
  - src/routes/auth.ts
  - src/services/auth-service.ts
  - src/routes/auth.test.ts
# --- END SPEC ---
```

### COMPLEX — Full Spec + Overview Reference

```yaml
# --- SPEC ---
version: 1
intent: "Implement OAuth2 authorization code flow with PKCE for third-party integrations"
assertions:
  - id: A1
    positive: "Authorization endpoint MUST redirect to provider with code_challenge parameter"
    negative: "Authorization endpoint MUST NOT send code_verifier in the redirect URL"
  - id: A2
    positive: "Token exchange MUST include code_verifier matching the original code_challenge"
    negative: "Token exchange MUST NOT succeed without a valid code_verifier"
  - id: A3
    positive: "Refresh token rotation MUST invalidate the previous refresh token on use"
    negative: "Refresh token MUST NOT remain valid after being exchanged"
  - id: A4
    positive: "All OAuth state parameters MUST be cryptographically random and single-use"
    negative: "OAuth state parameters MUST NOT be predictable or reusable"
  - id: A5
    positive: "Token storage MUST use httpOnly secure cookies, not localStorage"
    negative: "Tokens MUST NOT be stored in localStorage or accessible to JavaScript"
constraints:
  - "MUST follow spec overview: planning-artifacts/spec-F-003-oauth-integration-overview.md"
  - "MUST NOT modify existing session management — OAuth is additive"
  - "MUST use existing HTTP client from src/lib/http.ts"
file_scope:
  - src/auth/oauth-provider.ts
  - src/auth/oauth-callback.ts
  - src/auth/token-manager.ts
  - src/middleware/oauth-guard.ts
  - src/auth/oauth.test.ts
# --- END SPEC ---
```

For COMPLEX tasks, a human-readable spec overview document exists at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md` containing the feature goal, full task list, and acceptance criteria summary.

---

## 3. Controlled Vocabulary

All spec-related text (assertions, constraints, intent) MUST use these keywords with precise semantics derived from RFC 2119.

### Keyword Definitions

| Keyword | Meaning | Usage |
|---------|---------|-------|
| **MUST** | Absolute requirement. Non-negotiable. Failure = task not done. | `"POST /api/users MUST return 201 on successful creation"` |
| **MUST NOT** | Absolute prohibition. Violation = task not done. | `"API MUST NOT expose internal error stack traces to clients"` |
| **SHOULD** | Recommended. May deviate with documented rationale in completion notes. | `"Response SHOULD include pagination metadata for lists > 20 items"` |
| **MAY** | Optional. At implementer's discretion within constraints. | `"Error response MAY include a retry-after header for rate limits"` |

### Usage Rules

- Every `positive` assertion field MUST contain exactly one of: MUST, MUST NOT, SHOULD, MAY.
- Every `negative` assertion field MUST use the opposite keyword (MUST ↔ MUST NOT, SHOULD ↔ SHOULD NOT).
- Constraints MUST use only MUST or MUST NOT — never SHOULD or MAY (constraints are non-negotiable by definition).
- The `intent` field does not use controlled vocabulary — it uses imperative verbs instead.

---

## 4. Assertion Quality Gate

### Core Rule

Every assertion MUST name a **specific observable**: an endpoint, a file, a UI element, a return value, or an error code. Assertions containing "works," "correct," "proper," or "appropriate" without a specific observable are **invalid**.

### Banned Vague Terms

The following terms are INVALID in assertions unless accompanied by a specific observable:

- "works" / "works correctly"
- "correct" / "correctly"
- "proper" / "properly"
- "appropriate" / "appropriately"
- "handles correctly"
- "functions as expected"
- "is valid" (without stating what "valid" means)

### What Qualifies as a Specific Observable

| Observable Type | Example |
|----------------|---------|
| Endpoint + HTTP status | `POST /api/users returns 201` |
| File path + content | `.gitignore contains .env* pattern` |
| Return value / type | `Function returns an array of UserDTO objects` |
| Error code | `Invalid input returns error code E_VALIDATION_001` |
| Database state | `users table contains a row with the provided email` |
| UI element | `Login button is disabled while request is pending` |
| Log output | `Logger emits ERROR level entry with correlation ID` |

### Double-Entry Rule

Each assertion requires both `positive` and `negative` fields. This validates the requirement from both directions:

- `positive`: What MUST be true (the desired state)
- `negative`: What MUST NOT be true (the opposite / failure state)

If you cannot write a meaningful `negative`, the `positive` is likely too vague.

### Valid Assertion Examples

```yaml
# VALID — specific endpoint, specific status, specific condition
- id: A1
  positive: "POST /api/auth/login MUST return 200 with a JWT token when credentials match"
  negative: "POST /api/auth/login MUST NOT return 200 when credentials are invalid"

# VALID — specific file, specific content
- id: A2
  positive: ".claude/skills/spec-protocol.md MUST contain a Controlled Vocabulary section"
  negative: ".claude/skills/spec-protocol.md MUST NOT be missing the Controlled Vocabulary section"

# VALID — specific behavior with measurable threshold
- id: A3
  positive: "Search endpoint MUST return results within 200ms for queries under 100 characters"
  negative: "Search endpoint MUST NOT exceed 200ms response time for queries under 100 characters"
```

### Invalid Assertion Examples

```yaml
# INVALID — "works correctly" with no observable
- id: A1
  positive: "Authentication works correctly"
  negative: "Authentication does not break"
  # FIX: "POST /api/auth/login MUST return 200 with JWT when credentials match"

# INVALID — "properly handles" with no specific outcome
- id: A2
  positive: "System properly handles errors"
  negative: "System does not crash on errors"
  # FIX: "POST /api/users MUST return 400 with field-level error messages for invalid input"

# INVALID — "is valid" without defining validity
- id: A3
  positive: "Output is valid"
  negative: "Output is not invalid"
  # FIX: "Output MUST be valid JSON parseable by JSON.parse() without throwing"

# INVALID — no observable, just vibes
- id: A4
  positive: "User experience is appropriate"
  negative: "User experience is not bad"
  # FIX: "Login form MUST display inline error message below the email field within 100ms of validation failure"
```

---

## 5. Constraints & Governance

### 7x7 Constraint

- A feature MUST NOT contain more than **7 tasks**.
- A task MUST NOT contain more than **7 assertions**.

**Rationale:** Forces decomposition of large features into manageable units. If a feature needs more than 7 tasks, it SHOULD be split into multiple features. If a task needs more than 7 assertions, it SHOULD be decomposed into smaller tasks. This keeps specs focused, prevents scope creep, and ensures each task is completable by a single agent in one session.

### Governance Seed Principles

These foundational principles govern all SDD operations. They derive from the 6 Irreducible Truths of the SDD architecture.

1. **External Done:** Every task MUST have a definition of "done" that exists outside the implementing agent's context. Assertions are that definition.
2. **Unambiguous Specs:** Every spec MUST be precise enough that an agent can determine pass/fail without asking for clarification. If a spec requires clarification, it is not ready.
3. **Positive ROI:** The cost of writing a spec MUST be less than the cost of not writing it. TRIVIAL tasks get no spec. Do not over-specify.
4. **File-First State:** Every decision, spec, and result that matters MUST exist in a file before the context that produced it disappears. Context dies; files survive.
5. **Self-Contained Tasks:** Each task MUST be executable with only its spec packet — agents MUST NOT need to understand the full feature to execute their part.
6. **Queryable State:** The system MUST be able to answer "where are we?" from files alone at any moment. No replaying history, no relying on memory.
7. **Spec Immutability:** Once a spec is in ACTIVE state, it MUST NOT be modified. Changes require a new spec version. In-progress tasks continue against the version they started with.
8. **Ownership Boundaries:** No agent modifies another agent's output files. The planner writes specs, the implementer writes code, the reviewer writes reviews.

### Governance Cascade

When conflicts arise between governance layers, higher-numbered layers lose:

1. **constitution.md** (highest authority — optional, Slice 3)
2. **spec-protocol.md** (this file)
3. **Spec templates** (`.claude/spec-templates/` — optional, Slice 4)
4. **Skills** (coding-standards.md, testing-strategy.md, etc.)
5. **Agent freedom** (lowest — anything not constrained above)

Constitution.md and spec templates are optional. SDD functions fully without them. When present, higher layers override lower layers.

---

## 6. Tier Definitions

The dispatch loop classifies each task into a spec tier before routing. Classification determines what spec artifacts are produced and how much overhead is invested.

### Classification Decision Table

| Signal | TRIVIAL | SIMPLE | MODERATE | COMPLEX |
|--------|---------|--------|----------|---------|
| Files touched | 1 | 1-2 | 2-5 | 5+ or cross-boundary |
| Risk of drift | None | Low | Medium | High |
| Novelty | Zero (known pattern) | Low | Medium | High (new pattern) |
| Coupling | Isolated | Minimal | Some cross-file | Multi-component |
| Token budget | 500 | 2,000 | 8,000 | 25,000 |

**Rule:** When signals conflict, classify UP (e.g., 1 file but high novelty → MODERATE, not SIMPLE).

### TRIVIAL

- **Spec:** None. Zero overhead.
- **Dispatch:** Direct to implementer with standard prompt.
- **Examples:** Typo fixes, single-line config changes, log statement additions, comment updates.
- **Criteria:** Single file, zero risk of drift, known pattern, no cross-file impact.

### SIMPLE

- **Spec:** Minimal YAML packet (~60 tokens). Required fields: `version`, `intent`, `assertions`, `constraints`, `file_scope`.
- **Dispatch:** Planner writes spec inline in task description → implementer executes.
- **Examples:** Adding a .gitignore entry, creating a simple config file, adding a straightforward function with clear input/output.
- **Criteria:** 1-2 files, low risk, low novelty, minimal coupling.

### MODERATE

- **Spec:** Full YAML packet + spec overview document at `planning-artifacts/spec-F-{NNN}-{name}-overview.md`.
- **Dispatch:** Planner writes full spec + overview → implementer executes → reviewer validates.
- **Examples:** New API endpoint, database migration with schema changes, multi-file feature implementation.
- **Criteria:** 2-5 files, medium risk or novelty, some cross-file dependencies.

### COMPLEX

- **Spec:** Architect pre-check before planner writes spec suite (multiple task specs + overview).
- **Dispatch:** Architect validates approach → planner writes spec suite + overview → implementer executes → reviewer validates.
- **Examples:** New authentication system, major architectural refactor, cross-boundary integration, security-critical features.
- **Criteria:** 5+ files, high risk or novelty, multi-component coupling, or security-critical path.

---

## 7. SDD Dispatch Routing

When SDD mode is active (this file exists), the dispatch loop classifies each task's spec_tier using Section 6, then routes using the behavior below. Spec_tier classification extends (does not replace) the existing model selection — Step 4 produces two outputs: **model** (haiku/sonnet/opus) AND **spec_tier** (TRIVIAL/SIMPLE/MODERATE/COMPLEX).

### Routing Decision Tree

```
Step 4 classifies spec_tier (Section 6 decision table)
  │
  ├─ TRIVIAL
  │    └─ Direct dispatch to implementer (no planner, no spec, zero overhead)
  │
  ├─ SIMPLE
  │    └─ Dispatch planner → writes minimal spec packet in task description
  │         └─ Dispatch implementer (reads spec via TaskGet)
  │
  ├─ MODERATE
  │    └─ Dispatch planner → writes full spec packet in task description
  │         │                + creates spec overview at planning-artifacts/spec-F-{NNN}-{name}-overview.md
  │         └─ Dispatch implementer → Dispatch reviewer
  │
  └─ COMPLEX
       └─ Dispatch architect → pre-check validates approach
            └─ Dispatch planner → writes spec suite (multiple task specs + overview)
                 └─ Dispatch implementer → Dispatch reviewer
```

### TRIVIAL Routing

1. Skip planner entirely — zero spec overhead.
2. Dispatch implementer with standard prompt.
3. No assertion reporting required.

### SIMPLE Routing

1. Dispatch planner with task context + spec-protocol.md skill reference.
2. Planner creates task via TaskCreate with minimal spec packet (~60 tokens) in description.
3. Dispatch implementer — reads spec via TaskGet.
4. Implementer reports assertion evidence per Section 4 rules.

### MODERATE Routing

1. Dispatch planner with task context + spec-protocol.md skill reference.
2. Planner creates:
   - Task(s) via TaskCreate with full spec packets in descriptions.
   - Spec overview at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`.
3. Dispatch implementer — reads spec via TaskGet.
4. Implementer reports assertion evidence per Section 4 rules.
5. Dispatch reviewer — validates evidence against code.

### COMPLEX Routing

1. Dispatch architect with task context for pre-check (validates approach, identifies risks).
2. If architect approves: dispatch planner with architect feedback + spec-protocol.md skill reference.
3. Planner creates:
   - Multiple tasks via TaskCreate, each with full spec packets in descriptions.
   - Spec overview at `planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md`.
4. Dispatch implementer per task — reads spec via TaskGet.
5. Implementer reports assertion evidence per Section 4 rules.
6. Dispatch reviewer per task — validates evidence against code.

### Dispatch Prompt Templates

**TRIVIAL — No Spec:**
```
Implement task: {task subject}

No spec packet — this is a trivial task. Implement directly.
```

**SIMPLE/MODERATE/COMPLEX — With Spec:**
```
Implement task T-{id}: {task subject}

Spec packet is embedded in the task description. Read it via TaskGet.
Follow all assertions. Report evidence per assertion ID.
Constraints in the spec are non-negotiable.
Freedom not listed in constraints is yours to decide.
```

**COMPLEX — Architect Pre-Check:**
```
Pre-check task: {task subject}

Review the proposed approach for this COMPLEX task.
Validate: architectural fit, risk assessment, decomposition strategy.
If approved, provide guidance for the planner to spec the task suite.
If concerns: flag specific issues and recommend adjustments.
```

**Rules:**
- MUST reference "spec packet in task description" — MUST NOT paste spec into dispatch prompt.
- MUST remind implementer to report per assertion ID (SIMPLE+ tiers only).
- MUST NOT add instructions that contradict the spec's constraints.

---

## 8. Inline Spec Delivery Protocol

Spec packets are delivered to implementers via TaskList — embedded directly in the task description. This eliminates extra file reads and ensures the spec travels with the task.

### Planner Embedding Workflow

When the dispatch loop routes a SIMPLE+ task to the planner (per Section 7):

1. Planner reads spec-protocol.md (this file) as a skill reference.
2. Planner classifies the task and authors a spec packet following Section 1 format.
3. Planner calls TaskCreate with the spec packet embedded in the `description` field.
4. The description field contains both a plain-text task summary AND the delimited spec packet.

### TaskCreate Description Template

```
[Plain-text task summary — 1-3 sentences describing the goal and context]

# --- SPEC ---
version: 1
intent: "[imperative verb] [specific observable outcome]"
assertions:
  - id: A1
    positive: "[subject] [MUST/MUST NOT] [specific observable]"
    negative: "[subject] [MUST NOT/MUST] [opposite observable]"
constraints:
  - "[MUST/MUST NOT] [specific constraint]"
file_scope:
  - path/to/file.ext
# --- END SPEC ---
```

The plain-text summary provides human-readable context. The spec packet between delimiters is the machine-consumable contract.

### Implementer Consumption Workflow

When an implementer is dispatched for a SIMPLE+ task:

1. Implementer calls TaskGet to read the task description.
2. Implementer locates the spec packet between `# --- SPEC ---` and `# --- END SPEC ---` markers.
3. Implementer parses the YAML spec: extracts intent, assertions, constraints, file_scope.
4. Implementer executes against each assertion.
5. Implementer reports evidence per assertion ID (see Section 4 for quality rules):
   ```
   ## Assertion Results
   - A1: PASS — src/file.ts:42 (specific evidence)
   - A2: PASS — src/file.ts:58 (specific evidence)
   ```
6. Missing assertion results = task is NOT DONE.

### Forgiving Parser Fallback

If the spec YAML between delimiters is malformed:

1. **Lint retry:** System detects parse failure, feeds error back to planner, planner gets one retry to fix the YAML.
2. **Forgiving parser:** If retry also fails, the forgiving parser extracts raw content between `# --- SPEC ---` and `# --- END SPEC ---` markers and attempts best-effort parsing.
3. **BLOCKED:** If both lint retry and forgiving parser fail, the task is marked BLOCKED with a specific error describing the parse failure.

The delimiters from Section 1 are what make forgiving parsing possible — even if YAML structure is broken, the content boundaries are unambiguous.

### Anti-Pattern: Spec Duplication

The dispatch loop MUST NOT paste spec content into the dispatch prompt. The spec lives in the task description (via TaskCreate). The dispatch prompt references it:

```
# CORRECT — reference only
"Spec packet is embedded in the task description. Read it via TaskGet."

# WRONG — duplicates spec, wastes tokens, risks version drift
"Here is your spec: version: 1, intent: ..."
```

**Why this matters:** If the spec is pasted into both the task description AND the dispatch prompt, any update to the spec creates two copies that can drift. The task description is the single source of truth.

---

## 9. Spec Overview Documents

Spec overviews are human-readable, feature-level documents that provide project leads and architects a way to review scope and acceptance criteria without parsing YAML spec packets. They are created for MODERATE and COMPLEX tiers only (per Section 7 routing).

### Naming Convention

```
planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md
```

**Examples:**
- `planning-artifacts/spec-F-001-user-authentication-overview.md`
- `planning-artifacts/spec-F-002-api-rate-limiting-overview.md`
- `planning-artifacts/spec-F-015-oauth-integration-overview.md`

### ID Schemes

| ID Type | Format | Scope | Example |
|---------|--------|-------|---------|
| Feature ID | `F-{NNN}` (zero-padded 3 digits) | Global — monotonically increasing | F-001, F-002, F-015 |
| Task ID | `T-{NNN}` (zero-padded 3 digits) | Global — unique across ALL features, never reset | T-001, T-002, T-047 |
| Assertion ID | `A{N}` (1-7) | Per-task only — resets per task (Section 1) | A1, A2, A7 |

Feature and Task IDs are globally unique. Assertion IDs are scoped to their containing task.

### Overview Document Template

```markdown
# Feature F-{NNN}: {Feature Title}

## Goal
{1-3 sentence summary of the feature's purpose and business value}

## Task List
| Task ID | Subject | Spec Tier | Assertions |
|---------|---------|-----------|------------|
| T-{NNN} | {task subject} | SIMPLE/MODERATE/COMPLEX | A1-A{N} |
| T-{NNN} | {task subject} | SIMPLE/MODERATE/COMPLEX | A1-A{N} |

## Acceptance Criteria Summary
1. {High-level criterion derived from task assertions}
2. {High-level criterion derived from task assertions}

## Notes
- {Any architectural constraints, dependencies, or risks}
- {Cross-feature dependencies if applicable}
```

### Filled Example

```markdown
# Feature F-001: User Authentication

## Goal
Implement credential-based authentication with JWT tokens so that API endpoints
can verify user identity and enforce access control.

## Task List
| Task ID | Subject | Spec Tier | Assertions |
|---------|---------|-----------|------------|
| T-001 | Create login endpoint | MODERATE | A1-A4 |
| T-002 | Add JWT token validation middleware | SIMPLE | A1-A2 |
| T-003 | Implement token refresh flow | MODERATE | A1-A3 |

## Acceptance Criteria Summary
1. POST /api/auth/login returns JWT token for valid credentials, 401 for invalid
2. All protected endpoints reject requests without valid JWT
3. Refresh tokens rotate on use and expire after 7 days

## Notes
- MUST use existing auth middleware pattern from src/middleware/
- Password comparison via bcrypt with cost factor 12
```

### When Overviews Are Created

- **TRIVIAL / SIMPLE:** No overview — zero overhead.
- **MODERATE:** Planner creates overview alongside task spec packets.
- **COMPLEX:** Planner creates overview as part of the spec suite (after architect pre-check).

### Relationship to Other Artifacts

| Artifact | Format | Audience | Created By |
|----------|--------|----------|------------|
| Spec overview | Markdown | Humans, architects, reviewers | Planner only |
| Spec packets (task descriptions) | YAML | Implementers, automated tools | Planner only |
| Feature tracker (Slice 2) | JSON | Dispatch loop, all agents | Planner creates; dispatch loop updates |

The overview's task IDs correspond to TaskList tasks that carry embedded spec packets (Section 8). The feature tracker (Epic 3) references the overview path in its `spec_overview` field.

### Ownership

Only the **planner** creates and updates spec overview documents. No other agent MAY modify them. This follows the ownership boundaries in Section 5 (Governance Principle 8).

---

## 10. Spec Lifecycle States

Every spec progresses through lifecycle states that track its journey from authoring to completion. Slice 1 uses a minimal 3-state model.

### Slice 1 States

```
DRAFT ──→ ACTIVE ──→ DONE
```

| State | Meaning | Entered When | Exited When |
|-------|---------|--------------|-------------|
| **DRAFT** | Planner is authoring the spec | Planner creates task via TaskCreate with spec packet | Dispatch loop accepts and dispatches to implementer |
| **ACTIVE** | Implementer is executing against the spec | Dispatch loop sends task to implementer | All assertions report PASS |
| **DONE** | All assertions verified, task complete | Every assertion ID has a PASS result | — (terminal state) |

### Transition Rules

1. **DRAFT → ACTIVE:** The dispatch loop classifies the task (Section 6), routes per tier (Section 7), and dispatches to the implementer. The spec becomes ACTIVE at dispatch time.
2. **ACTIVE → DONE:** The implementer reports evidence for every assertion (Section 11). When ALL assertion IDs have PASS results, the dispatch loop transitions the spec to DONE.
3. **ACTIVE → ACTIVE (retry):** If any assertion reports FAIL, the task remains ACTIVE. The implementer fixes the issue and re-reports. The existing circuit breaker (max 3 cycles) applies.
4. **ACTIVE → BLOCKED:** If the circuit breaker triggers (3 consecutive failures) or the implementer cannot complete, the task is marked BLOCKED and escalated to the user.

### Immutability Rule

Once a spec is in ACTIVE state, it MUST NOT be modified (Governance Principle 7, Section 5). If requirements change while a task is ACTIVE:

- The current task continues against the original spec version.
- A new spec is authored as a separate task with updated assertions.
- The NEEDS_RESPEC flag (CLAUDE.md Step 6) triggers the planner to re-spec the affected subtree.

### Future: Slice 3 Expanded Lifecycle

Slice 3 expands to 6 states with formal quality gates:

```
DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED
```

This is not implemented in Slice 1. The 3-state model is sufficient until governance (Slice 3) demands formal checkpoints.

---

## 11. Evidence Reporting Protocol

When an implementer completes a task with a spec packet, they MUST report evidence for every assertion. This is the mechanism that proves assertion compliance and enables the ACTIVE → DONE transition.

### Evidence Format

```
## Assertion Results
- {id}: PASS|FAIL — {file}:{line} ({brief evidence})
```

Every line follows the exact pattern:

| Component | Required | Description |
|-----------|----------|-------------|
| `{id}` | YES | Assertion ID from the spec packet (A1, A2, etc.) |
| `PASS\|FAIL` | YES | Whether the assertion is satisfied |
| `{file}:{line}` | YES | File path and line number where evidence exists |
| `({brief evidence})` | YES | Short description of what was verified or what failed |

### PASS Evidence

```
## Assertion Results
- A1: PASS — src/auth/login.ts:42 (POST handler returns 200 with JWT)
- A2: PASS — src/auth/login.ts:58 (returns 401 for invalid credentials)
- A3: PASS — src/auth/login.test.ts:15-28 (test covers both valid and invalid cases)
```

Each PASS line names the file and line where the implementation satisfies the assertion.

### FAIL Evidence

```
## Assertion Results
- A1: PASS — src/auth/login.ts:42 (POST handler returns 200 with JWT)
- A2: FAIL — src/auth/login.ts:58 (expected: return 401 for invalid credentials; actual: returns 500 with stack trace)
```

FAIL results MUST include:
- **Expected:** What the assertion required (from the `positive` field).
- **Actual:** What the implementation does instead.

### NOT DONE Rule

A task is **NOT DONE** unless ALL of these conditions are met:

1. **Every assertion ID** from the spec packet appears in the results. Missing assertion = NOT DONE.
2. **Every result is PASS.** Any FAIL result = NOT DONE.
3. **Evidence is specific.** Results without file:line references are invalid.

If an implementer reports partial results (e.g., A1 and A2 but not A3), the task remains ACTIVE regardless of whether A1 and A2 are PASS.

### Completion Flow

1. Implementer finishes work and writes evidence in the assertion results format above.
2. Dispatch loop checks: does every assertion ID from the spec have a PASS result?
3. If YES → spec transitions to DONE (Section 10).
4. If NO → task remains ACTIVE, implementer gets feedback to fix FAIL items or add missing results.
5. Circuit breaker: after 3 retry cycles, task is marked BLOCKED.

### Tier Applicability

- **TRIVIAL:** No evidence reporting — no spec, no assertions.
- **SIMPLE / MODERATE / COMPLEX:** Full evidence reporting required for every assertion.

---

## 12. Feature Tracker Protocol

The feature tracker is a JSON index file that provides feature-level project state visible from files alone. It implements Truth 6: "The system must be able to answer 'where are we?' at any moment from files alone." The tracker survives context resets and enables zero-handoff session continuity.

### File Location

```
planning-artifacts/feature-tracker.json
```

This file is created at runtime by the planner when the first MODERATE+ feature is specced. It does not exist until then.

### JSON Schema

Each entry MUST contain these fields in this exact order:

```json
{
  "id": "F-{NNN}",
  "title": "{feature title}",
  "phase": "DRAFT|ACTIVE|DONE",
  "spec_overview": "planning-artifacts/spec-F-{NNN}-{kebab-name}-overview.md",
  "tasks": ["T-{NNN}", "T-{NNN}"],
  "verified": false
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Feature ID using F-{NNN} format (Section 9) |
| `title` | string | Human-readable feature title |
| `phase` | string | Current lifecycle phase: DRAFT, ACTIVE, or DONE |
| `spec_overview` | string | Path to the spec overview document (Section 9) |
| `tasks` | array of strings | TaskList task IDs in T-{NNN} format (Section 9) |
| `verified` | boolean | True only when ALL task assertions pass |

> **Slice applicability:** Slice 1 implementations MUST use only DRAFT | ACTIVE | DONE for the `phase` field. Extended states (LINT_PASS, RATIFIED, EXECUTING, VERIFIED, GRADUATED) are available only when Slice 3 governance is active. Agents MUST NOT use Slice 3 phase values unless `constitution.md` exists in `planning-artifacts/`.

### Complete File Example

```json
[
  {
    "id": "F-001",
    "title": "User Authentication",
    "phase": "DONE",
    "spec_overview": "planning-artifacts/spec-F-001-user-authentication-overview.md",
    "tasks": ["T-001", "T-002", "T-003"],
    "verified": true
  },
  {
    "id": "F-002",
    "title": "API Rate Limiting",
    "phase": "ACTIVE",
    "spec_overview": "planning-artifacts/spec-F-002-api-rate-limiting-overview.md",
    "tasks": ["T-004", "T-005"],
    "verified": false
  },
  {
    "id": "F-003",
    "title": "OAuth Integration",
    "phase": "DRAFT",
    "spec_overview": "planning-artifacts/spec-F-003-oauth-integration-overview.md",
    "tasks": [],
    "verified": false
  }
]
```

The file MUST be valid JSON parseable by any standard JSON parser.

### Ownership Rules

| Action | Responsible Agent |
|--------|------------------|
| Create new entry | Planner only (when speccing a MODERATE+ feature) |
| Update `phase` | Dispatch loop only |
| Update `verified` | Dispatch loop only |
| Add task IDs to `tasks` | Planner only (when creating tasks via TaskCreate) |
| Read tracker | Any agent, dispatch loop |

No agent other than those listed MAY modify the feature tracker. This follows Governance Principle 8 (Section 5).

### Phase Transitions

Phase values align with Section 10 lifecycle states:

```
DRAFT ──→ ACTIVE ──→ DONE
```

| Transition | Trigger |
|-----------|---------|
| DRAFT → ACTIVE | Dispatch loop dispatches the first task for this feature |
| ACTIVE → DONE | Dispatch loop confirms ALL tasks have all assertions PASS AND sets `verified` to true |

The dispatch loop checks: for each task ID in `tasks`, does the evidence report show all assertions PASS? If yes for every task → phase becomes DONE and verified becomes true.

### Integration with Dispatch Loop

CLAUDE.md Step 2 references the feature tracker:

> "If no tasks AND `.claude/skills/spec-protocol.md` exists AND `planning-artifacts/feature-tracker.json` has unverified features → dispatch planner to spec next feature"

This means the dispatch loop reads the tracker to find features where `verified` is false, then dispatches the planner to continue speccing tasks for that feature.

### Recovery

If `feature-tracker.json` fails to parse (corrupted JSON):

1. **Graceful degradation:** The system falls back to non-SDD mode. Tasks continue via TaskList without feature-level tracking.
2. **Git recovery:** The tracker is recoverable via `git checkout planning-artifacts/feature-tracker.json` since all changes are committed.
3. **Rebuild:** The tracker can be reconstructed from spec overview documents + TaskList state if needed.

---

## 13. Tracker State Machine & Recovery

This section defines the automated logic the dispatch loop executes to keep the feature tracker accurate, detect stalled features, and recover from failures. It builds on the schema and ownership rules in Section 12.

### Post-Task Completion Checklist

After every task completion (implementer reports evidence), the dispatch loop MUST execute this checklist:

1. **Read evidence:** Check the implementer's assertion results for the completed task.
2. **Update task status:** If all assertions PASS → mark task DONE. If any FAIL → task remains ACTIVE (retry cycle).
3. **Check feature progress:** Load `feature-tracker.json`, find the feature containing this task ID.
4. **Check all tasks:** For each task ID in the feature's `tasks` array, check if ALL assertion IDs have PASS evidence.
5. **Transition if complete:** If every task has all assertions PASS → set `verified` to true and `phase` to DONE.
6. **Check stall threshold:** Count BLOCKED tasks in this feature. If 3+ are BLOCKED → trigger re-spec (see below).

### Automated DONE Transition

The dispatch loop transitions a feature to DONE when:

```
FOR each task_id IN feature.tasks:
  IF task has no evidence report → feature is NOT DONE
  IF any assertion in task reports FAIL → feature is NOT DONE
  IF any assertion ID is missing from results → feature is NOT DONE

IF all tasks have all assertions PASS:
  SET feature.verified = true
  SET feature.phase = "DONE"
```

This check runs after every task completion — not on a schedule. The transition is immediate once the final task in a feature reports all PASS.

### Feature Stall Detection

A feature is **stalled** when 3 or more tasks reach BLOCKED status. This indicates a systemic problem with the feature decomposition or spec quality.

**Detection:** After any task is marked BLOCKED, the dispatch loop counts BLOCKED tasks for that feature.

**Response:**
1. Flag the feature for re-spec by setting NEEDS_RESPEC in the task result.
2. CLAUDE.md Step 6 handles the flag: dispatch planner to re-spec affected subtree.
3. The planner re-examines the feature: may restructure tasks, simplify scope, update the spec overview, or split the feature.
4. New tasks replace BLOCKED tasks — the feature remains ACTIVE with updated `tasks` array.

**Threshold rationale:** 3 BLOCKED tasks (out of max 7 per the 7x7 rule) means nearly half the feature is stuck. Earlier intervention (1-2 BLOCKED) would be premature; later (4+) wastes effort.

### Graceful Degradation

If `feature-tracker.json` fails to parse or is missing:

| Capability | SDD Mode (tracker healthy) | Degraded Mode (tracker unavailable) |
|-----------|---------------------------|--------------------------------------|
| Task dispatch | Spec-tier routing active | Spec-tier routing active |
| Per-task assertions | Enforced via spec packets | Enforced via spec packets |
| Evidence reporting | Required per Section 11 | Required per Section 11 |
| Feature-level tracking | Active (phase, verified) | **Paused** — no feature-level view |
| CLAUDE.md Step 2 auto-spec | Checks unverified features | **Skipped** — falls back to "ask user" |
| Stall detection | Active (3+ BLOCKED check) | **Disabled** — no feature-level count |

**Key point:** Degradation only affects feature-level tracking. Per-task SDD behavior (spec packets, assertions, evidence) continues unaffected. No tasks are lost.

### Recovery Procedures

**1. Git Recovery (fastest):**
```
git checkout planning-artifacts/feature-tracker.json
```
Restores the last committed version. Any uncommitted tracker updates are lost but can be re-derived from task results.

**2. Manual Rebuild:**
If git history is also corrupted, the tracker can be reconstructed:
1. List all spec overview files in `planning-artifacts/spec-F-*-overview.md`.
2. For each overview, extract feature ID, title, and task list.
3. For each task, check TaskList for completion status and assertion results.
4. Write reconstructed entries to `feature-tracker.json`.

**3. Fresh Start:**
Delete the corrupted file and let the planner recreate entries as new features are specced. Existing features lose tracking history but tasks continue via TaskList.

---

## 14. Two-Layer Verification Pipeline

Automated verification gates run before dispatching a reviewer, catching 80% of spec violations at 5% of the cost of agent review. This is Slice 3 governance — it layers on top of the Slice 1 evidence reporting (Section 11).

### Architecture

```
Implementer completes task
  │
  ├─→ Layer 1: Automated Gates (cheap, fast)
  │     ├─ Gate 1: Spec Lint
  │     ├─ Gate 2: Assertion Audit
  │     └─ Gate 3: File Scope Audit
  │           │
  │     ALL PASS? ──No──→ Feedback to implementer → 1 retry → BLOCKED
  │           │
  │          Yes
  │           │
  └─→ Layer 2: Agent Review (expensive, thorough)
        └─ Reviewer validates evidence against code
```

Layer 1 gates execute in order. If any gate fails, subsequent gates are skipped and the implementer receives specific feedback.

### Gate 1: Spec Lint

Validates the spec packet structure in the task description. Checks reference Sections 1, 3, 4, and 5.

| Check | Validates | Fail Message |
|-------|-----------|-------------|
| Delimiter presence | `# --- SPEC ---` and `# --- END SPEC ---` markers exist | "Spec packet missing delimiters" |
| YAML parse | Content between delimiters is valid YAML | "Spec YAML is malformed: {parse error}" |
| Required fields | version, intent, assertions, constraints, file_scope all present | "Missing required field: {field}" |
| Assertion structure | Each assertion has id, positive, negative | "Assertion {id} missing field: {field}" |
| Controlled vocabulary | positive/negative fields use MUST/MUST NOT/SHOULD/MAY | "Assertion {id} missing controlled vocabulary keyword" |
| Quality gate | No banned vague terms without specific observables (Section 4) | "Assertion {id} uses vague term '{term}' without observable" |
| 7x7 constraint | Max 7 assertions per task (Section 5) | "Task exceeds 7 assertions ({count} found)" |

### Gate 2: Assertion Audit

Validates the implementer's evidence report against the spec packet. Checks reference Section 11.

| Check | Validates | Fail Message |
|-------|-----------|-------------|
| Completeness | Every assertion ID from spec has a result | "Missing evidence for assertion: {id}" |
| Status present | Each result has PASS or FAIL | "Assertion {id} result missing PASS/FAIL status" |
| Evidence format | Each result includes file:line reference | "Assertion {id} missing file:line evidence" |
| FAIL detail | FAIL results include expected vs actual | "Assertion {id} FAIL missing expected/actual" |

### Gate 3: File Scope Audit

Validates that the implementer respected the `file_scope` constraint from the spec packet.

| Check | Validates | Fail Message |
|-------|-----------|-------------|
| No out-of-scope modifications | Every modified file appears in file_scope | "File modified outside scope: {file}" |
| Completeness warning | Every file in file_scope was touched | "Warning: file in scope not modified: {file}" (warning, not blocking) |

Out-of-scope file modifications are **blocking violations**. Untouched scope files are **warnings** — the implementer may have legitimately determined a file didn't need changes.

### Failure Handling

When any gate fails:

1. **Specific feedback:** The implementer receives the exact gate, check, and fail message.
2. **One retry:** The implementer gets one cycle to fix the violation and re-submit.
3. **Re-run gates:** After the retry, all 3 gates run again from the beginning.
4. **BLOCKED:** If the retry also fails, the task is marked BLOCKED and escalated to the user.

```
Gate fails → Feedback (gate + check + message)
  → Implementer fixes → Re-run all gates
    → PASS → Proceed to Layer 2 (reviewer)
    → FAIL → Task BLOCKED, escalate to user
```

The retry cycle is separate from the existing worker-reviewer circuit breaker (max 3 cycles). Gate failures consume 1 retry before entering the reviewer cycle.

### Tier Applicability

| Tier | Layer 1 (Gates) | Layer 2 (Reviewer) |
|------|----------------|-------------------|
| TRIVIAL | Skipped — no spec | Skipped — no spec |
| SIMPLE | All 3 gates run | Optional — per dispatch routing (Section 7) |
| MODERATE | All 3 gates run | Required — per dispatch routing (Section 7) |
| COMPLEX | All 3 gates run | Required — per dispatch routing (Section 7) |

---

## 15. Expanded Lifecycle States & Graduated Escalation

Slice 3 replaces the 3-state lifecycle (Section 10) with a 6-state model that maps quality gates to formal state transitions, adds graduated escalation for failures, and introduces a spec-level circuit breaker.

### Expanded 6-State Lifecycle

```
DRAFT ──→ LINT_PASS ──→ RATIFIED ──→ EXECUTING ──→ VERIFIED ──→ GRADUATED
```

| State | Meaning | Gate to Enter | Gate Owner |
|-------|---------|---------------|------------|
| **DRAFT** | Planner is authoring the spec | — (initial state) | Planner |
| **LINT_PASS** | Spec packet passes automated validation | Section 14 Gate 1 (Spec Lint) — all 7 checks pass | Dispatch loop |
| **RATIFIED** | Reviewer approves spec quality before execution | Reviewer STATUS: APPROVED on spec review | Reviewer |
| **EXECUTING** | Implementer is working against the spec | Dispatch loop assigns task to implementer | Dispatch loop |
| **VERIFIED** | All assertions pass post-task verification | Section 14 Gates 1-3 pass + all assertions PASS (Section 11) | Dispatch loop |
| **GRADUATED** | Feature-level completion — all tasks verified | All tasks in feature have VERIFIED specs → feature tracker `verified` = true (Section 12) | Dispatch loop |

### Transition Rules

1. **DRAFT → LINT_PASS:** Planner creates task via TaskCreate. Dispatch loop runs Section 14 Gate 1 (Spec Lint) on the embedded spec packet. All 7 lint checks must pass. On failure → planner gets 1 retry to fix the spec.
2. **LINT_PASS → RATIFIED:** Reviewer validates spec quality — assertions are unambiguous, file_scope is reasonable, constraints are achievable. Reviewer returns STATUS: APPROVED. On NEEDS_CHANGES → planner revises, re-lints.
3. **RATIFIED → EXECUTING:** Dispatch loop dispatches to implementer. The spec is now immutable (Section 10 immutability rule applies from RATIFIED onward).
4. **EXECUTING → VERIFIED:** Implementer reports evidence. Section 14 Gates 1-3 validate evidence. All assertions report PASS. On failure → graduated escalation (see below).
5. **VERIFIED → GRADUATED:** Feature-level check. When ALL tasks in the feature reach VERIFIED → dispatch loop sets `verified` = true, `phase` = DONE in feature tracker (Section 13 automated DONE transition).

GRADUATED is a **feature-level** terminal state, not a task-level state. Individual tasks reach VERIFIED; the feature reaches GRADUATED.

### Backward Compatibility

Section 10's 3-state model remains valid for Slice 1/2 projects. The mapping:

| Slice 1 State | Slice 3 Equivalent |
|--------------|-------------------|
| DRAFT | DRAFT |
| ACTIVE | LINT_PASS, RATIFIED, or EXECUTING |
| DONE | VERIFIED or GRADUATED |

Projects without Slice 3 governance continue using 3 states. The expanded lifecycle activates when Section 14 (Two-Layer Verification) is in effect.

> **Activation requirement:** The 6-state lifecycle (DRAFT → LINT_PASS → RATIFIED → EXECUTING → VERIFIED → GRADUATED) activates ONLY when `planning-artifacts/constitution.md` exists. Without it, use Slice 1 states: DRAFT → ACTIVE → DONE.

### Graduated Escalation Protocol

Failures are classified into 4 severity levels that determine the response. Escalation is progressive — unresolved lower-level issues escalate upward.

| Level | Trigger | Response | Example |
|-------|---------|----------|---------|
| **Green** | All gates pass, all assertions PASS | Proceed normally | Clean implementation |
| **Yellow** | Warnings only (Gate 3 completeness, SHOULD violations) | Proceed with logged warning; warnings tracked per feature | Unused file_scope entry |
| **Orange** | MUST violations, FAIL assertions, gate failures after retry | Escalate to reviewer with specific findings | Assertion A3 FAIL — expected 200, got 404 |
| **Red** | 3 consecutive failures OR unresolvable blocker | Task BLOCKED, escalate to user | Circuit breaker triggered |

**Escalation rules:**
- **Yellow → Orange:** If the same warning recurs across 2+ tasks in a feature, it escalates to Orange. Recurring warnings indicate a systemic issue.
- **Orange → Red:** If Orange-level issues persist after the Section 14 retry cycle AND 3 worker-reviewer cycles (CLAUDE.md circuit breaker), the task reaches Red.
- **Red is terminal per task.** The task is marked BLOCKED and escalated to the user. No further automated resolution is attempted.

### Escalation Cascade: Task → Spec → Feature

Three circuit breaker layers protect against cascading failures:

```
Layer 1: Task Circuit Breaker
  Trigger: 3 worker-reviewer cycles with NEEDS_CHANGES (CLAUDE.md)
  Response: Task marked BLOCKED (Red)
  Scope: Single task

Layer 2: Spec-Level Circuit Breaker
  Trigger: 3 tasks in a feature reach BLOCKED
  Response: Feature halted, NEEDS_RESPEC dispatched
  Scope: All remaining tasks in the feature

Layer 3: Feature Stall (Section 13)
  Trigger: Same as Layer 2 — 3+ BLOCKED tasks
  Response: Planner re-specs affected subtree
  Scope: Feature decomposition re-evaluated
```

**Layer 2 and Layer 3 share the same trigger** (3+ BLOCKED tasks) but represent different responses: Layer 2 halts dispatch of remaining tasks; Layer 3 initiates re-spec. They fire together — halt first, then re-spec.

### Spec-Level Circuit Breaker Detail

When 3 tasks in a single feature reach BLOCKED:

1. **Halt:** Dispatch loop stops dispatching remaining tasks for this feature.
2. **Flag:** Set NEEDS_RESPEC in the feature context.
3. **Re-spec:** CLAUDE.md Step 6 dispatches planner to re-evaluate (Section 13 stall response).
4. **Resume:** After re-spec, new/revised tasks replace BLOCKED ones. Feature remains ACTIVE with updated `tasks` array.

The spec-level circuit breaker prevents wasting tokens on a feature whose decomposition is fundamentally flawed. Three BLOCKED tasks (out of max 7 per 7x7 rule) signals a systemic issue — not isolated implementation difficulty.

### Tier Applicability

| Tier | Expanded Lifecycle | Graduated Escalation |
|------|-------------------|---------------------|
| TRIVIAL | N/A — no spec | N/A — no spec |
| SIMPLE | DRAFT → LINT_PASS → EXECUTING → VERIFIED | Green/Yellow/Orange/Red apply |
| MODERATE | Full 6-state lifecycle | Green/Yellow/Orange/Red apply |
| COMPLEX | Full 6-state lifecycle | Green/Yellow/Orange/Red apply |

SIMPLE tier skips RATIFIED (no reviewer pre-check on spec) and GRADUATED (no feature-level tracking for simple tasks). MODERATE and COMPLEX use the full pipeline.

---

## 16. Constitution & Failure Pattern Library

Slice 3 introduces two optional governance mechanisms: a formal constitution with immutable principles and Phase -1 gates, and a failure pattern library that captures lessons learned. Both are optional — SDD functions fully without them.

### Constitution Protocol

**File:** `planning-artifacts/constitution.md`

**Purpose:** Immutable project principles that override all other governance layers. The constitution defines the WHY; spec-protocol.md defines the HOW. Constitution articles are non-negotiable constraints that every spec must satisfy.

**Optionality:** When constitution.md is absent, the governance cascade (Section 5) starts at spec-protocol.md. No behavior changes; no degradation. The seed principles in Section 5 provide lightweight governance until a project is mature enough to warrant a formal constitution.

### Article Format

Each constitution article follows this structure:

```markdown
### Article {N}: {Title}

**Principle:** {One-sentence immutable rule}
**Rationale:** {Why this principle exists — the problem it prevents}
**Enforcement:** {How compliance is checked — which gate, which agent}
**Violation response:** {What happens when violated — block, warn, escalate}
```

**Example:**
```markdown
### Article 1: No Untyped External Inputs

**Principle:** Every external input MUST be validated with explicit type checks before processing.
**Rationale:** Untyped inputs caused 3 production incidents in Q1; runtime type errors are the #1 failure category.
**Enforcement:** Reviewer checks during spec review (LINT_PASS → RATIFIED gate).
**Violation response:** Block — spec cannot advance to RATIFIED until input validation assertions are present.
```

### Phase -1 Gates

Constitution compliance checks run **before** the spec lifecycle begins — before DRAFT → LINT_PASS (Section 15). This is Phase -1: the spec must satisfy constitutional constraints before it even enters the verification pipeline.

```
Phase -1: Constitution Check
  │
  ├─ constitution.md exists? ──No──→ Skip (proceed to DRAFT → LINT_PASS)
  │
  Yes
  │
  ├─ For each article with enforcement at spec-creation time:
  │   └─ Check spec packet against article's principle
  │
  ├─ ALL PASS? → Proceed to DRAFT → LINT_PASS (Section 15)
  └─ FAIL? → Planner receives violation details → revise spec → re-check
```

Phase -1 checks are performed by the dispatch loop when evaluating a new spec from the planner. Only articles with enforcement at "spec-creation time" are checked at Phase -1; articles enforced at review time are checked at LINT_PASS → RATIFIED.

### Governance Cascade Enforcement

The cascade defined in Section 5 is enforced as follows in Slice 3:

| Layer | Authority | Checked At | By |
|-------|-----------|------------|-----|
| constitution.md | Highest | Phase -1 (pre-lifecycle) | Dispatch loop |
| spec-protocol.md | High | DRAFT → LINT_PASS (Section 14 gates) | Dispatch loop |
| Spec templates | Medium-High | During spec authoring (Slice 4, Section 17) | Planner |
| Skills | Medium | During execution (agent reads skill) | Agent |
| Agent freedom | Lowest | Not checked — default for unconstrained decisions | Agent |

When a conflict exists between layers, the higher layer wins. A constitution article overrides a spec-protocol rule; a spec-protocol rule overrides a skill guideline.

### Ownership & Amendment Protocol

**Creation:** Only humans or the architect (with human approval) create constitution.md.

**Amendments:** Only humans can amend the constitution. No agent may modify constitution.md.

**Amendment workflow:**

1. **Propose:** Human identifies a principle that needs to change or a new principle to add.
2. **Rationale:** Human documents why the existing article is insufficient or why a new one is needed.
3. **Write:** Human edits `planning-artifacts/constitution.md` directly.
4. **Effective:** Amendment takes effect immediately for new specs. In-progress tasks continue against the previous version (Section 10 immutability rule extends to constitution).

### Failure Pattern Library

**File:** `planning-artifacts/knowledge-base/failure-patterns.md`

**Purpose:** Categorized record of failure patterns encountered during SDD execution. Captures root cause and resolution so past mistakes inform future specs and reviews.

### Entry Format

Each failure pattern entry follows this structure:

```markdown
### FP-{NNN}: {Pattern Name}

**Category:** {one of: spec-quality | assertion-gaps | scope-violations | decomposition-failures | governance-gaps}
**Detected:** {date}
**Status:** {active | mitigated | resolved}
**Root cause:** {What went wrong and why}
**Detection:** {How the failure was caught — which gate, escalation level, or manual discovery}
**Resolution:** {How this specific instance was fixed}
**Prevention:** {What to check in future specs to avoid this pattern}
```

### Categories

| Category | Description | Example |
|----------|-------------|---------|
| **spec-quality** | Spec was ambiguous, incomplete, or untestable | Vague assertion passed lint but reviewer couldn't verify |
| **assertion-gaps** | Assertions didn't cover a critical behavior | Feature passed all assertions but had a regression |
| **scope-violations** | Implementer modified files outside file_scope | Untracked dependency required cross-file changes |
| **decomposition-failures** | Feature was decomposed incorrectly | 5 of 7 tasks blocked due to circular dependencies |
| **governance-gaps** | Governance rules were insufficient | No constitution article covered a recurring violation |

### Library Population

The failure pattern library is populated when:

1. **Red escalation (Section 15):** Any task reaching Red (BLOCKED) triggers the dispatch loop to record the failure pattern.
2. **Feature stall (Section 13):** When NEEDS_RESPEC fires (3+ BLOCKED tasks), the dispatch loop records a decomposition-failures entry.
3. **Reviewer finding:** If a reviewer identifies a systemic issue (not a one-off bug), it is recorded as a pattern.

The dispatch loop is responsible for writing entries. The entry captures the specific context — which feature, which task, which gate or assertion failed.

### Library Consumption

| Consumer | When | Purpose |
|----------|------|---------|
| Planner | Before speccing a new feature | Check if the feature's domain has known failure patterns; adjust assertions accordingly |
| Reviewer | During spec review (LINT_PASS → RATIFIED) | Verify the spec addresses known failure patterns for its category |
| Dispatch loop | After Red escalation | Record the new pattern |

### Library Rules

- **Append-only:** Entries are never deleted. When a pattern is resolved (e.g., a constitution article now prevents it), update status to `resolved` with annotation.
- **Status transitions:** `active` → `mitigated` (partial fix in place) → `resolved` (fully prevented by governance or automation).
- **IDs are sequential:** FP-001, FP-002, etc. Never reuse IDs.

### Tier Applicability

| Tier | Constitution (Phase -1) | Failure Patterns |
|------|------------------------|-----------------|
| TRIVIAL | Skipped — no spec | N/A — no spec to fail |
| SIMPLE | Checked if constitution exists | Recorded on Red escalation |
| MODERATE | Checked if constitution exists | Recorded on Red escalation or feature stall |
| COMPLEX | Checked if constitution exists | Recorded on Red escalation or feature stall |

---

## 17. Spec Templates Protocol

Reusable spec templates accelerate authoring for common feature patterns. Templates are optional (Slice 4) — SDD functions fully without them. Their absence changes nothing in the spec authoring workflow.

### Directory & Naming

**Location:** `.claude/spec-templates/`
**Naming:** `{pattern-name}.yaml` (e.g., `rest-crud-endpoint.yaml`, `auth-flow.yaml`, `data-pipeline.yaml`)

Templates are git-tracked and versioned alongside the project. They are created by humans or architects — never by agents during execution.

### Template Structure

Each template is a YAML file with pre-filled spec fields and placeholders:

```yaml
pattern_name: "REST CRUD Endpoint"
description: "Standard create/read/update/delete operations for a resource"
typical_tier: MODERATE
intent_template: "Implement CRUD operations for {entity} resource"
assertions:
  - id: A1
    positive: "{entity} endpoint MUST return 201 on successful creation"
    negative: "{entity} endpoint MUST NOT accept creation without required fields"
  - id: A2
    positive: "GET {endpoint} MUST return 200 with {entity} data"
    negative: "GET {endpoint} MUST NOT return data for non-existent {entity}"
  - id: A3
    positive: "PUT {endpoint}/{id} MUST return 200 on successful update"
    negative: "PUT {endpoint}/{id} MUST NOT update with invalid data"
  - id: A4
    positive: "DELETE {endpoint}/{id} MUST return 204 on successful deletion"
    negative: "DELETE {endpoint}/{id} MUST NOT delete non-existent {entity}"
constraints:
  - "MUST implement all 4 CRUD operations"
  - "MUST validate input before processing"
file_scope_patterns:
  - "src/{entity}/*.ts"
  - "src/{entity}/*.test.ts"
```

### Placeholder Conventions

| Placeholder | Meaning | Example |
|-------------|---------|---------|
| `{entity}` | The domain object name | `user`, `product`, `order` |
| `{endpoint}` | The API endpoint path | `/api/users`, `/api/products` |
| `{file}` | A specific file path | `src/auth/login.ts` |
| `{id}` | A resource identifier | `userId`, `productId` |

Placeholders are filled by the planner when adapting the template. All placeholders MUST be resolved before the spec packet is embedded in a task.

### Planner Consumption Workflow

When speccing a MODERATE+ feature (integrates with planner.md SDD Spec Authoring step 3):

1. **Check templates:** Read `.claude/spec-templates/` for a matching pattern
2. **Match found:** Load template as starting point
3. **Adapt:** Fill all placeholders, add/remove assertions for the specific feature, adjust file_scope to actual project paths
4. **No match:** Author spec from scratch (standard workflow)

**Anti-blind-copy rule:** The planner MUST NOT copy templates without adaptation. Every assertion must be relevant to the specific feature. Remove assertions that don't apply; add assertions for behaviors unique to this feature. Templates are starting points, not final specs.

### Template Lifecycle

- **Creation:** Humans or architects create templates based on recurring patterns
- **Evolution:** Failure patterns (Section 16) inform template updates — if a pattern recurs, create or update a template to prevent it
- **Governance:** Templates sit below spec-protocol.md in the cascade: constitution > spec-protocol > **templates** > skills > agent freedom
- **Versioning:** Templates evolve with the project; additive changes preferred

### Template Sketches

These illustrate the concept — actual templates would be project-specific:

| Template | Typical Tier | Pre-filled Assertions | Key Constraints |
|----------|-------------|----------------------|-----------------|
| `rest-crud-endpoint.yaml` | MODERATE | 4 (create/read/update/delete) | All 4 operations, input validation |
| `auth-flow.yaml` | COMPLEX | 5 (login/logout/token/refresh/unauthorized) | Token expiry, secure storage |
| `data-pipeline.yaml` | MODERATE | 3 (ingest/transform/output) | Idempotency, error handling |

### Tier Applicability

| Tier | Template Usage |
|------|---------------|
| TRIVIAL | N/A — no spec authored |
| SIMPLE | Rarely — simple specs don't benefit from templates |
| MODERATE | Primary use case — templates accelerate standard feature specs |
| COMPLEX | Templates provide starting point; architect pre-check may add additional assertions |
