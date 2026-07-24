#!/usr/bin/env bash
#
# Box environment for install scripts: sets BOX_ROOT and SCRIPTS_DIR.
# Source this, do not execute it.

export BOX_ROOT="${BOX_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export SCRIPTS_DIR="${BOX_ROOT}/platforms/shared/scripts/.local/scripts"
