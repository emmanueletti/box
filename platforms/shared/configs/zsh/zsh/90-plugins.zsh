# Starship prompt
eval "$(starship init zsh)"

# Mise
eval "$(mise activate zsh)"

# Plugins live in /usr/share on linux and $(brew --prefix)/share on macOS.
# (N) drops the path that does not exist, so one glob covers both.

# autosuggestions (inline history hints)
_autosuggest=(/{usr,opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh(N))
if (( $#_autosuggest )); then
  source $_autosuggest[1]
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept   # Ctrl-Space accepts the suggestion
fi

# syntax highlighting (must be last)
_syntax=(/{usr,opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N))
(( $#_syntax )) && source $_syntax[1]

unset _autosuggest _syntax

# zoxide
eval "$(zoxide init --cmd cd zsh)"
