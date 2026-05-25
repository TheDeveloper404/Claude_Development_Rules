---
label: "Auth & Account — reusable backend baseline spec"
paths:
  - "**/auth/**"
  - "**/users/**"
  - "**/session*"
  - "**/*auth*"
note: >
  Path-scoped. @imports load at session start and do NOT save tokens.
  Path scoping is what actually saves context — load this file only when
  working in matched paths (auth/, users/, session*, *auth*).
---

# Backend Specification — Auth & User Management (General)

This document defines the expected API behavior, validation rules, security requirements, and response contracts for authentication and user account management endpoints.

It is framework-agnostic and project-agnostic. Apply it to any backend that handles user accounts.

For architecture, code structure, and engineering patterns, see `agents/backend-engineer.md` and `SW_PRINCIPLES.md`.
For security audit requirements, see `Audit_checklist.md`.

---

## General API Rules

- Base path: `/api/v1/`
- All requests and responses use `application/json`
- All timestamps in ISO 8601 format (`2024-01-15T10:30:00Z`)
- All endpoints return consistent error format (see Error Format section)
- Authentication via HttpOnly cookie (preferred) or Bearer token in Authorization header
- HTTPS required for all endpoints in production
- Rate limiting applied to all auth endpoints (see per-endpoint limits below)

---

## Error Response Format

All errors follow this structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [
      { "field": "email", "message": "Must be a valid email address" }
    ]
  }
}
```

`details` is optional — only present for validation errors with field-specific messages.

### Standard Error Codes

| HTTP | Code | When |
|------|------|------|
| 400 | `VALIDATION_ERROR` | Input fails validation |
| 401 | `UNAUTHORIZED` | Missing or invalid auth |
| 403 | `FORBIDDEN` | Authenticated but not authorized |
| 404 | `NOT_FOUND` | Resource doesn't exist |
| 409 | `CONFLICT` | Duplicate resource (e.g. email already registered) |
| 422 | `UNPROCESSABLE` | Input is valid format but semantically wrong |
| 429 | `RATE_LIMITED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Unexpected server error (generic, no internals exposed) |

---

## Auth Endpoints

---

### POST /api/v1/auth/register

**Purpose:** Create a new user account.

**Rate limit:** 5 requests / IP / 15 minutes

**Request:**
```json
{
  "name": "string (required, 2–100 chars)",
  "email": "string (required, valid email, max 255 chars)",
  "password": "string (required, min 8 chars, at least 1 uppercase + 1 number)"
}
```

**Validation:**
- `name`: required, 2–100 characters, strip leading/trailing whitespace
- `email`: required, valid format, normalize to lowercase, max 255 characters
- `password`: required, min 8 characters, must contain at least 1 uppercase letter and 1 digit
- If email already registered: return `409 CONFLICT` — do NOT reveal that the email exists in the error message (use generic: "Registration failed. Please try again or log in.")
  - Exception: if the project explicitly accepts user enumeration risk, a 409 is acceptable

**On success (201):**
```json
{
  "user": {
    "id": "uuid",
    "name": "string",
    "email": "string",
    "createdAt": "ISO8601"
  }
}
```

**Post-registration behavior (configure per project):**
- Auto-login: set auth cookie/token and return it with the response
- Require email verification: send verification email, return 201 with message instructing user to verify
- Simple registration: return 201, user logs in separately

**Security:**
- Hash password with bcrypt (cost ≥ 12) or argon2 before storing
- Never store or log the raw password
- Never return the password hash in any response

---

### POST /api/v1/auth/login

**Purpose:** Authenticate a user and start a session.

**Rate limit:** 10 requests / IP / 15 minutes; lock account after 10 consecutive failures

**Request:**
```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

**On success (200):**
```json
{
  "user": {
    "id": "uuid",
    "name": "string",
    "email": "string"
  },
  "token": "string (if not using cookies)"
}
```
If using HttpOnly cookies: set `Set-Cookie` header with access token. Do not return token in body.

**On failure (401):**
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid credentials"
  }
}
```

**Security:**
- Same error message for wrong email AND wrong password (no user enumeration)
- Implement account lockout after N failed attempts (unlock after timeout or via email)
- Log failed login attempts (IP, timestamp) for abuse detection — without logging the password
- If using JWT: access token expiry max 15 minutes, refresh token 7–30 days

---

### POST /api/v1/auth/logout

**Purpose:** Invalidate the current session.

