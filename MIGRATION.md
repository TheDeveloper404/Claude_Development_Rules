# Migration Guide — Enforcement Layer v1.0

This document explains what changed in this system update and how to set up the new features.

---

## What Changed (ruleset_version 1.0)

### Scope A — Mechanism Layer (hooks + slash commands)
- `.claude/settings.json` — 4 enforcement hooks wired (already existed; documented here)
- `.claude/hooks/` — 4 shell scripts authored separately by the repo owner (DO NOT MODIFY)
- `.claude/commands/` — 3 slash commands added: `/handoff-tests`, `/loop-reset`, `/classify`
- `.gitignore` — runtime state files (`HUMAN_RUNS_TESTS`, `.loop-state`) now gitignored

### Scope B — Memory Hierarchy
- `templates/global-CLAUDE.md` — cross-project identity template (see Install section below)
- `CLAUDE.md` — `ruleset_version: 1.0` header added

### Scope C — Subagents
- `.claude/agents/` — 6 isolated subagents with YAML frontmatter created:
  `security-engineer`, `architect`, `devops-engineer`, `performance-engineer`,
  `qa-tester`, `code-reviewer`
- Original `agents/*.md` files are unchanged and remain authoritative source docs

### Scope D — Path-Scoped Loading
- `Frontend.md` and `UI_UX_RULES.md` — YAML frontmatter added with `paths:` globs for frontend work
- `Backend.md` — YAML frontmatter added with `paths:` globs for auth/user work

### Scope E — Document Fixes
- `SYSTEM_PROMPT.md` — removed "read 6 docs every session" ritual; added hook non-bypass rule (§13)
- `FEEDBACK_LOG.md` — slimmed; removed read-every-session instruction; added /memory pointer
- `CICD_FLOW.md` — fixed duplicate §14; added §14 AI Session Safety; renumbered to §15/§16
- `README.md` — indexed all files; added Mechanism Layer section; added FEATURE_SPEC_TEMPLATE.md
- `CHANGELOG.md` — created with first entry

### Scope F — Auth Spec Reuse
- `Backend.md` — labeled as "Auth & Account — reusable baseline spec"
- `Frontend.md` — labeled as "Auth & Account — reusable frontend baseline spec"

### Scope G — New Deliverables
- `Backend.md` — OAuth/social login, MFA/TOTP, confirm-email-change endpoints, CONFIG table, data model (sessions + refresh_tokens tables)
- `FEATURE_SPEC_TEMPLATE.md` — generic fill-in-the-blank spec for non-auth CRUD features

---

## Install: Global Memory File

The `templates/global-CLAUDE.md` file is the **cross-project identity layer**. When installed at
`~/.claude/CLAUDE.md`, it applies to ALL Claude Code sessions on your machine — so you don't need
to re-establish identity, classification rules, or communication style in every project.

**Install command:**
```bash
cp templates/global-CLAUDE.md ~/.claude/CLAUDE.md
```

**What it contains:**
- Engineer identity (Staff/Principal level Technical Co-Founder)
- SMALL/NORMAL/CRITICAL task classification table
- Non-negotiables (secrets, validation, architecture, data leaks, fake test results)
- Communication style rules (classify first, honesty, ask before assuming, change log, loop detection)
- Engineering principles (SOLID, DRY, KISS, YAGNI, Clean Architecture)

**The project `CLAUDE.md` overrides this file** — project-specific rules take precedence.

> Do NOT write project-specific content into `~/.claude/CLAUDE.md`.

---

## Enable Hooks

The hooks are already in `.claude/hooks/` and wired in `.claude/settings.json`. No additional
setup is required to activate them.

**First-use approval (important):**
Claude Code will show a permission prompt the first time each hook script is executed in this
project. **Approve each hook.** The approval is stored in project settings and will not be asked
again. If you deny a hook, enforcement for that hook will not apply.

Hook summary:

| Hook | Trigger | Effect |
|---|---|---|
| `block-tests.sh` | PreToolUse / Bash | Blocks test commands when `HUMAN_RUNS_TESTS` flag exists |
| `checkpoint.sh` | PreToolUse / Bash | Snapshots working tree before test runs (git stash create) |
| `loop-count.sh` | PostToolUse / Bash | Counts consecutive FAILED test cycles into `.loop-state` |
| `loop-block-edits.sh` | PreToolUse / Edit\|Write\|MultiEdit | Blocks edits when `.loop-state` >= 3 |

**Runtime state files** (gitignored, machine-local):
- `.claude/HUMAN_RUNS_TESTS` — presence flag; create/remove with `/handoff-tests`
- `.claude/.loop-state` — integer counter; reset with `/loop-reset` after audit

**Key behavior notes:**
- Exit 2 = blocks the tool call. Exit 1 = non-blocking (tool still runs).
- Matchers are CASE-SENSITIVE: `Bash`, `Edit|Write|MultiEdit`.
- PostToolUse cannot undo an action that already ran.

---

## Slash Commands

Three slash commands are available in Claude Code:

| Command | Purpose |
|---|---|
| `/handoff-tests` | Toggle `HUMAN_RUNS_TESTS` flag — switch between "Claude runs tests" and "human runs tests" modes |
| `/loop-reset` | Reset `.loop-state` to 0 after completing a root-cause audit |
| `/classify` | Force SMALL/NORMAL/CRITICAL classification per WORKFLOW.md Step 0 |

---

## Path-Scoped Documents

`Backend.md`, `Frontend.md`, and `UI_UX_RULES.md` now include YAML frontmatter with `paths:` globs.

These declare which file patterns the document is relevant to:
- `Backend.md` → `**/auth/**`, `**/users/**`, `**/session*`, `**/*auth*`
- `Frontend.md` + `UI_UX_RULES.md` → `**/components/**`, `**/pages/**`, `**/*.tsx`, `**/*.jsx`, `**/ui/**`

**Important:** `@import` in CLAUDE.md loads documents at session start and does NOT reduce context.
Path scoping is the mechanism that actually saves tokens — load documents manually per `WORKFLOW.md`
Step 1 only when working in the matched paths.

---

## Subagents

Six subagents in `.claude/agents/` run in **isolated context** — they do not inherit your main
session's context window. Invoke them for specialized tasks:

- `security-engineer` — security audits, threat modeling, CRITICAL feature reviews
- `architect` — system design, ADRs, API contracts, technology selection
- `devops-engineer` — CI/CD, Docker, infrastructure, secret management
- `performance-engineer` — profiling, load testing, Web Vitals, N+1 queries
- `qa-tester` — test strategy, test writing, coverage gaps
- `code-reviewer` — pre-merge quality gate, architecture compliance

The original `agents/*.md` files remain unchanged and are the source of truth for role definitions.
