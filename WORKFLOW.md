# AI Agent — Operational Workflow

This document defines exactly how to process any task from start to finish.

It is the operational guide. For identity and philosophy, see `CLAUDE.md`.
For engineering standards, see `SW_PRINCIPLES.md`.
For security rules, see `Audit_checklist.md`.

---

## Pre-Step: Definition of Ready

Before any task enters the workflow, it must pass this check.

**A task is NOT ready to start if any of the following are missing:**

- [ ] The goal is clearly stated — what needs to be built and why
- [ ] Acceptance criteria are defined — how do we know it's done?
- [ ] Scope is bounded — what is explicitly OUT of scope?
- [ ] Dependencies are identified — does this block or require anything else?
- [ ] Edge cases are considered — what happens when things go wrong?
- [ ] For CRITICAL tasks: security requirements are stated upfront

**If a task does not meet Definition of Ready:**
- Do not start implementation
- Ask the specific questions needed to make it ready
- A task that starts unclear will finish wrong

This is not bureaucracy — it is the single most effective way to avoid wasted work.

---

## Step 0: Classify the Task (ALWAYS FIRST)

Before doing anything else, answer these three questions:

1. How complex is this?
2. What is the risk if this goes wrong?
3. How many parts of the system does this touch?

Then assign one classification:

| Classification | Characteristics |
|---|---|
| **SMALL** | Localized, low risk, one area, no security/architecture impact |
| **NORMAL** | Multiple layers, moderate complexity, needs structure |
| **CRITICAL** | Security-sensitive, payments, auth, infra, data at risk |

When in doubt between two levels, go with the higher one.

---

## Step 1: Load the Right Documents

Do NOT load everything. Load only what is relevant.

### Always load
- `CLAUDE.md`
- `SW_PRINCIPLES.md`
- `Audit_checklist.md`

### Load only when relevant

| Situation | Load |
|---|---|
| Frontend work | `Frontend.md`, `agents/frontend-engineer.md` |
| Backend work | `Backend.md`, `agents/backend-engineer.md` |
| Auth / security feature | `agents/security-engineer.md` |
| Database design | `agents/database-engineer.md` |
| Deployment / CI / infra / feature flags | `CICD_FLOW.md`, `agents/devops-engineer.md` |
| Requirements / acceptance criteria | `agents/product-owner.md` |
| Code standards / structure | `agents/tech-lead.md` |
| Architecture decision | `agents/architect.md` |
| Full project coordination | `agents/orchestrator.md` |
| Testing | `agents/qa-tester.md` |
| Review | `agents/code-reviewer.md` |

---

## Step 2: Execute Phases by Classification

### SMALL Task

```
1. Understand the change
2. Implement directly (clean code, no over-engineering)
3. Sanity-check for security issues
4. Light review — is the code correct and clean?
5. Deliver
```

No formal architecture. No full agent team. No documentation unless the change is in a public API or behavior that others depend on.

---

### NORMAL Feature

```
1. UNDERSTAND — clarify requirements, identify affected layers
2. ARCHITECTURE — define structure, layers, data flow (no formal doc needed, but think it through)
3. IMPLEMENTATION — build using clean architecture (Controller → Service → Repository)
4. SECURITY — targeted validation against Audit_checklist.md (relevant sections only)
5. TESTING — unit tests for business logic, integration tests for API endpoints
6. REVIEW — full code review: quality, security, architecture compliance
7. DELIVER — explain usage, document what changed
```

Activate only the agents relevant to the task. Frontend feature → Frontend Engineer. API feature → Backend Engineer. Both → both.

---

### CRITICAL Feature

```
1. UNDERSTAND — full requirements, constraints, edge cases, threat surface
2. ARCHITECTURE — formal design: modules, data flow, security architecture, ADRs
3. IMPLEMENTATION — strict clean architecture, no shortcuts
4. SECURITY AUDIT — full audit against ALL 13 categories in Audit_checklist.md
                    Any CRITICAL or HIGH finding = STOP, fix, re-audit
5. TESTING — unit + integration + security tests (all auth/authz flows covered)
6. CODE REVIEW — strict review, rejection criteria enforced
7. DELIVER — documentation required, deployment steps clear
```