**Auth required:** Yes

**Request:** No body required (session identified via cookie or Authorization header)

**On success (204):** No body. Clear auth cookie.

**Security:**
- Invalidate the refresh token server-side (do not rely only on token expiry)
- Clear the HttpOnly cookie on the response

---

### POST /api/v1/auth/refresh

**Purpose:** Exchange a valid refresh token for a new access token.

**Rate limit:** 30 requests / user / hour

**Request:** No body (refresh token read from HttpOnly cookie or request body)

**On success (200):**
```json
{
  "token": "string (new access token — if not using cookies)"
}
```

**Security:**
- Refresh tokens must be single-use (rotate on each use)
- Invalidate old refresh token immediately after issuing new one
- If refresh token is invalid or expired: return 401, clear cookies

---

### POST /api/v1/auth/forgot-password

**Purpose:** Initiate a password reset flow.

**Rate limit:** 3 requests / email / hour

**Request:**
```json
{
  "email": "string (required)"
}
```

**On success (200) — ALWAYS return this, regardless of whether email exists:**
```json
{
  "message": "If an account exists with this email, a reset link has been sent."
}
```

**Security:**
- Never reveal whether the email exists in the system
- Generate a cryptographically random token (min 32 bytes, hex or base64)
- Store hashed token with expiry (15–60 minutes)
- Send email with reset link containing the raw token
- Rate limit per email AND per IP

---

### POST /api/v1/auth/reset-password

**Purpose:** Set a new password using a reset token.

**Rate limit:** 5 requests / token / hour

**Request:**
```json
{
  "token": "string (required)",
  "password": "string (required, same rules as registration)"
}
```

**On success (200):**
```json
{
  "message": "Password has been reset successfully."
}
```

**On failure:**
- Invalid or expired token: `422 UNPROCESSABLE` — "This reset link is invalid or has expired."
- Password validation failure: `400 VALIDATION_ERROR`

**Security:**
- Invalidate the reset token immediately after use (single-use)
- Hash and store the new password
- Optionally: invalidate all existing sessions on password reset
- Never reuse tokens

---

### POST /api/v1/auth/verify-email (if applicable)

**Purpose:** Verify a user's email address using a token from the verification email.

**Request:**
```json
{
  "token": "string (required)"
}
```

**On success (200):**
```json
{
  "message": "Email verified successfully."
}
```

**On failure:** `422` — "This verification link is invalid or has expired."

---

## User / Account Endpoints

---

### GET /api/v1/users/me

**Purpose:** Get the current authenticated user's profile.

**Auth required:** Yes

