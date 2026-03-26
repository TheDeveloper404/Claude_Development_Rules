# Web App Security Checklist (Production-Grade SaaS)

## 01 - SECRETS & CONFIG
- No hardcoded secrets, tokens, or API keys in codebase
- Environment variables used for all sensitive configs
- `.env` files never committed to git
- Secrets managed via secure vaults (e.g. cloud secret managers)
- API keys restricted by domain/IP where possible
- No secrets exposed in frontend unless absolutely required
- No secrets leaking via logs, error messages, or API responses
- Debug mode disabled in production
- No default credentials or example configs left in code

---

## 02 - AUTHENTICATION
- Strong password hashing (bcrypt / argon2, never plain or SHA)
- Secure login flow (no sensitive data leaks)
- Account existence not revealed in login/reset flows
- Multi-factor authentication (MFA) for sensitive actions
- Session expiration and refresh logic implemented
- Logout properly invalidates session/token
- Protection against session fixation
- Secure password reset (single-use, time-limited tokens)

---

## 03 - AUTHORIZATION
- Proper access control on all routes (no public-by-default)
- Backend enforces authorization (not frontend-only)
- Role-Based Access Control (RBAC) implemented
- Attribute-Based Access Control (ABAC) where needed
- Users cannot access other users' data (IDOR protection)
- Admin routes properly secured (not just hidden URLs)
- "Deny by default" access strategy

---

## 04 - INPUT VALIDATION & OUTPUT SANITIZATION
- All user input validated server-side
- No unsanitized input reaches database queries (SQL Injection protection)
- Output encoding to prevent XSS
- File uploads validated (type, size, content)
- File upload limits enforced
- No dynamic code execution from user input

---

## 05 - API & ACCESS CONTROL
- All endpoints require proper authentication where needed
- Endpoints return only necessary data (no over-fetching)
- Sensitive actions require confirmation (delete, email change, etc.)
- Error responses do not expose internal implementation details
- API keys not exposed client-side if server-only
- CORS policy restricted (not wildcard `*`)
- Rate limiting applied to critical endpoints

---

## 06 - BUSINESS LOGIC SECURITY
- Cannot manipulate prices or payment data client-side
- Cannot reuse or replay sensitive requests (replay attack protection)
- Cannot skip required steps in flows (e.g. checkout)
- Discounts, credits, or coupons cannot be abused
- State transitions are validated server-side

---

## 07 - DATA PROTECTION & PRIVACY
- Sensitive data encrypted at rest
- HTTPS enforced (TLS everywhere)
- HSTS enabled
- Cookies configured securely:
  - HttpOnly
  - Secure
  - SameSite
- Data minimization (store only necessary data)
- GDPR/privacy compliance where applicable
- Sensitive data masked in logs

---

## 08 - LOGGING & MONITORING
- No sensitive data (passwords, tokens) in logs
- Logs structured and centralized
- Alerts for:
  - brute force attempts
  - suspicious activity
  - rate limit violations
- Audit logs for sensitive actions (admin/user changes)

---

## 09 - ABUSE & RATE LIMITING
- Rate limiting on:
  - login
  - password reset
  - API endpoints
- Protection against:
  - brute force attacks
  - bot abuse
  - scraping
- CAPTCHA for high-risk actions
- IP throttling and blocking strategies

---

## 10 - DEPENDENCIES & SUPPLY CHAIN
- Dependencies regularly updated
- No known vulnerabilities in packages
- Automated dependency scanning enabled
- Lockfiles used (package-lock, pnpm-lock, etc.)

---

## 11 - INFRASTRUCTURE & DEPLOYMENT
- Secure CI/CD pipelines
- Secrets not exposed in build logs
- Production != development environments
- No dev tools or debug endpoints in production
- Containers (if used) hardened and minimal
- Proper firewall and network rules configured

---

## 12 - FILE HANDLING & STORAGE
- Files stored outside public root
- Access via signed URLs when needed
- Filenames randomized (no user-controlled paths)
- File scanning for malware (if applicable)
- Proper access control on file retrieval

---

## 13 - SECURITY TESTING
- Static analysis (SAST)
- Dynamic testing (DAST)
- Manual security review for critical flows
- Periodic penetration testing
- Automated security checks in CI/CD

---

# GOAL
This checklist ensures your application is protected against:
- OWASP Top 10 vulnerabilities
- Common SaaS attack vectors
- Real-world production exploits

Use this as:
- Pre-launch audit
- Ongoing security checklist
- Internal security standard
