# Feature Specification Template

<!-- HOW TO USE THIS TEMPLATE
     1. Copy this file and rename it: e.g. SPEC_notifications.md
     2. Fill in every section. Delete hints after filling.
     3. For API-only features: omit the Frontend section.
     4. For stateless CRUD: omit States & Transitions.
     5. This template covers NON-AUTH features. For auth flows, use Backend.md + Frontend.md.
     6. Ref: ruleset_version 1.0 | WORKFLOW.md NORMAL/CRITICAL quality gates apply.
-->

---

# Feature Specification — [FEATURE_NAME]

## Meta

<!-- Hint: fill in before any implementation starts -->

- **Feature:** [short noun-form name, e.g. "Notifications", "Team Invites"]
- **Type:** [CRUD / Integration / Workflow / Real-time]
- **Owner:** [name or team]
- **Status:** [Draft / Review / Approved / In Progress / Done]
- **ruleset_version:** 1.0

---

## Goal & User Story

<!-- Hint: one sentence a non-technical stakeholder can validate -->

As a **[role]**, I want **[action]** so that **[benefit]**.

---

## Acceptance Criteria

<!-- Hint: Given/When/Then. Minimum: 1 happy path + 1 validation + 1 auth + 1 negative case.
     Each AC maps to at least one test in the Test Plan section. -->

- [ ] **AC1 (happy path):** Given [precondition], when [action], then [expected outcome].
- [ ] **AC2 (validation):** Given a valid session, when [invalid input is submitted], then 400 is returned with field-level error details.
- [ ] **AC3 (authorization):** Given an unauthenticated request, when [action], then 401 is returned.
- [ ] **AC4 (negative / edge):** Given [edge condition], when [action], then [expected failure behavior].
- [ ] **AC5 (add more as needed):** ...

---

## Scope

### In Scope
<!-- Hint: list the specific things this spec commits to delivering -->
- [item]
- [item]

### Out of Scope
<!-- Hint: list things explicitly excluded to prevent scope creep -->
- [item] — deferred to [feature name or sprint]
- [item] — not required by this spec

---

## Data Model

<!-- Hint: follow agents/database-engineer.md conventions:
     snake_case tables (plural), snake_case columns (singular),
     standard id / created_at / updated_at on every table,
     explicit ON DELETE behavior on every FK,
     all FK columns indexed,
     all migrations reversible. -->

### Entities

| Table | Column | Type | Constraints | Notes |
|---|---|---|---|---|
| `[table_name]` | `id` | uuid | PK DEFAULT gen_random_uuid() | |
| | `[field_name]` | [type] | NOT NULL / nullable | [note] |
| | `created_at` | timestamptz | NOT NULL DEFAULT now() | |
| | `updated_at` | timestamptz | NOT NULL DEFAULT now() | |

### Indexes

| Table | Index Name | Columns | Type | Reason |
|---|---|---|---|---|
| `[table]` | `idx_[table]_[col]` | `[col]` | btree | [query it supports] |

### ON DELETE Behavior

<!-- Hint: every FK must have an explicit ON DELETE clause with a reason -->

- `[fk_column]` references `[table]` → **CASCADE** / **SET NULL** / **RESTRICT** — [reason]

---

## API Contract

<!-- Hint: one row per endpoint.
     Auth: "Bearer" = authenticated user; "Public" = no auth required.
     Input DTO: list key fields only (full validation is in the Validation section).
     Errors: list non-200 HTTP codes this endpoint can return. -->

| Method | Path | Auth | Input DTO | Output DTO | Errors | Rate Limit |
|---|---|---|---|---|---|---|
| POST | `/api/v1/[resource]` | Bearer | `{ field: type, ... }` | `{ id, ... }` | 400, 409 | 20/min/user |
| GET | `/api/v1/[resource]` | Bearer | — | `{ items: [...], total }` | — | 60/min/user |
| GET | `/api/v1/[resource]/:id` | Bearer | — | `{ id, ... }` | 404 | 60/min/user |
| PATCH | `/api/v1/[resource]/:id` | Bearer | `{ field?: type }` | `{ id, ... }` | 400, 403, 404 | 20/min/user |
| DELETE | `/api/v1/[resource]/:id` | Bearer | — | 204 No body | 403, 404 | 10/min/user |

---

## Authorization Matrix

<!-- Hint: list every role in the system. IDOR = user A cannot access user B's resource.
     Ownership: define which field links the resource to its owner (usually user_id). -->

| Role | Create | Read Own | Read All | Update Own | Update Any | Delete Own | Delete Any |
|---|---|---|---|---|---|---|---|
| `[role]` | Y/N | Y/N | Y/N | Y/N | Y/N | Y/N | Y/N |

**IDOR / Ownership note:** [describe the ownership check — e.g., "user_id column must match the token subject; reject with 403 if not owner"]

---

## Server-Side Validation Rules

