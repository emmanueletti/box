#!/usr/bin/env bash
#
# Shared helpers for the box-update-* apply tools. Source, do not execute.
# Mirrors box-check-lib.sh; apply tools stream output live, so there's no run helper.

# Bold section header.
box_update_section() {
  printf '\n\033[1m== %s ==\033[0m\n' "$1"
}

# Fail unless a required, box-installed tool is on PATH. A missing one is a
# broken machine, not a reason to skip.
box_update_require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  echo "❌ ${0##*/}: required tool '$1' not installed (box should have set it up)" >&2
  exit 1
}
