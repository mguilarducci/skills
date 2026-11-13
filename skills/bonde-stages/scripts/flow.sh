#!/usr/bin/env bash
# Print the path-to-production flow that applies to the current repository.
# Uses <repo root>/.bonde/flow.yaml when it exists, otherwise the default bundled with this skill.
# The first output line is "# source: <path>".
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_flow="$script_dir/../flow.yaml"

flow="$default_flow"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/.bonde/flow.yaml" ]; then
  flow="$root/.bonde/flow.yaml"
fi

if [ ! -f "$flow" ]; then
  echo "flow.sh: flow file not found: $flow" >&2
  exit 1
fi

flow="$(cd "$(dirname "$flow")" && pwd)/$(basename "$flow")"
echo "# source: $flow"
cat "$flow"
