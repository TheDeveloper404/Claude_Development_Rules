# Frontend Specification — Auth & Account Management (General)

This document defines the expected behavior, UX requirements, and component standards for authentication flows and account management in any SPA-based application.

It is technology-agnostic (React / Vue / similar) and project-agnostic. Apply it to any frontend that has user accounts.

**Dependency:** All visual and UX decisions in this document are subject to `UI_UX_RULES.md`. If a pattern here conflicts with a rule there, `UI_UX_RULES.md` wins.

---

## Core Principles

1. Clean, consistent UI following the project's design tokens and the rules in `UI_UX_RULES.md`
2. Every async operation has three states: **loading**, **success**, **error**
3. No broken flows — every edge case must be handled
4. Client-side validation is for UX only — server is the authority
5. No hardcoded mock data in the UI layer
6. Mobile-first, responsive
7. Accessible (WCAG 2.1 AA minimum)
8. No sensitive data stored client-side (tokens in HttpOnly cookies preferred)

---

## Routing Structure

### Public Routes

* `/login`
* `/signup` (or `/register`)
* `/forgot-password`
* `/reset-password` (reads token from URL query param)
* `/verify-email` (if email verification flow is used)

### Protected Routes

* `/app` (or `/dashboard` — main entry point after login)
* `/settings/profile`
* `/settings/account`
* `/settings/security`

---

## Auth State

### What to store

* `user` object (id, name, email, avatar, roles)
* `isAuthenticated` boolean
* `isLoading` boolean (for initial auth check on app load)

### Behavior

* On app load: verify session / check token validity before rendering protected routes
* On login: save auth state, redirect to `/app`
* On logout: clear all auth state, redirect to `/login`
* On 401 from any API: attempt token refresh → if fails, logout and redirect to `/login`

---

## Auth Flow Pages

---

### 1. Login

**Route:** `/login`

**Fields:**

* Email (type=email, required)
* Password (type=password, required, toggle show/hide)
* "Forgot password?" link
* Submit button
* Link to signup

**Validation:**

* Email: valid format
* Password: required (no complexity check at login — that's signup's job)

**Behavior:**

* Submit on Enter key
* Disable button while request is in flight
* On success: save auth state, redirect to `/app` (or originally intended route)
* On error: show generic message — do NOT indicate whether email or password was wrong ("Invalid credentials")

**States:** idle → loading → success (redirect) / error (inline message)

---

### 2. Sign Up / Register

**Route:** `/signup`

**Fields:**

* Full name (required)
* Email (required)
* Password (required, toggle show/hide)
* Confirm password (required, toggle show/hide)
* Submit button
* Link to login

**Password Rules (show inline, validate in real-time after first blur):**

* Minimum 8 characters
* At least 1 uppercase letter
* At least 1 number
* At least 1 special character (recommended, not always required — configure per project)

**Validation:**

* Name: required, min 2 characters
* Email: valid format
* Password: must meet rules above
* Confirm password: must match password exactly

**Behavior:**

* Show password strength indicator (weak / medium / strong) as user types
* Show each rule as checked/unchecked in real-time
* On success: support flexible behavior per project:
  + Auto-login and redirect to `/app`, OR
  + Redirect to `/login` with success message, OR
  + Show "verify your email" screen before allowing login

---

### 3. Forgot Password

**Route:** `/forgot-password`

**Fields:**

* Email (required)
* Submit button
* Link back to login

**Behavior:**

* Always show the same success message regardless of whether the email exists (prevents account enumeration):
  > "If an account exists with this email, you will receive a reset link shortly."
* Do NOT indicate whether the email was found or not

---

### 4. Reset Password

**Route:** `/reset-password?token=XXX`

**Fields:**

* New password (required, toggle show/hide)
* Confirm new password (required, toggle show/hide)
* Submit button

**Behavior:**

* On load: validate that token query param exists — if missing, show error and link to `/forgot-password`
* Apply same password rules as signup
* On success: show confirmation message, redirect to `/login`
* On expired/invalid token: show clear error ("This reset link has expired or is invalid") with link to request a new one

---

### 5. Email Verification (if applicable)

**Route:** `/verify-email?token=XXX`

**Behavior:**

* On load: attempt to verify token automatically
* On success: show confirmation, redirect or allow login
* On failure: show error with option to resend verification email

---

## Protected Routes — Layout

Every authenticated page must include:

* Navigation (sidebar or topbar)
* User avatar / name visible
* Link to settings
* Logout action (always accessible, no confirmation needed)

**ProtectedRoute component behavior:**

* If not authenticated: redirect to `/login` (preserve intended destination in URL for post-login redirect)
* If authenticated: render children

**Auth Guard (reverse):**

