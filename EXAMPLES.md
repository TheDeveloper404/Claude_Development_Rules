# Examples — Good vs Bad AI Output

This file shows concrete examples of correct and incorrect AI behavior within this engineering system.

Read this to calibrate what "done correctly" looks like in practice.

---

## EXAMPLE 1 — SMALL Task (correct)

**User request:** "The login button shows 'Conectare' instead of 'Login', fix it."

**Correct AI behavior:**

```
Classification: SMALL
— Localized UI text change, zero risk, no architecture impact.

[reads the relevant component file]

Changed "Conectare" → "Login" in src/components/auth/LoginForm.tsx line 47.
```

**Why this is correct:**
- Classified immediately, no overengineering
- No architecture doc, no security audit, no agent activation
- No "I will now proceed to analyze the login component architecture" preamble
- One sentence delivery is enough

---

## EXAMPLE 2 — NORMAL Task (correct)

**User request:** "Add an endpoint to get the list of active sessions for the current user."

**Correct AI behavior:**

```
Classification: NORMAL
— New API endpoint, touches backend + database, moderate complexity, no security-critical logic beyond standard auth.

Documents loaded: Backend.md, agents/backend-engineer.md

Definition of Ready check:
✓ Goal clear: list active sessions for authenticated user
✓ Acceptance criteria: GET /api/v1/users/me/sessions returns session list
✓ Scope: read-only, no session management in this task
✓ Edge cases: user with no sessions returns empty array

Architecture: GET /api/v1/users/me/sessions
- Controller: extract userId from auth token
- Service: query sessions table filtered by userId, exclude expired
- Repository: findActiveSessionsByUserId(userId)
- Response: id, device, lastActive, isCurrent flag

[implements the code]

Security check (targeted):
✓ Endpoint requires valid auth token
✓ Returns only the requesting user's sessions (no IDOR risk)
✓ No sensitive data in response (no tokens, no raw IPs)

DELIVERY
═══════════════════════════════════
Task: GET /api/v1/users/me/sessions
Type: Feature

What changed:
  - src/presentation/controllers/user.controller.ts — added getActiveSessions handler
  - src/application/use-cases/get-active-sessions.ts — new use case
  - src/infrastructure/database/repositories/session.repository.ts — added findActiveByUserId

How to test:
  1. Login to get a valid token
  2. GET /api/v1/users/me/sessions with Authorization header
  Expected: 200 with array of session objects; isCurrent: true on the active one

Security considerations:
  - Auth middleware enforced; users can only see their own sessions
═══════════════════════════════════
```

**Why this is correct:**
- Classified before touching anything
- Definition of Ready checked explicitly
- Architecture thought through before code
- Targeted security check (not full 13-category audit for a read endpoint)
- Delivery format used properly

---

## EXAMPLE 3 — BAD output (fake test results)

**User request:** "Does the password reset flow work correctly?"

**Bad AI response:**
> "Yes, the password reset flow should work correctly. The token is generated, the email is sent, and the reset endpoint validates the token properly. Tests should pass."

**Why this is wrong:**
- "Should work" and "tests should pass" are not test results — they are guesses
- The AI has not run anything
- This gives false confidence

**Correct AI response:**
> "I haven't run the tests. I can review the code and identify potential issues, but I cannot confirm the flow works without real execution. You need to run the test suite and share the output, or I can walk through the code path and flag any issues I see."

---

## EXAMPLE 4 — BAD output (confident estimate with no basis)

**User request:** "How long will it take to implement the full auth system?"

**Bad AI response:**
> "Implementing a full auth system typically takes about 3-5 days for a senior developer."

**Why this is wrong:**
- "Typically" disguises the fact that this is a guess
- No basis: what stack? what features? what does "full" mean? what's the codebase state?
- Gives the user a false anchor for planning

**Correct AI response:**
> "I can't give a reliable estimate without more information: which features are in scope (login, signup, MFA, OAuth?), what stack, and whether the database schema exists. Once those are clear, I can break it into tasks and give a more grounded estimate."

---

## EXAMPLE 5 — BAD output (regression loop)

**Scenario:** AI is asked to fix a failing test. It modifies file A. A new test fails. It modifies file B. The original test fails again.

**Bad AI response:**
> "It seems there's an issue with the validation logic. Let me update the validator..."

**Why this is wrong:**
- The AI is patching symptoms without diagnosing the root cause
- It has already modified file A and file B and is about to make a third change
- It has not acknowledged the loop

**Correct AI response:**
> "I'm going in circles. Let me stop and audit what I've changed before making another fix.
>
> CHANGES MADE THIS SESSION:
> - src/validators/user.validator.ts — changed email regex (to fix test #1)
> - src/services/user.service.ts — changed validation call (to fix test #2)
>
> Root cause: the email regex change in the validator broke the service's expected error format. These two changes are conflicting. The correct fix is [X], which resolves both without introducing the conflict."

---

## EXAMPLE 6 — BAD output (classification skipped)

**User request:** "Add role-based access control to the admin panel."

**Bad AI response:**
> "Sure! I'll start by creating a middleware that checks the user's role..."

**Why this is wrong:**
- RBAC on an admin panel is a CRITICAL feature (auth, permissions, security-sensitive)
- The AI jumped straight to implementation without classifying
- No security audit planned, no architecture thought through

**Correct AI response:**
> "Classification: CRITICAL
> — Role-based access control affects authorization across the entire admin panel. Security audit is mandatory. Full workflow applies.
>
> Before I start: [Definition of Ready check, then architecture, then implementation with security audit]"
