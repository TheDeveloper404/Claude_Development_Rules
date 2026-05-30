# Changelog

All notable changes to the AI Engineering Rules System are logged here.

Format: `[ruleset_version] YYYY-MM-DD — Summary`

---

## [1.1] 2026-05-30 — Two New Enforcement Hooks + Document Sync

### Added
- `.claude/hooks/block-push-main.sh` — blocks direct `git push` to `main`/`master`
- `.claude/hooks/scan-secrets.sh` — scans staged files for hardcoded secrets before `git commit`

### Changed
- `.claude/settings.json` — 2 new hooks registered (now 6 total)
- `README.md` — updated hook count and list; removed deleted `agents/` references; fixed Agent Roles to point to `.claude/agents/`; removed non-existent Commands.md link
- `WORKFLOW.md` — updated agent load table to use `.claude/agents/` paths; removed non-existent agent refs
- `MIGRATION.md` — updated hook counts; added 2 new hooks to summary table; fixed agents reference
- `SYSTEM_PROMPT.md` §13 — added 2 new hooks to non-negotiable list

### Why
Push-to-main and secret-in-commit were soft rules in `.md` files — enforced only by trust.
Now they are hard guards. Also synced all docs to reflect the deleted `agents/` directory.

---

## [1.0] 2026-05-25 — Enforcement Layer, Modularization, and New Specs

### Added
- `.claude/settings.json` — verified and documented; 4 hooks wired with correct matchers
- `.claude/commands/handoff-tests.md` — slash command to toggle Claude/human test-running mode
- `.claude/commands/loop-reset.md` — slash command to reset loop-guard counter after audit
- `.claude/commands/classify.md` — slash command to force SMALL/NORMAL/CRITICAL classification
- `.claude/agents/security-engineer.md` — isolated subagent with YAML frontmatter (claude-opus-4-7)
- `.claude/agents/architect.md` — isolated subagent with YAML frontmatter (claude-opus-4-7)
- `.claude/agents/devops-engineer.md` — isolated subagent (claude-sonnet-4-6)
- `.claude/agents/performance-engineer.md` — isolated subagent (claude-sonnet-4-6)
- `.claude/agents/qa-tester.md` — isolated subagent (claude-sonnet-4-6)
- `.claude/agents/code-reviewer.md` — isolated subagent (claude-sonnet-4-6)
- `templates/global-CLAUDE.md` — cross-project identity/classification template for `~/.claude/CLAUDE.md`
- `MIGRATION.md` — setup guide: global memory install, hooks, first-use approval, slash commands
- `FEATURE_SPEC_TEMPLATE.md` — generic fill-in-the-blank spec for non-auth CRUD/feature work
- `CHANGELOG.md` — this file

### Changed
- `.gitignore` — added `.claude/HUMAN_RUNS_TESTS` and `.claude/.loop-state`
- `CLAUDE.md` — added `ruleset_version: 1.0` header; note pointing to global template
- `SYSTEM_PROMPT.md` — removed "read 6 docs every session" ritual; added §13 hook non-bypass rule; updated session opening paragraph
- `FEEDBACK_LOG.md` — slimmed to < 30 lines; removed read-every-session instruction; added /memory pointer; clarified team-shared purpose
- `CICD_FLOW.md` — fixed duplicate §14 (renamed to §15/§16); added §14 AI Session Safety
- `README.md` — indexed all files including FEATURE_SPEC_TEMPLATE.md; added Mechanism Layer section; updated FEEDBACK_LOG description; updated Feature Specifications labels
- `Backend.md` — added YAML frontmatter (path-scoped, labeled "Auth & Account — reusable baseline spec"); added OAuth/social login endpoints; added MFA/TOTP endpoints; added confirm-email-change endpoint; added Configuration Reference table; added Data Model section (sessions + refresh_tokens tables)
- `Frontend.md` — added YAML frontmatter (path-scoped, labeled "Auth & Account — reusable frontend baseline spec")
- `UI_UX_RULES.md` — added YAML frontmatter (path-scoped)

### Why
The system was 100% declarative prose with no runtime enforcement. Rules were dropped after
context compaction, test-fix loops ran uncontrolled, and cross-project rules had to be re-taught
each session. This change adds the mechanism layer: hooks enforce test handoff and loop detection,
subagents isolate heavy role context, slash commands make operational procedures explicit, and
path-scoped frontmatter marks when each spec is relevant.