<!-- Hint: list every field that is user-supplied or user-influenced.
     All validation is server-side. Client-side validation is UX only. -->

| Field | Rule | Error Code | Error Message |
|---|---|---|---|
| `[field]` | required, [type], [min/max/regex] | `VALIDATION_ERROR` | "[human-readable message]" |
| `[field]` | optional, [type], [constraints] | `VALIDATION_ERROR` | "[message]" |

---

## Pagination / Filtering / Sorting

<!-- Hint: fill in for any LIST endpoint. -->

- **Default page size:** [20] &nbsp;&nbsp; **Max:** [100]
- **Pagination strategy:** [cursor / offset] — [one-sentence reason]
- **Supported filters:** `[field=value]`, `[date_from=ISO8601]`, ...
- **Sort fields:** `created_at asc/desc`, `[other_field]`, ...

---

## States & Transitions *(omit for stateless CRUD)*

<!-- Hint: required for anything with a status field: orders, tasks, requests, approvals.
     List every valid state and every valid transition. Include guard conditions. -->

| From State | Event | To State | Guard / Condition |
|---|---|---|---|
| `[state]` | `[event]` | `[state]` | [who can trigger + condition] |

---

## Edge Cases & Failure Behavior

<!-- Hint: think through what happens when things go wrong -->

- **Concurrent writes:** [how the system handles two users editing the same resource simultaneously]
- **[Resource] already deleted:** [idempotent / 404 / 422 — pick one and state why]
- **Downstream service unavailable:** [fail fast / degrade gracefully / queue — state behavior]
- **[Other edge case]:** [expected behavior]

---

## Observability

### Audit Events

<!-- Hint: one event per significant state change. No PII in log fields. -->

| Event | When Emitted | Log Fields (no PII) |
|---|---|---|
| `[RESOURCE_CREATED]` | After successful POST 201 | `{ resource_id, actor_id, timestamp }` |
| `[RESOURCE_UPDATED]` | After successful PATCH 200 | `{ resource_id, actor_id, changed_fields, timestamp }` |
| `[RESOURCE_DELETED]` | After successful DELETE | `{ resource_id, actor_id, timestamp }` |

### Log Fields (no PII)

`resource_id`, `actor_id`, `action`, `status_code`, `timestamp`, `request_id`

---

## Security

<!-- Hint: list which Audit_checklist.md categories apply and one sentence why.
     Audit_checklist.md is the authoritative source — always verify against all 13 categories. -->

- [ ] **Category 03 — Authorization:** IDOR risk on resource ownership check
- [ ] **Category 04 — Input Validation:** user-supplied content in [field(s)]
- [ ] **Category 07 — Data Protection:** [what sensitive data is involved, if any]
- [ ] **Category 09 — Rate Limiting:** write endpoints need rate limits
- [ ] [add more categories as applicable]

---

## Test Plan

<!-- Hint: map each acceptance criterion (AC) to at least one test. Include the test type. -->

| AC | Test Type | What to Test | File / Suite |
|---|---|---|---|
| AC1 | Integration | Happy path POST → 201; response matches output DTO | `[test file]` |
| AC2 | Unit | Validation service rejects [field] when [invalid condition] | `[test file]` |
| AC3 | Integration | 401 when Authorization header is absent | `[test file]` |
| AC4 | Security | IDOR: user A cannot GET/PATCH/DELETE user B's resource | `[test file]` |
| AC4 | Security | 403 when authenticated user does not own the resource | `[test file]` |
| — | Unit | [Additional business logic edge case] | `[test file]` |

---

## Frontend *(omit for API-only features)*

### Routes

<!-- Hint: list every route this feature adds -->

| Path | Component / Page | Auth Required |
|---|---|---|
| `/[path]` | `[PageName]` | Yes / No |

### States

<!-- Hint: define behavior for all four states on every interactive page -->

- **Loading:** [skeleton / spinner — specify which component]
- **Empty:** [empty state message + CTA if applicable]
- **Error:** [toast notification / inline error — specify placement]
- **Success:** [confirmation message / redirect — specify what]

### Accessibility

→ Follow [UI_UX_RULES.md §8](UI_UX_RULES.md) — non-negotiable minimum.

---

## Rollout

<!-- Hint: complete this section before the PR is merged -->

- **Feature flag:** [yes — `FLAG_[NAME]` / no]
- **Migration steps:**
  1. [Run migration: `npx prisma migrate deploy` or equivalent]
  2. [Deploy application]
  3. [If using flag: enable flag for internal users first]
- **Rollback:**
  - [Flip flag OFF, or: revert migration with `down()`, then redeploy previous version]

---

## Open Questions

<!-- Hint: log unresolved questions here. Assign an owner and a due date. -->

- [ ] [question] — owner: [name], due: [YYYY-MM-DD]
- [ ] [question] — owner: [name], due: [YYYY-MM-DD]
