#!/usr/bin/env bash
#
# Installs GNU stow, used to symlink the dotfiles.

set -euo pipefail

# brew is not on PATH yet in the same run that installed it.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v stow >/dev/null 2>&1; then
  echo "✅ box: stow already installed"
  exit 0
fi

echo "box: installing stow"
brew install stow

echo "✅ box: stow installed"