**On success (200):**
```json
{
  "id": "uuid",
  "name": "string",
  "email": "string",
  "emailVerified": true,
  "avatarUrl": "string | null",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

**Security:**
- Never return: `passwordHash`, internal tokens, or admin flags to regular users
- Field-level access control: only return fields the user is allowed to see

---

### PATCH /api/v1/users/me

**Purpose:** Update the current user's profile (name, avatar, etc.)

**Auth required:** Yes

**Request (partial update — only include fields to change):**
```json
{
  "name": "string (optional, 2–100 chars)",
  "avatarUrl": "string | null (optional)"
}
```

**On success (200):** Return updated user object (same shape as GET /users/me)

**Notes:**
- Email changes are handled via a separate flow (see below) to require re-verification
- If `name` is empty string, reject with 400

---

### POST /api/v1/users/me/change-email

**Purpose:** Initiate an email address change (requires verification of new email).

**Auth required:** Yes

**Rate limit:** 3 requests / user / day

**Request:**
```json
{
  "newEmail": "string (required, valid email)",
  "password": "string (required — re-authentication)"
}
```

**On success (200):**
```json
{
  "message": "A verification link has been sent to the new email address."
}
```

**Security:**
- Require current password confirmation before allowing email change
- Do not change the email until the new address is verified
- New email must not already be in use by another account (handle silently — same generic message)
- Invalidate old email-change tokens when a new request is made

---

### POST /api/v1/users/me/change-password

**Purpose:** Change the current user's password.

**Auth required:** Yes

**Request:**
```json
{
  "currentPassword": "string (required)",
  "newPassword": "string (required, same complexity rules as registration)"
}
```

**On success (200):**
```json
{
  "message": "Password changed successfully."
}
```

**Security:**
- Verify `currentPassword` before applying the change
- New password must differ from current password
- Hash new password before storing
- Optionally: invalidate all other sessions after password change
- On wrong current password: `401` — "Current password is incorrect"

---

### GET /api/v1/users/me/sessions

**Purpose:** List active sessions for the current user.

**Auth required:** Yes

**On success (200):**
```json
{
  "sessions": [
    {
      "id": "uuid",
      "device": "string | null",
      "ipAddress": "string (masked or partial — e.g. 192.168.x.x)",
      "lastActive": "ISO8601",
      "isCurrent": true
    }
  ]
}
```

---

### DELETE /api/v1/users/me/sessions/:sessionId

**Purpose:** Revoke a specific session (log out a device).

**Auth required:** Yes

**On success (204):** No body.

**Behavior:**
- User can revoke any of their own sessions
- Cannot revoke their own current session via this endpoint (use `/auth/logout`)
- Revoking an already-expired session returns 204 (idempotent)

---

### DELETE /api/v1/users/me/sessions

**Purpose:** Revoke all sessions except the current one.

**Auth required:** Yes

**On success (200):**
```json
{
  "revokedCount": 3
}
```

---

### DELETE /api/v1/users/me

**Purpose:** Permanently delete the current user's account and all associated data.

**Auth required:** Yes

**Rate limit:** 1 request / user / day

**Request:**
```json
{
  "password": "string (required — re-authentication)",
  "confirmation": "string (required — must equal the user's email address)"
}
```

**On success (200):**
```json
{
  "message": "Your account has been permanently deleted."
}
```

**Security:**
- Require password re-authentication
- Require typed confirmation (email or "DELETE" — match Frontend spec)
- Invalidate all sessions immediately after deletion
- Deletion must be permanent and irreversible — no soft-delete unless project requires a grace period
- If grace period is used: mark account as pending-deletion, inform user, and process after N days

**Behavior:**
- Delete or anonymize all user data per privacy policy
- Clear auth cookies in the response

---

## Avatar Upload

### POST /api/v1/users/me/avatar

**Purpose:** Upload a profile avatar.

**Auth required:** Yes

**Request:** `multipart/form-data` with field `avatar`

**Validation:**
- Allowed types: `image/jpeg`, `image/png`, `image/webp`
- Max size: 2MB (configure per project)
- Validate actual file content (not just extension or Content-Type header)

**On success (200):**
```json
{
  "avatarUrl": "https://..."
}
```

**Security:**
- Store files outside the public web root, serve via signed URLs or through a controlled route
- Randomize file names (do not use user-provided filenames)
- Scan for malware if handling sensitive environments

### DELETE /api/v1/users/me/avatar

**Purpose:** Remove the current avatar.

**Auth required:** Yes

**On success (204):** No body.

---

## Common Security Requirements (All Endpoints)

- All protected endpoints validate the auth token/cookie before processing
- Authorization failures return `401` (missing auth) or `403` (wrong permissions) — never `404` to hide resource existence
- No stack traces, SQL errors, or file paths in error responses
- Structured logging for all auth events (login, logout, password change, account deletion) — without logging sensitive values
- All endpoints behind HTTPS in production

---

## OAuth / Social Login

### POST /api/v1/auth/oauth/:provider

**Purpose:** Initiate an OAuth authorization flow (redirect to provider).

**Supported providers:** configure per project (e.g. `google`, `github`, `microsoft`).

**Rate limit:** 10 requests / IP / 15 minutes

**Request:** No body. `:provider` is a path parameter.

**On success (302):** Redirect to provider authorization URL with `state` param (CSRF token, signed server-side).

**Security:**
- Generate a cryptographically random `state` param and store it in the session/cookie
- Validate `state` on callback to prevent CSRF
- Use PKCE for public clients

---

### GET /api/v1/auth/oauth/:provider/callback

**Purpose:** Handle OAuth provider callback, exchange code for tokens, issue session.

**Request:** Query params `code` and `state` from the provider.

**On success (200 or redirect):**
```json
{
  "user": { "id": "uuid", "name": "string", "email": "string" },
  "isNewUser": true
}
```
Or redirect to the app with session cookie set.

**Behavior:**
- Validate `state` matches the one stored in the session
- Exchange authorization code for access token (server-to-server — never expose provider token to client)
- Look up user by provider ID (`provider_user_id`) — if found, log in; if not, create account
- If email already exists under a different provider: link accounts only with explicit user confirmation (see link endpoint)
- Issue local session (same as login flow)

**Security:**
- Never return or store the raw OAuth provider access token in the frontend
- Exchange is server-side only

---

### POST /api/v1/users/me/oauth/link

**Purpose:** Link an OAuth provider to an existing authenticated account.

**Auth required:** Yes

**Request:**
```json
{
  "provider": "string (e.g. 'google')",
  "code": "string (authorization code from provider flow)"
}
```

**On success (200):**
```json
{
  "message": "Provider linked successfully.",
  "linkedProviders": ["google", "github"]
}
```

**Security:**
- Prevent linking a provider that is already linked to another account
- Require re-authentication (recent login) before linking

---

### DELETE /api/v1/users/me/oauth/:provider

**Purpose:** Unlink an OAuth provider from the current account.

**Auth required:** Yes

**On success (200):**
```json
{
  "message": "Provider unlinked successfully."
}
```

**Security:**
- Block unlinking if it would leave the account with no login method (no password AND last provider)
- Prompt user to set a password first if they have none

---

## MFA / TOTP

### POST /api/v1/users/me/mfa/enroll

**Purpose:** Begin MFA enrollment — generate a TOTP secret and QR code URI. MFA is NOT yet active after this step.

**Auth required:** Yes

**On success (200):**
```json
{
  "secret": "BASE32_ENCODED_SECRET",
  "qrCodeUri": "otpauth://totp/...",
  "backupCodes": ["xxxxxxxx", "xxxxxxxx", "..."]
}
```

**Notes:**
- `secret` and `qrCodeUri` are shown once — user must save them
- `backupCodes` are 10 single-use codes (store hashed, show raw once)
- MFA is not activated until `/mfa/verify-enroll` succeeds

---

### POST /api/v1/users/me/mfa/verify-enroll

**Purpose:** Confirm MFA enrollment by verifying the first TOTP code. Activates MFA.

**Auth required:** Yes

**Rate limit:** 5 requests / user / 15 minutes

**Request:**
```json
{
  "code": "string (6-digit TOTP code)"
}
```

**On success (200):**
```json
{
  "message": "MFA enabled successfully.",
  "backupCodesRemaining": 10
}
```

**Security:**
- Validate TOTP with ±1 step window (30s tolerance)
- Reject if MFA already active

---

### POST /api/v1/auth/mfa/verify

**Purpose:** Verify TOTP code during login (second factor). Called after successful credential check when the account has MFA enabled.

**Rate limit:** 5 requests / pending-session / 15 minutes

**Request:**
```json
{
  "code": "string (6-digit TOTP or 8-character backup code)"
}
```

**On success (200):** Issue full session (same as login success). Set auth cookies.

**On failure (401):** "Invalid or expired code."

**Security:**
- Pending session (pre-MFA) must expire after 5 minutes if MFA is not completed
- Backup codes are single-use — invalidate immediately after use
- Log MFA failures for abuse detection

---

### POST /api/v1/users/me/mfa/disable

**Purpose:** Disable MFA for the account.

**Auth required:** Yes (full session — not pending)

**Request:**
```json
{
  "code": "string (TOTP code or backup code)",
  "password": "string (current password — re-authentication)"
}
```

**On success (200):**
```json
{
  "message": "MFA has been disabled."
}
```

**Security:**
- Require both current password AND a valid TOTP/backup code
- Invalidate all backup codes on disable

---

### POST /api/v1/users/me/mfa/backup-codes

**Purpose:** Regenerate MFA backup codes (replaces all existing codes).

**Auth required:** Yes

**Request:**
```json
{
  "code": "string (current TOTP code — confirmation)"
}
```

**On success (200):**
```json
{
  "backupCodes": ["xxxxxxxx", "xxxxxxxx", "..."]
}
```

**Security:**
- Show raw codes once — store only hashed values
- Invalidate all previous backup codes immediately

---

## Confirm Email Change

### POST /api/v1/users/me/confirm-email-change

**Purpose:** Apply the email address change after the user clicks the verification link sent to the new email. This completes the flow initiated by `POST /api/v1/users/me/change-email`.

**Auth required:** Yes (or token-based — configurable)

**Rate limit:** 5 requests / token / hour

**Request:**
```json
{
  "token": "string (required — from verification email link)"
}
```

**On success (200):**
```json
{
  "message": "Email address updated successfully.",
  "email": "new@example.com"
}
```

**On failure:**
- Invalid or expired token: `422 UNPROCESSABLE` — "This verification link is invalid or has expired."
- Token already used: `422 UNPROCESSABLE`

**Security:**
- Token must be single-use — invalidate immediately after use
- Token must expire (same TTL as `EMAIL_VERIFY_TTL`)
- Verify the new email is still not taken by another account at time of confirmation
- Update the `email` field only after successful token validation
- Invalidate any other pending email-change tokens for this user

---

## Configuration Reference

All tunable values must be set via environment variables or named constants — never hardcoded.

| Configuration | Env Var | Default | Notes |
|---|---|---|---|
| Access token TTL | `ACCESS_TOKEN_TTL` | `15m` | Keep short |
| Refresh token TTL | `REFRESH_TOKEN_TTL` | `30d` | |
| Password reset token TTL | `RESET_TOKEN_TTL` | `60m` | |
| Email verification TTL | `EMAIL_VERIFY_TTL` | `24h` | Incl. email-change confirm |
| bcrypt cost factor | `BCRYPT_COST` | `12` | Minimum 12 |
| Account lockout threshold | `LOCKOUT_THRESHOLD` | `10` | Consecutive failures |
| Account lockout duration | `LOCKOUT_DURATION` | `30m` | |
| Login rate limit | `RATE_LIMIT_LOGIN` | `10 / 15m / IP` | |
| Register rate limit | `RATE_LIMIT_REGISTER` | `5 / 15m / IP` | |
| MFA backup code count | `MFA_BACKUP_COUNT` | `10` | Single-use each |
| OAuth state TTL | `OAUTH_STATE_TTL` | `10m` | CSRF state expiry |

---

## Data Model — Auth

> Follows `agents/database-engineer.md` naming conventions.
> Tables: snake_case plural. Columns: snake_case singular.
> All FK columns indexed. Standard `id` / `created_at` / `updated_at` columns.
> All migrations must be reversible.

### Table: `sessions`

| Column | Type | Constraints | Notes |
|---|---|---|---|
| id | uuid | PK DEFAULT gen_random_uuid() | |
| user_id | uuid | FK users(id) ON DELETE CASCADE, NOT NULL | Indexed |
| device | varchar(255) | nullable | Device label (e.g. "Chrome / macOS") |
| user_agent | text | nullable | Raw user-agent string |
| ip_address | varchar(64) | nullable | Store masked or hashed — see SECURITY NOTE |
| created_at | timestamptz | NOT NULL DEFAULT now() | |
| last_active_at | timestamptz | NOT NULL | Update on each token refresh |
| expires_at | timestamptz | NOT NULL | |
| revoked_at | timestamptz | nullable | Set when session explicitly revoked |

**Indexes:** `idx_sessions_user_id`, `idx_sessions_expires_at`
**Constraint names:** `fk_sessions_user_id`

### Table: `refresh_tokens`

| Column | Type | Constraints | Notes |
|---|---|---|---|
| id | uuid | PK DEFAULT gen_random_uuid() | |
| user_id | uuid | FK users(id) ON DELETE CASCADE, NOT NULL | Indexed |
| session_id | uuid | FK sessions(id) ON DELETE CASCADE, NOT NULL | Indexed |
| token_hash | varchar(255) | UNIQUE NOT NULL | SHA-256 of raw token — NEVER store raw |
| issued_at | timestamptz | NOT NULL DEFAULT now() | |
| expires_at | timestamptz | NOT NULL | |
| rotated_at | timestamptz | nullable | Set on rotation — single-use enforced |
| replaced_by | uuid | FK refresh_tokens(id) nullable | Rotation chain (self-referential) |
| revoked_at | timestamptz | nullable | Set when explicitly revoked |

**Indexes:** `idx_refresh_tokens_user_id`, `idx_refresh_tokens_session_id`,
`uq_refresh_tokens_token_hash` (covers UNIQUE lookup)
**Constraint names:** `fk_refresh_tokens_user_id`, `fk_refresh_tokens_session_id`,
`fk_refresh_tokens_replaced_by`

> **SECURITY NOTE:** Never store raw refresh tokens — hash them (SHA-256) before inserting.
> Store IP addresses masked or hashed at storage time per privacy policy
> (e.g. mask last two octets as `x`: `192.168.x.x`, or store `HMAC-SHA256(ip, secret)`).
> Single-use token rotation: mark `rotated_at` on the old token before issuing the new one.
