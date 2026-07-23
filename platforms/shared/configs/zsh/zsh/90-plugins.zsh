# Starship prompt
eval "$(starship init zsh)"

# Mise
eval "$(mise activate zsh)"

# The plugin files ship with the packages, in a different place per platform.
if [[ $OSTYPE == darwin* ]]; then
  _plugins=$HOMEBREW_PREFIX/share   # macOS (intel: /usr/local, silicon: /opt/homebrew)
else
  _plugins=/usr/share               # linux
fi

# autosuggestions (inline history hints)
if [[ -r $_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept   # Ctrl-Space accepts the suggestion
fi

# syntax highlighting (must be last)
if [[ -r $_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

unset _plugins

# zoxide
eval "$(zoxide init --cmd cd zsh)"
