#!/usr/bin/env bash
# Claude Code PreToolUse hook on the Skill tool.
# Usage: gate.sh <group> <reason> <skill>...
# Denies the first call to any of the listed skills in each session, with <reason>
# sent back to the agent. The skills of a group share one mark: after one denial,
# every later call to any of them in the same session passes.
set -euo pipefail

group="$1"
reason="$2"
shift 2
input="$(cat)"

field() { printf '%s' "$input" | sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p"; }

skill="$(field skill)"
gated=0
for s in "$@"; do
  [ "$skill" = "$s" ] && gated=1
done
[ "$gated" = 1 ] || exit 0

session="$(field session_id)"
mark="${TMPDIR:-/tmp}/bonde-gate/${session:-unknown}-${group//[^A-Za-z0-9_-]/_}"
[ -e "$mark" ] && exit 0
mkdir -p "$(dirname "$mark")"
: > "$mark"

reason_json="$(printf '%s' "$reason" | sed 's/\\/\\\\/g; s/"/\\"/g')"
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason_json"
