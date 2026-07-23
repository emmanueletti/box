autoload -Uz compinit
# rebuild the completion dump at most once a day; otherwise fast path
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' \
  'r:|[-_]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
