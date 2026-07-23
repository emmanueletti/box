# Homebrew's bin and its GNU tools, put ahead of the system BSD tools.
#
# This runs LAST (after 90-plugins) on purpose. Two things reorder PATH after
# ~/.zshenv and would otherwise bury these dirs behind /usr/bin:
#   1. macOS path_helper (from /etc/zprofile) shoves the system dirs to the front.
#   2. `mise activate` rebuilds PATH from its saved __MISE_ORIG_PATH, dropping
#      anything added earlier in the session (e.g. in a nested subshell).
# Prepending here -- after both have run -- is what makes GNU sed/find/grep win.
#
# HOMEBREW_PREFIX is set in ~/.zshenv (unset on linux, so this is skipped).
if [[ -n $HOMEBREW_PREFIX ]]; then
  path=(
    $HOMEBREW_PREFIX/bin
    $HOMEBREW_PREFIX/sbin
    $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
    $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
    $HOMEBREW_PREFIX/opt/grep/libexec/gnubin
    $path
  )
fi
