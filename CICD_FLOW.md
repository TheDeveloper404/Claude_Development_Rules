# CI/CD Workflow — General Engineering Standard

This document defines how code moves from development to production.

It is written as a **general-purpose workflow** that can be applied to any modern web application or service.

---

## 1. What CI/CD Means

Continuous Integration (CI) ensures that every code change is automatically tested and validated.

Continuous Deployment (CD) ensures that validated code is automatically delivered to production.

In practice:

Write code → push → system validates → if valid, it gets deployed

---

## 2. Branching Strategy

A minimal and effective setup uses two main branches:

| Branch | Purpose |
|--------|--------|
| `develop` | Active development |
| `main` | Production-ready code |

### Rules

- Never commit directly to `main`
- All work happens in `develop` or feature branches
- Code reaches `main` only after validation

---

## 3. Development Flow

The daily workflow is simple:

1. Work on `develop` (or a feature branch)
2. Push changes
3. CI runs automatically
4. Fix issues if CI fails
5. Merge into `main` when stable

---

## 4. CI Pipeline (Develop)

Triggered on every push to `develop`.

### Purpose

Validate code quickly without affecting production.

### Typical Steps

- Install dependencies
- Run linting / type checks
- Run unit tests
- Run integration tests (optional)

### Outcome

- Success → continue development
- Failure → fix code before proceeding

No deployment happens at this stage.

---

## 5. CI/CD Pipeline (Main)

Triggered on every push or merge to `main`.

### Purpose

Fully validate and release code to production.

### Typical Steps

1. Run all tests
   - Unit tests
   - Integration tests
   - End-to-end tests (if applicable)

2. Build artifacts
   - Compile / bundle
   - Build containers if used

3. Apply database migrations (if any)

4. Deploy application

---

## 6. Failure Behavior

If any step fails:

- The pipeline stops immediately
- Deployment is blocked
- Errors must be fixed in code

### Key Principle

> CI/CD never “fixes itself”. Code must be corrected.

---

## 7. Testing Strategy in Pipeline

A balanced approach:

- Unit tests → fast, frequent
- Integration tests → moderate coverage
- E2E tests → only for critical flows

Avoid:
- running heavy E2E tests on every small change
- skipping tests for critical paths

---

## 8. Observability

Every pipeline run must be visible and debuggable.

You should be able to:

- see which step failed
- inspect logs
- reproduce the issue locally

---

## 9. Secrets and Configuration

CI/CD pipelines require secure configuration.

### Rules

- No secrets in code
- Use environment variables or secret managers
- Separate secrets per environment (dev, staging, production)
- Restrict access to secrets

---

## 10. Rollback Strategy

Every deployment must be reversible.

Two common approaches:

### Application rollback
- switch to previous version (artifact, container, revision)

### Code rollback
- revert commit and redeploy

### Database consideration
- schema changes must be reversible
- application and database versions must stay compatible

---

## 11. Environments

At minimum:

- Development
- Staging (optional but recommended)
- Production

### Rules

- Environments must be isolated
- Production must be protected
- No manual changes in production outside pipeline

---

## 12. Core Principles

- Always test before deploying
- Never deploy broken code
- Keep pipelines deterministic and repeatable
- Fail fast, fix fast
- Automate everything that is repeatable
- Keep deployments predictable

---

## 13. Feature Flags Strategy

Feature flags allow code to be deployed to production without being released to users. This decouples deployment from release.

### When to use feature flags

- Feature is large and takes multiple deployments to complete
- You want to release gradually (10% → 50% → 100% of users)
- You want the ability to instantly disable a feature without a redeploy
- A/B testing or experiments
- Features that depend on infrastructure not yet ready in production

### When NOT to use feature flags

- Small, safe changes that can go straight to production
- Bug fixes — these should be deployed immediately
- Do not use flags as a permanent solution — they accumulate as technical debt

### Implementation rules

- Flags must be stored in configuration (environment variable or feature flag service) — never hardcoded
- Every flag must have an owner and a planned removal date
- Remove the flag and the old code path once the feature is fully rolled out
- Never leave dead code behind flags indefinitely
- Name flags clearly: `feature_new_checkout_flow`, not `flag_v2`

### Flag types

| Type | Purpose | Example |
|------|---------|---------|
| Release flag | Control rollout to users | New dashboard for 10% of users |
| Ops flag | Emergency kill switch | Disable heavy report endpoint under load |
| Experiment flag | A/B test | Test two versions of signup form |
| Permission flag | Role-based access to feature | Beta features for specific accounts |

### Deployment flow with feature flags

```
1. Implement feature behind flag (flag = OFF by default)
2. Deploy to production — feature is invisible to users
3. Test on production with flag ON internally
4. Roll out gradually: 5% → 25% → 50% → 100%
5. Monitor metrics at each step — rollback = flip flag OFF
6. Once at 100% and stable: remove flag and dead code path
```

---

## 14. Summary

The workflow is intentionally simple:

1. Write code
2. Push to development branch
3. Validate through CI
4. Merge to main
5. Full validation + deploy
6. Monitor and rollback if needed

---

## 14. One Rule

> If the pipeline is red, nothing moves forward.