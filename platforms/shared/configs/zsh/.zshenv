# =========================================================
# .zshenv — sourced for ALL zsh (login, interactive, scripts).
# Keep this cheap & silent: no subprocesses, no output.
# Interactive-only config lives in ~/.zshrc.
# =========================================================

# --- core env (needed by non-interactive shells too) ----
export EDITOR="hx"
export VISUAL="hx"
export PAGER="less -R"
export LESS="-FRX"                                  # -R color, -F quit-if-one-screen, -X no-clear
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"                              # force groff overstrike mode so col -bx works
export _ZO_DOCTOR=0                                 # silence zoxide false-positive doctor warning in tool-spawned shells
export BOX_ROOT="$HOME/box"                          # repo root; box-* scripts read this (with a fallback)

# --- core PATH (user dirs) -------------------------------
# Homebrew's own PATH is built in ~/zsh/95-homebrew-path.zsh instead of here,
# because macOS runs path_helper (in /etc/zprofile) AFTER this file, and `mise
# activate` reorders PATH too; that module runs last and gets the last word.
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"  # adds ~/.cargo/bin
export BUN_INSTALL="$HOME/.bun"

# Homebrew lives in a different place per platform. Set the prefix here (a cheap
# built-in check, no subprocess); the interactive config uses it to build PATH.
if [[ $OSTYPE == darwin* ]]; then
  # macOS
  if [[ $CPUTYPE == arm64 ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew   # apple silicon
  else
    export HOMEBREW_PREFIX=/usr/local      # intel
  fi
fi
# linux has no homebrew, so HOMEBREW_PREFIX stays unset.

typeset -U path                                     # auto-dedupe PATH entries
path=(
  $HOME/.local/bin
  $HOME/.local/scripts   # box's own commands, kept out of .local/bin
  $BUN_INSTALL/bin
  $path
)
