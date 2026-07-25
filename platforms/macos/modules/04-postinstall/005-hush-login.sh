#!/usr/bin/env bash
#
# Silences the "Last login:" banner on every new shell/pane.

set -euo pipefail

# An empty ~/.hushlogin is all the terminal checks for.
if [[ -e $HOME/.hushlogin ]]; then
  echo "✅ box: login banner already hushed"
  exit 0
fi

touch "$HOME/.hushlogin"

echo "✅ box: login banner hushed"
