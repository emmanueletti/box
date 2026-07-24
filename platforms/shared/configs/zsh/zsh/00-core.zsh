bindkey -e
bindkey "\e[3~" delete-char
bindkey "^[[3;5~" kill-word     # ctrl + delete
bindkey "^H" backward-kill-word # ctrl + backspace
bindkey "^[^?" backward-kill-word # opt + delete
bindkey "^[[1;5C" forward-word  # ctrl + ->
bindkey "^[[1;5D" backward-word # ctrl + <-
bindkey '^[[H' beginning-of-line # Home key
bindkey '^[[F' end-of-line       # End key

setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS   # supersedes HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY     # write each command to $HISTFILE at once, but don't pull other panes' history into up-arrow
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT  # cd builds a stack: cd -<TAB>
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS        # dedupe search + saved history
setopt EXTENDED_HISTORY                            # timestamps in history

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# LS_COLORS via dircolors — uses ANSI palette indices, so file colors track
# the terminal theme automatically. Drop a custom ~/.dircolors to override.
if (( $+commands[dircolors] )); then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi
