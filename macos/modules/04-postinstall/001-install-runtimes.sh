#!/usr/bin/env bash
#
# Installs the runtimes and language servers declared in ~/.config/mise/config.toml.
# Runs after configs, since that file arrives by symlink.

set -euo pipefail

echo "box: installing mise tools"
mise install

echo "✅ box: mise tools installed"
