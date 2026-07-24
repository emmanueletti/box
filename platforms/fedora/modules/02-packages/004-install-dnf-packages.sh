#!/usr/bin/env bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t packages < <(grep . "${MODULE_ROOT}/packages.list")

sudo dnf install -y "${packages[@]}"
