#!/usr/bin/env bash
#
# Shared helpers for the box-system-update-* apply tools. Source, do not execute.
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

# Record a step that failed so the run can carry on and report it at the end.
BOX_UPDATE_FAILED=()

box_update_fail() {
  BOX_UPDATE_FAILED+=("$1")
  echo "❌ ${0##*/}: $1 failed, continuing" >&2
}

box_update_summary() {
  if (( ${#BOX_UPDATE_FAILED[@]} == 0 )); then
    echo "✅ ${0##*/}: done"
    return 0
  fi
  printf '\n\033[1m== failed ==\033[0m\n'
  printf '  %s\n' "${BOX_UPDATE_FAILED[@]}"
  return 1
}
