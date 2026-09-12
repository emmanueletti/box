#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${BOX_ROOT}/lib/run-module.sh"
run_module "$MODULE_ROOT"
