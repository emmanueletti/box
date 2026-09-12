#!/usr/bin/env bash

set -euo pipefail

BOX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOX_SCRIPTS_DIR="${BOX_ROOT}/scripts/.local/bin/box-scripts"

export BOX_ROOT
export BOX_SCRIPTS_DIR

OS="$("${BOX_SCRIPTS_DIR}/lib/os-detect")"

read -r -p "box: detected ${OS}. continue? [y/N] " reply

if [[ $reply != "y" ]]; then
  echo "❌ box setup: aborted"
  exit 1
fi

exec "${BOX_ROOT}/os/${OS}/setup.sh"
