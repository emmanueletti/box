# login shells only (tty, ssh, login terminals); PATH/homebrew live in .zshenv/.zshrc

if command -v uwsm >/dev/null 2>&1 && [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $XDG_VTNR == 1 ]]; then
  exec uwsm start -- sway
fi
