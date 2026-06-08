#!/usr/bin/env bash
# AI Session Safety (CICD_FLOW.md §14): snapshot the working tree before a Bash
# action so a bad AI session can be recovered with:
#   git stash apply $(git rev-parse refs/cc-checkpoints/last)
# Never blocks — always exits 0.
set -uo pipefail
INPUT=$(cat)
DIR="${CLAUDE_PROJECT_DIR:-.}"

# Only meaningful inside a git repo.
git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# git stash create returns empty when there is nothing to snapshot.
SNAP=$(git -C "$DIR" stash create "cc-checkpoint" 2>/dev/null) || exit 0
[ -z "$SNAP" ] && exit 0

git -C "$DIR" update-ref refs/cc-checkpoints/last "$SNAP" 2>/dev/null || exit 0
exit 0
