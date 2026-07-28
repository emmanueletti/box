#!/usr/bin/env bash
#
# Box installer entrypoint.

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/box-env.sh"   # sets BOX_ROOT, SCRIPTS_DIR
BOX_OS="$("${SCRIPTS_DIR}/_box-detect-os")"
export BOX_OS

read -r -p "box: detected ${BOX_OS}. continue? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "❌ box: aborted"
  exit 1
fi

exec "${BOX_ROOT}/platforms/${BOX_OS}/install.sh"
