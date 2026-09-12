#!/usr/bin/env bash

set -euo pipefail

echo "box: installing mise tools"
mise --cd "$HOME" install

echo "✅ box: mise tools installed"
