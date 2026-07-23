# Modular config lives in ~/zsh/*.zsh (PATH + core exports still in ~/.zshenv).
# Numbered prefixes set load order — syntax-highlighting in 90-plugins.zsh must
# come last. Edit with `shconfig` (opens the dir in $EDITOR).
for _f in ~/zsh/*.zsh; do
  source "$_f"
done
unset _f
