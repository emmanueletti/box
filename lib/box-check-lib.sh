#!/usr/bin/env bash
#
# Shared helpers for the box-check-* update tools. Source, do not execute.

# Bold section header.
box_check_section() {
  printf '\n\033[1m== %s ==\033[0m\n' "$1"
}

# Fail unless a required, box-installed tool is on PATH. These tools are set up
# by box, so a missing one is a broken machine, not a reason to skip.
box_check_require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  echo "❌ ${0##*/}: required tool '$1' not installed (box should have set it up)" >&2
  exit 1
}

# box_check_run "<extra-ok-codes>" cmd...
#
# Runs cmd, treating 0 and any listed code as success; any other non-zero
# aborts with a message. Lets a checker's "no updates" exit code through
# without tripping set -e (dnf 100, pacman/checkupdates 2, fwupd 2).
box_check_run() {
  local ok=$1 rc=0
  shift
  "$@" || rc=$?
  case " 0 $ok " in
    *" $rc "*) return 0 ;;
    *)
      echo "❌ ${0##*/}: '$*' failed (exit $rc)" >&2
      exit "$rc"
      ;;
  esac
}
