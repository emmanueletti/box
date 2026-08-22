#!/usr/bin/env bash

set -euo pipefail

settings="${BOX_ROOT}/platforms/shared/configs/claude/.claude/settings.json"

if ! command -v claude >/dev/null 2>&1; then
  echo "box: claude CLI not found, skipping plugin install"
  exit 0
fi

jq -r '.extraKnownMarketplaces // {} | to_entries[] | .value.source.repo // empty' "$settings" |
  while read -r repo; do
    echo "box: adding marketplace $repo"
    claude plugin marketplace add "$repo" || echo "⚠️ box: could not add marketplace $repo"
  done

# Install every enabled plugin (value == true); plugins set to false are skipped.
jq -r '.enabledPlugins // {} | to_entries[] | select(.value == true) | .key' "$settings" |
  while read -r plugin; do
    echo "box: installing plugin $plugin"
    claude plugin install "$plugin" || echo "⚠️ box: could not install plugin $plugin"
  done

echo "✅ box: claude plugins installed"
