#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.agent_files}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
  exit 1
fi

if [ ! -d "$ROOT" ]; then
  echo "No $ROOT directory found."
  exit 0
fi

found=0

while IFS= read -r file; do
  commit="$(grep -E '^valid_as_of_commit:' "$file" | head -n 1 | sed 's/^valid_as_of_commit:[[:space:]]*//')"

  if [ -z "$commit" ] || [ "$commit" = "COMMIT_SHA" ]; then
    continue
  fi

  if ! git cat-file -e "$commit^{commit}" 2>/dev/null; then
    echo "Needs review: $file"
    echo "  Reason: valid_as_of_commit does not exist in this repository: $commit"
    found=1
    continue
  fi

  changed="$(git diff --name-only "$commit"..HEAD || true)"

  if [ -z "$changed" ]; then
    continue
  fi

  dependencies="$(awk '
    /^## Files This State Depends On/ {flag=1; next}
    /^## / && flag {flag=0}
    flag && /^- / {gsub(/^- /, ""); gsub(/`/, ""); print}
    /^## Touched Files/ {flag2=1; next}
    /^## / && flag2 {flag2=0}
    flag2 && /^- / {gsub(/^- /, ""); gsub(/`/, ""); print}
  ' "$file")"

  if [ -z "$dependencies" ]; then
    continue
  fi

  while IFS= read -r dep; do
    [ -z "$dep" ] && continue
    if echo "$changed" | grep -qx "$dep"; then
      echo "Needs review: $file"
      echo "  Reason: $dep changed after $commit"
      found=1
    fi
  done <<< "$dependencies"
done < <(find "$ROOT" -type f -name '*.md')

if [ "$found" -eq 0 ]; then
  echo "No stale Plumblines records detected."
fi
