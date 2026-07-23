#!/usr/bin/env bash
#
# Installs tpm and the plugins tmux.conf declares. tpm is not a formula, it is a
# clone, and tmux.conf runs it from this path.

set -euo pipefail

tpm="${HOME}/.config/tmux/plugins/tpm"

if [[ ! -d $tpm ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
fi

"${tpm}/bin/install_plugins"

echo "✅ box: tmux plugins installed"
