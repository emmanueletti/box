autoload -Uz compinit
# keep the dump out of $HOME, in the XDG cache dir
_zdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d ${_zdump:h} ]] || mkdir -p "${_zdump:h}"
# rebuild the completion dump at most once a day; otherwise fast path
if [[ -n $_zdump(#qN.mh+24) ]]; then
  compinit -d "$_zdump"
else
  compinit -C -d "$_zdump"
fi
unset _zdump
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[-_]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# fd as the engine: fast, respects .gitignore, includes dotfiles
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border --info=inline \
  --bind 'ctrl-/:toggle-preview' --bind 'ctrl-u:preview-half-page-up' \
  --bind 'ctrl-d:preview-half-page-down'"
# Ctrl-T (file widget, rebound to Ctrl-F below): bat preview
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
# Alt-C (cd into dir): tree preview
export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {} | head -200'"
# Ctrl-R (history): wrapped command preview + Ctrl-Y copies it to clipboard
if (( $+commands[wl-copy] )); then
  _clip=wl-copy
else
  _clip=pbcopy
fi
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap \
  --bind 'ctrl-y:execute-silent(echo -n {2..} | $_clip)+abort'"
unset _clip

source <(fzf --zsh)
# zellij eats Ctrl-T (Tab mode), so move the file-paste widget to Ctrl-F
# (Ctrl-F was just forward-char in emacs mode == redundant with the -> arrow)
bindkey '^F' fzf-file-widget