* Authenticated users accessing `/login` or `/signup` → redirect to `/app`

---

## Profile Settings

**Route:** `/settings/profile`

**Fields:**

* Avatar / profile photo (optional: upload, crop, remove)
* Full name (editable)
* Email address (editable, but requires re-verification after change)
* Any other display fields (bio, username, etc. — per project)
* Save button

**Behavior:**

* Load current user data on mount
* Show loading state while fetching
* Inline field validation before submit
* On save success: show success toast/banner ("Profile updated")
* On email change: inform user that a verification email will be sent to the new address before it takes effect
* Avatar upload: validate file type (jpg/png/webp), max size (e.g. 2MB), show preview before saving

---

## Account Settings

**Route:** `/settings/account`

This section contains actions that affect the account itself (not just display info).

### Change Password

**Fields:**

* Current password (required, toggle show/hide)
* New password (required, toggle show/hide, with strength rules)
* Confirm new password (required)
* Submit button

**Behavior:**

* Validate new password meets complexity rules
* New password must differ from current password
* On success: show confirmation; optionally force re-login or refresh session
* On wrong current password: show clear error ("Current password is incorrect")

---

### Active Sessions (optional but recommended)

**Display:**

* List of active sessions (device, browser, location if available, last active)
* Current session highlighted
* "Revoke" button per session
* "Revoke all other sessions" button

**Behavior:**

* Revoking a session logs out that device immediately
* Cannot revoke own current session from this view (only via logout)

---

### Two-Factor Authentication / MFA (if applicable)

**States:**

* Disabled: show setup option
* Enabled: show status + disable option + backup codes option

**Setup flow:**

* Show QR code + manual entry key
* Verify with a code before enabling
* Show backup codes after enabling (one-time display, must be saved by user)

---

### Delete Account

**Placement:** Bottom of account settings, clearly separated, destructive styling (red/danger)

**Flow:**

1. Button: "Delete my account"
2. Confirmation modal with:
   * Clear warning: "This action is permanent and cannot be undone. All your data will be deleted."
   * Require user to type their email address or the word "DELETE" to confirm
   * Final "Delete account" button (destructive style)
   * Cancel button
3. On confirm: call delete endpoint, clear auth state, redirect to `/login` or landing page with a "Account deleted" message
4. Never auto-redirect without giving user time to read the confirmation

**Important:** Do NOT allow deletion to proceed without the typed confirmation step.

---

## Security Settings

**Route:** `/settings/security` (or combine with account)

Can include:

* Change password (see above)
* Active sessions management
* MFA management
* Login activity log (last N logins with IP/device/time)

---

## UX Requirements

> For comprehensive visual/UX rules (spacing, component behavior, empty states, loading patterns, accessibility, anti-patterns) see `UI_UX_RULES.md`. The rules below are specific to auth and account management flows.

### Forms

* Inline, field-level validation (show error on blur, not on every keystroke)
* Clear, specific error messages ("Email format is invalid" not "Invalid input")
* No generic "Something went wrong" unless the server returns an unexpected error
* Submit button disabled while loading
* Prevent double-submit

### Loading States

* Button: show spinner + disable during request
* Page data: show skeleton or spinner while loading initial data
* Avoid full-page loading blockers for partial updates

### Error Handling

* Field errors: displayed below the field, in red
* Global errors (e.g. server error): banner at top of form
* Network errors: "Connection error. Please try again."
* 401 during session: redirect to login (handled globally by API client)

### Success States

* Inline success messages (e.g. "Profile updated successfully")
* Use toast notifications for non-blocking feedback
* Auto-dismiss toasts after 3-5 seconds

---

## Accessibility

* All inputs have visible, associated `<label>` elements
* Error messages linked to inputs via `aria-describedby`
* Focus management: auto-focus first input on page load for auth forms
* Keyboard navigable (Tab order logical, Enter submits forms)
* Modals trap focus (delete confirmation, etc.)
* Visible focus indicators (no `outline: none` without replacement)
* Color is never the only indicator of state (use text + icon + color)

---

## Responsive

* Mobile-first approach
* Auth forms: full-width on mobile, centered max-width container on desktop
* Settings: stacked sections on mobile, sidebar nav + content on desktop
* Touch targets minimum 44x44px

---

## Component Checklist

Every page and form must:

* Render correctly on mobile and desktop
* Handle loading state
* Handle all error states (field, global, network)
* Handle success state
* Be keyboard navigable
* Have no broken flows (missing token, expired link, etc.)
* Integrate with API layer (no hardcoded data)
* Pass accessibility basics (labels, focus, contrast)
* Pass the anti-pattern checklist from `UI_UX_RULES.md` §9
