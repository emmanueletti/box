# Homebrew's bin and its GNU tools, put ahead of the system BSD tools.
#
# This runs LAST (after 90-plugins) on purpose. Three things reorder PATH after
# ~/.zshenv and would otherwise bury these dirs behind /usr/bin:
#   1. macOS path_helper (from /etc/zprofile) shoves the system dirs to the front.
#   2. `mise activate` rebuilds PATH from its saved __MISE_ORIG_PATH, dropping
#      anything added earlier in the session (e.g. in a nested subshell).
#   3. mise's precmd hook re-runs `mise hook-env` before EVERY prompt, and that
#      rebuild happens after this file has already run -- so a one-shot prepend
#      here gets buried again the instant the first prompt renders. That is why
#      plain `ls` fell back to BSD /bin/ls ("unrecognized option
#      --group-directories-first") despite gnubin being on PATH.
#
# So we prepend from a precmd hook too. This file loads after 90-plugins, so our
# hook is appended to precmd_functions AFTER mise's and runs after it each
# prompt -- the genuine last word. `typeset -U path` (set in ~/.zshenv) makes the
# re-prepend idempotent: the dupe added earlier is dropped, floating gnubin back
# to the front. GNU sed/find/grep win too.
#
# HOMEBREW_PREFIX is set in ~/.zshenv (unset on linux, so this is skipped).
if [[ -n $HOMEBREW_PREFIX ]]; then
  _box_prepend_brew_path() {
    path=(
      $HOMEBREW_PREFIX/bin
      $HOMEBREW_PREFIX/sbin
      $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
      $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
      $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
      $HOMEBREW_PREFIX/opt/grep/libexec/gnubin
      $path
    )
  }
  _box_prepend_brew_path                        # once now, for this file's scope
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _box_prepend_brew_path    # and after every mise hook-env
fi