Activate the full agent team. Security Engineer has veto power. Nothing ships without Security + Code Reviewer approval.

---

## Step 3: Quality Gates

Before marking any task as done, check the appropriate gate:

### SMALL — Minimum Gate
- [ ] Code is correct and handles the edge cases
- [ ] No security regression introduced (no hardcoded secrets, no new injection surface)
- [ ] No unnecessary complexity added

### NORMAL — Standard Gate
- [ ] Follows clean architecture (no business logic in controllers)
- [ ] Input validation present (server-side)
- [ ] Error handling complete (no unhandled exceptions, no stack trace leaks)
- [ ] Unit tests for business logic
- [ ] Integration test for at least the happy path
- [ ] No hardcoded secrets or credentials
- [ ] Code reviewed and approved

### CRITICAL — Full Gate
- [ ] All 13 security categories from `Audit_checklist.md` checked
- [ ] No CRITICAL or HIGH security findings open
- [ ] Full test coverage: unit + integration + security tests
- [ ] Auth/authz flows explicitly tested (IDOR, privilege escalation, token handling)
- [ ] Architecture compliance verified
- [ ] Code Reviewer approved
- [ ] Security Engineer approved
- [ ] Documentation updated

---

## Step 4: Delivery

Always include:
- What was built / changed
- How to use it (if not obvious)
- Any configuration required
- Any security notes relevant to the user

Do NOT include:
- Summaries of what files were modified (the diff shows that)
- Lengthy explanations of decisions that are obvious from the code
- Documentation for things that didn't change

### PR / Task Delivery Format

When delivering any NORMAL or CRITICAL task, structure the output as follows:

```
DELIVERY
═══════════════════════════════════
Task: [what was built]
Type: [Feature / Bug fix / Refactor / Security fix]

What changed:
  - [file or component] — [what and why]
  - [file or component] — [what and why]

How to test:
  1. [step]
  2. [step]
  Expected result: [what the user should see]

Security considerations:
  - [any auth, validation, or data handling decisions worth noting]
  - "None" if not applicable

Known limitations / follow-up:
  - [anything intentionally left out of scope]
  - "None" if complete
═══════════════════════════════════
```

For SMALL tasks: a brief 2-3 line summary is sufficient — no need for the full format.

---

## Agent Activation Reference

| Task Type | Agents to Activate |
|---|---|
| Small UI fix | Frontend Engineer (light mode) |
| Small bug fix | Relevant engineer (light mode) |
| New frontend feature | Frontend Engineer, Code Reviewer |
| New backend feature | Backend Engineer, Database Engineer (if DB changes), Code Reviewer |
| Auth / security feature | Architect, Backend Engineer, Security Engineer, QA, Code Reviewer |
| Full-stack feature | Architect, Frontend Engineer, Backend Engineer, Database Engineer, QA, Code Reviewer |
| Infrastructure / deploy | DevOps Engineer, Security Engineer |
| Full project | Orchestrator coordinates all agents |

---

## Failure Handling

### If a security issue is found at any phase
1. **STOP** — do not continue implementation
2. Document the finding (category, severity, location, impact)
3. Produce the fix
4. Re-audit the fix before continuing
5. Only then resume

### If requirements are unclear
- Ask before building — do not assume and build the wrong thing
- Clarify ambiguous scope, edge cases, and security-sensitive behaviors upfront

### If two documents conflict
- `Audit_checklist.md` wins on all security matters
- `SW_PRINCIPLES.md` wins on engineering patterns
- `CLAUDE.md` wins on process and workflow decisions
- If still unclear: surface the conflict and ask

---

## One Rule

> Do what is necessary. No more, no less.
