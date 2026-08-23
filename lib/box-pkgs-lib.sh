#!/usr/bin/env bash
#
# Shared helpers for box-pkgs-add and box-pkgs-remove. Source, do not execute.
#
# Both commands change two things at once: what is installed on this machine
# right now, and the manifest box installs from on a fresh machine. Keeping
# those in step is the whole point -- a plain `brew install` drifts, and the
# package is gone the next time you set a machine up.

# Sets BOX_PKGS_OS and BOX_PKGS_MANIFEST, or exits with a message. After this
# returns, callers can assume both are set and the manifest file exists.
box_pkgs_setup() {
  local box="${BOX_ROOT:-$HOME/box}"

  BOX_PKGS_OS="$(_box-os-detect)"

  case "$BOX_PKGS_OS" in
    macos)  BOX_PKGS_MANIFEST="$box/platforms/macos/modules/02-packages/Brewfile" ;;
    fedora) BOX_PKGS_MANIFEST="$box/platforms/fedora/modules/02-packages/packages.list" ;;
    *)
      echo "❌ ${0##*/}: box has no package manifest for $BOX_PKGS_OS yet" >&2
      exit 1
      ;;
  esac

  [[ -f $BOX_PKGS_MANIFEST ]] && return 0

  echo "❌ ${0##*/}: manifest not found at ${BOX_PKGS_MANIFEST}" >&2
  exit 1
}

# The manifest line to write for a package. A Brewfile spells formulae and casks
# differently, so ask brew which one this turned out to be; every other manifest
# is one bare name per line.
box_pkgs_entry() {
  local pkg=$1

  if [[ $BOX_PKGS_OS != "macos" ]]; then
    echo "$pkg"
    return 0
  fi

  if brew list --cask -1 2>/dev/null | grep -qxF "$pkg"; then
    echo "cask \"${pkg}\""
  else
    echo "brew \"${pkg}\""
  fi
}

# Every manifest line that could stand for this package, one per line. Removal
# compares these as exact strings rather than matching a pattern, because
# package names contain regex characters (logi-options+).
box_pkgs_entries() {
  local pkg=$1

  if [[ $BOX_PKGS_OS == "macos" ]]; then
    printf '%s\n' "brew \"${pkg}\"" "cask \"${pkg}\""
  else
    printf '%s\n' "$pkg"
  fi
}

# True when the manifest already has this exact line.
box_pkgs_has_line() {
  grep -qxF "$1" "$BOX_PKGS_MANIFEST"
}

# Prints the line the manifest already carries for this package, or returns 1
# when there is none. Checks every form the entry could take, so a package
# listed as a formula is still found when brew now calls it a cask -- otherwise
# adding it again would write a second line for the same thing.
box_pkgs_find() {
  local candidate

  while IFS= read -r candidate; do
    if box_pkgs_has_line "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done < <(box_pkgs_entries "$1")

  return 1
}
