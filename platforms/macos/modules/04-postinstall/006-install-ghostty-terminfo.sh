#!/usr/bin/env bash
#
# Installs the xterm-ghostty terminfo into ~/.terminfo so SSH sessions render
# correctly. Ghostty ships terminfo only inside its app bundle, which ncurses
# does not search over SSH -- without this, remote shells get garbled keys.

set -euo pipefail

app_terminfo="/Applications/Ghostty.app/Contents/Resources/terminfo"

if [[ ! -d $app_terminfo ]]; then
  echo "⚠️ box: Ghostty.app not found, skipping terminfo"
  exit 0
fi

if [[ -f "${HOME}/.terminfo/78/xterm-ghostty" ]]; then
  echo "✅ box: ghostty terminfo already installed"
  exit 0
fi

# Point ncurses at the app bundle so infocmp can read the compiled entry, then
# recompile it into the user db that SSH logins actually search.
TERMINFO_DIRS="$app_terminfo" infocmp -x xterm-ghostty | tic -x -o "${HOME}/.terminfo" -

echo "✅ box: ghostty terminfo installed"
