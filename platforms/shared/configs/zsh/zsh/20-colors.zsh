# LS_COLORS via dircolors — uses ANSI palette indices, so file colors track
# the terminal theme automatically. Drop a custom ~/.dircolors to override.
if (( $+commands[dircolors] )); then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi
