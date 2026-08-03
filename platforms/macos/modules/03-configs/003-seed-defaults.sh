#!/usr/bin/env bash
#
# Copies starter files into $HOME for apps that rewrite their own config.
# Existing files are left alone, so a machine keeps whatever it drifted to.

set -euo pipefail

"${BOX_ROOT}/lib/seed.sh" "${BOX_ROOT}/platforms/shared/defaults"

echo "✅ box: defaults seeded"
