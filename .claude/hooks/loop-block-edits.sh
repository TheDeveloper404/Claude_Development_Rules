#!/usr/bin/env bash
set -uo pipefail
cat >/dev/null
THRESHOLD=3
N=$(cat "${CLAUDE_PROJECT_DIR:-.}/.claude/.loop-state" 2>/dev/null || echo 0)
case "$N" in (*[!0-9]*|"") exit 0 ;; esac
if [ "$N" -ge "$THRESHOLD" ]; then
  echo "LOOP GUARD: $N cicluri de teste picate la rând. Editarea e blocată. STOP. Rulează 'git diff' + 'git diff --stat', găsește CAUZA RĂDĂCINĂ pe toate fișierele schimbate în sesiune, explică-i omului. Reset: echo 0 > .claude/.loop-state" >&2
  exit 2
fi
exit 0