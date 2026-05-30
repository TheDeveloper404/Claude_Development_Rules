#!/usr/bin/env bash
set -uo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -z "$CMD" ] && exit 0

printf '%s' "$CMD" | grep -qiE '(^|[;&| ])git commit\b' || exit 0

STAGED=$(git -C "${CLAUDE_PROJECT_DIR:-.}" diff --cached --unified=0 2>/dev/null) || exit 0
[ -z "$STAGED" ] && exit 0

# Detecteaza asignari de tip: password = "valoare" sau api_key: 'valoare'
SECRETS_RE='(password|passwd|secret|api_key|apikey|api_secret|access_key|private_key|auth_token)[[:space:]]*[=:][[:space:]]*[[:punct:]][^[:space:]]{8,}'

if printf '%s' "$STAGED" | grep -qiE "$SECRETS_RE"; then
  echo "BLOCAT: Posibile secrete hardcodate detectate in fisierele staged. Verifica 'git diff --cached'." >&2
  exit 2
fi
exit 0
