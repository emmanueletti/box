# Only functions that need the calling shell live here. Everything else is a
# script in box/bin, discoverable with box-<TAB>.

galias() { alias | grep "$@" }

mkcd() { mkdir -p "$1" && cd "$1" }

Resume() {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# yazi: cd into the dir you quit on
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ $cwd != "$PWD" && -d $cwd ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
