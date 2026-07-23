#!/usr/bin/env bash
#
# Makes the homebrew zsh the login shell. macOS ships an older one.
# Takes effect on next login.

set -euo pipefail

prefix="$(brew --prefix 2>/dev/null || true)"
shell="${prefix}/bin/zsh"

if [[ -z $prefix || ! -x $shell ]]; then
  echo "⚠️ box: homebrew zsh not found, skipping"
  exit 0
fi

if [[ $SHELL == "$shell" ]]; then
  echo "✅ box: login shell already ${shell}"
  exit 0
fi

# Not needed by dscl, but Terminal and other tools read this list.
if ! grep -qxF "$shell" /etc/shells; then
  echo "$shell" | sudo tee -a /etc/shells >/dev/null
fi

sudo dscl . -create "/Users/${USER}" UserShell "$shell"

echo "✅ box: login shell set to ${shell}"
