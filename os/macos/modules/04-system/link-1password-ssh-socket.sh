#!/usr/bin/env bash
#
# Give the 1Password agent socket one path both OSes share. Linux serves it at
# ~/.1password/agent.sock; macOS buries it under Group Containers. Symlink the
# macOS socket there so a single ssh config line works everywhere.

set -euo pipefail

readonly SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
readonly LINK="${HOME}/.1password/agent.sock"

mkdir -p "$(dirname "$LINK")"

# -f replaces a stale link, -n stops it nesting inside an existing symlinked dir.
ln -sfn "$SOCK" "$LINK"

echo "✅ box: 1Password SSH agent socket linked at ~/.1password/agent.sock"
