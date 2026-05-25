#!/usr/bin/env bash
set -uo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -z "$CMD" ] && exit 0
[ -f "${CLAUDE_PROJECT_DIR:-.}/.claude/HUMAN_RUNS_TESTS" ] || exit 0

TEST_RE='(^|[;&| ])((npm|pnpm|yarn|bun)( run)? test|jest|vitest|playwright test|mocha|pytest|tox|mvn( -[A-Za-z]+)* test|gradle( [A-Za-z]+)* test|go test)\b'
if printf '%s' "$CMD" | grep -qiE "$TEST_RE"; then
  echo "BLOCKED: omul rulează testele în sesiunea asta. NU rula testele — cere-i output-ul. (Toggle: rm .claude/HUMAN_RUNS_TESTS)" >&2
  exit 2
fi
exit 0