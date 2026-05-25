# Engineering Rules — System Index

This directory defines how the AI engineering system thinks, works, and enforces standards.

If you are new, read in this order: `CLAUDE.md` → `WORKFLOW.md` → relevant spec or agent.

---

## How the System Works

The system simulates a software engineering team. Claude acts as the lead engineer and adapts its process based on task complexity (SMALL / NORMAL / CRITICAL). Specialized agent roles are activated only when relevant.

**The key insight:** not every task needs the same level of rigor. `CLAUDE.md` and `WORKFLOW.md` govern this decision.

---

## Documents

### Operating Mode (Start Here)

| File | Purpose |
| --- | --- |
| [SYSTEM_PROMPT.md](SYSTEM_PROMPT.md) | Paste this at the start of any new AI session |
| [CLAUDE.md](CLAUDE.md) | Identity, task classification, non-negotiables |
| [WORKFLOW.md](WORKFLOW.md) | Step-by-step operational guide — what to do and when |
| [EXAMPLES.md](EXAMPLES.md) | Concrete examples of correct and incorrect AI output |
| [FEEDBACK_LOG.md](FEEDBACK_LOG.md) | Shared log of past AI failures and corrections |
| [context/Engineering_Model.md](context/Engineering_Model.md) | Philosophy — why the system is designed this way |
| [Claude Code – Commands/Commands.md](Claude%20Code%20%E2%80%93%20Commands/Commands.md) | Claude Code CLI command reference |
| [CHANGELOG.md](CHANGELOG.md) | Ruleset version history and change log |

---

### Engineering Standards (Always Apply)

| File | Purpose |
| --- | --- |
| [SW_PRINCIPLES.md](SW_PRINCIPLES.md) | SOLID, DRY, KISS, architecture, clean code, testing |
| [Audit_checklist.md](Audit_checklist.md) | Security standard — 13 categories, single source of truth |
| [CICD_FLOW.md](CICD_FLOW.md) | CI/CD pipeline, branching, deployment, rollback, feature flags |
| [UI_UX_RULES.md](UI_UX_RULES.md) | UI/UX quality — visual consistency, component behavior, page patterns, anti-patterns |

---

### Feature Specifications (Load When Relevant)

| File | Purpose |
| --- | --- |
| [Frontend.md](Frontend.md) | Auth & account — reusable UI baseline spec (path-scoped: components/, pages/, *.tsx) |
| [Backend.md](Backend.md) | Auth & account — reusable API baseline spec (path-scoped: auth/, users/, session*) |
| [FEATURE_SPEC_TEMPLATE.md](FEATURE_SPEC_TEMPLATE.md) | Fill-in-the-blank template for non-auth CRUD / feature specs |

---

### Mechanism Layer (Hooks / Subagents / Slash Commands)

| Path | Purpose |
| --- | --- |
| [.claude/settings.json](.claude/settings.json) | Hook wiring — all 4 enforcement hooks registered here |
| `.claude/hooks/` | Shell scripts: `block-tests.sh`, `checkpoint.sh`, `loop-count.sh`, `loop-block-edits.sh` |
| `.claude/agents/` | Isolated subagent definitions (security, devops, performance, qa, reviewer, architect) |
| `.claude/commands/` | Slash commands: `/handoff-tests`, `/loop-reset`, `/classify` |
| [templates/global-CLAUDE.md](templates/global-CLAUDE.md) | Cross-project identity template — install at `~/.claude/CLAUDE.md` |
| [MIGRATION.md](MIGRATION.md) | Setup guide: global memory install, hook enable, first-use approval |

---

### Agent Roles (Load Only When Needed)

| Agent | Role |
| --- | --- |
| [agents/product-owner.md](agents/product-owner.md) | Requirements, acceptance criteria, prioritization |
| [agents/orchestrator.md](agents/orchestrator.md) | Coordinates the team; active for NORMAL/CRITICAL tasks |
| [agents/architect.md](agents/architect.md) | System design, technology selection, ADRs |
| [agents/tech-lead.md](agents/tech-lead.md) | Coding standards, implementation guidance |
| [agents/backend-engineer.md](agents/backend-engineer.md) | APIs, business logic, auth, data validation |
| [agents/frontend-engineer.md](agents/frontend-engineer.md) | UI components, routing, state, API integration |
| [agents/database-engineer.md](agents/database-engineer.md) | Schema design, migrations, query optimization |
| [agents/devops-engineer.md](agents/devops-engineer.md) | Infrastructure, CI/CD, deployment |
| [agents/security-engineer.md](agents/security-engineer.md) | Security audits, threat modeling — veto power |
| [agents/qa-tester.md](agents/qa-tester.md) | Test strategy, unit/integration/security/E2E tests |
| [agents/code-reviewer.md](agents/code-reviewer.md) | Code review — blocking authority before merge |
| [agents/performance-engineer.md](agents/performance-engineer.md) | Performance profiling, optimization |
| [agents/documentation-writer.md](agents/documentation-writer.md) | User-facing and developer documentation |

---

## Document Hierarchy (Conflict Resolution)

If two documents conflict, this order of precedence applies:

1. `Audit_checklist.md` — wins on all security decisions
2. `UI_UX_RULES.md` — wins on all visual/UX decisions
3. `SW_PRINCIPLES.md` — wins on engineering patterns
4. `CLAUDE.md` / `WORKFLOW.md` — wins on process decisions
5. Agent documents — define role-specific behavior within the above constraints

---

## Quick Decision Reference

```
Received a task → Classify it (SMALL / NORMAL / CRITICAL)
                         ↓
    SMALL                NORMAL                CRITICAL
    ─────                ──────                ────────
    Implement directly   Plan → Implement      Full team
    Light security check Relevant agents       All phases
    Light review         Full review           Security audit mandatory
                                               Nothing ships without approval
```
