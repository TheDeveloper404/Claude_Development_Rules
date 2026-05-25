#!/usr/bin/env bash
set -uo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
TEST_RE='(^|[;&| ])((npm|pnpm|yarn|bun)( run)? test|jest|vitest|pytest|mvn( -[A-Za-z]+)* test|gradle( [A-Za-z]+)* test|go test)\b'
printf '%s' "$CMD" | grep -qiE "$TEST_RE" || exit 0
STATE="${CLAUDE_PROJECT_DIR:-.}/.claude/.loop-state"
RESP=$(printf '%s' "$INPUT" | jq -r '.tool_response | tostring' 2>/dev/null) || RESP=""
if printf '%s' "$RESP" | grep -qiE '(FAIL|failing|✕|[1-9][0-9]* failed|BUILD FAILURE|AssertionError)'; then
  echo $(( $(cat "$STATE" 2>/dev/null || echo 0) + 1 )) > "$STATE"
elif printf '%s' "$RESP" | grep -qiE '(all tests passed|[0-9]+ passed,? 0 failed|BUILD SUCCESS|0 failed)'; then
  echo 0 > "$STATE"
fi
exit 0