#!/bin/bash

set -euo pipefail

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

grep -v '^#' "${MODULE_ROOT}/assets/packages-pacman.list" | sudo pacman -S --needed --noconfirm -
