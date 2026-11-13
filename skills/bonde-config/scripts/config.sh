#!/usr/bin/env bash
# Print the bonde configuration that applies to the current repository.
# Merges <repo root>/.bonde/config.yaml over the default bundled with this skill,
# per top-level key: a key the repository defines replaces the default's whole key.
# Each key's block is preceded by "# <key>: from <path>".
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default="$(cd "$script_dir/.." && pwd)/config.yaml"

if [ ! -f "$default" ]; then
  echo "config.sh: default config not found: $default" >&2
  exit 1
fi

repo=""
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/.bonde/config.yaml" ]; then
  repo="$root/.bonde/config.yaml"
fi

# Top-level keys of a YAML file, in order.
keys() { sed -n 's/^\([A-Za-z_][A-Za-z0-9_-]*\):.*/\1/p' "$1"; }

# The block of one top-level key: its line and every following line up to the next top-level key.
block() {
  awk -v key="$2" '
    /^[A-Za-z_][A-Za-z0-9_-]*:/ { split($0, a, ":"); inside = (a[1] == key) }
    inside { print }
  ' "$1"
}

all_keys="$(keys "$default"; [ -n "$repo" ] && keys "$repo" || true)"
first=1
for key in $(awk '!seen[$0]++' <<<"$all_keys"); do
  src="$default"
  if [ -n "$repo" ] && keys "$repo" | grep -qx "$key"; then
    src="$repo"
  fi
  [ $first -eq 1 ] || echo
  first=0
  echo "# $key: from $src"
  block "$src" "$key" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}'
done
