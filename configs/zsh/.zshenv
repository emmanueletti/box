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

# --- PATH: single source of truth ------------------------
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"  # adds ~/.cargo/bin
export BUN_INSTALL="$HOME/.bun"

typeset -U path                                     # auto-dedupe PATH entries
path=(
  # macOS only: homebrew, plus its GNU tools so the config below is one form.
  # (N) drops the entry when the glob finds nothing, so linux is unaffected.
  /opt/homebrew/bin(N)
  /opt/homebrew/sbin(N)
  /opt/homebrew/opt/*/libexec/gnubin(N)
  $HOME/.local/bin
  $BUN_INSTALL/bin
  $path
)
