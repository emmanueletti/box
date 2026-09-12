# login shells only (tty, ssh, login terminals)

# Not .zshenv: /etc/zprofile's path_helper rebuilds PATH from scratch after it
# and before this file. gnubin dirs give brew's GNU tools their plain names.
[[ -n $HOMEBREW_PREFIX ]] &&
  path=($HOMEBREW_PREFIX/opt/*/libexec/gnubin(N/) $HOMEBREW_PREFIX/{bin,sbin} $path)

if command -v sway >/dev/null 2>&1 && [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $XDG_VTNR == 1 ]]; then
  exec sway
fi
