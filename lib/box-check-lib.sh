#!/usr/bin/env bash
#
# Shared helpers for the box-check-* update tools. Source, do not execute.

# Bold section header. For substeps that only print context, not an update
# check (hardware, "no updater on this OS" notes).
box_check_section() {
  printf '\n\033[1m== %s ==\033[0m\n' "$1"
}

# Same header with a ✅ -- a substep that ran and found nothing to update.
box_check_section_ok() {
  printf '\n\033[1m== %s ==\033[0m ✅\n' "$1"
}

# Fail unless a required, box-installed tool is on PATH. These tools are set up
# by box, so a missing one is a broken machine, not a reason to skip.
box_check_require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  echo "❌ ${0##*/}: required tool '$1' not installed (box should have set it up)" >&2
  exit 1
}

# box_check_run "<title>" "<extra-ok-codes>" "<clean-spec>" cmd...
#
# Runs cmd and captures its output. Exit 0 and any extra-ok-code count as
# success; anything else aborts. The clean-spec decides "no updates", then the
# section header prints with a ✅ (body hidden) when clean, or plain with the
# output beneath when there is something to update.
#
# clean-spec:
#   empty        clean when the command prints nothing
#   re:PATTERN   clean when the output matches PATTERN (bash regex)
#   code:N       clean when the exit code is N
#   !code:N      clean when the exit code is not N
box_check_run() {
  local title=$1 ok=$2 spec=$3 rc=0 out
  shift 3

  out="$("$@" 2>&1)" || rc=$?

  case " 0 $ok " in
    *" $rc "*) ;;
    *)
      echo "❌ ${0##*/}: '$*' failed (exit $rc)" >&2
      exit "$rc"
      ;;
  esac

  local clean=0
  case $spec in
    empty)      [[ -z ${out//[[:space:]]/} ]] && clean=1 ;;
    re:*)       [[ $out =~ ${spec#re:} ]] && clean=1 ;;
    code:*)     (( rc == ${spec#code:} )) && clean=1 ;;
    '!code:'*)  (( rc != ${spec#!code:} )) && clean=1 ;;
  esac

  if (( clean )); then
    box_check_section_ok "$title"
  else
    box_check_section "$title"
    [[ -n $out ]] && printf '%s\n' "$out"
  fi
}
