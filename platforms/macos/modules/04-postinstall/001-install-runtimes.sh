#!/usr/bin/env bash
#
# Installs the runtimes and language servers declared in ~/.config/mise/config.toml.
# Runs after configs, since that file arrives by symlink.
#
# Runs from $HOME so only the global config applies, not a project's tools.

set -euo pipefail

echo "box: installing mise tools"

cd "$HOME"
mise install

echo "✅ box: mise tools installed"
