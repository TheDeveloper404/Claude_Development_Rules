#!/usr/bin/env bash
set -uo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -z "$CMD" ] && exit 0

if printf '%s' "$CMD" | grep -qiE 'git push.*(origin\s+)?(main|master)\b'; then
  echo "BLOCAT: Push direct pe main/master interzis. Creează un branch și deschide un PR." >&2
  exit 2
fi
exit 0
