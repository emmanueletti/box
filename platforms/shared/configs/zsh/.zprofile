# =========================================================
# .zprofile — LOGIN shells only (tty, ssh, terminals that start a login shell).
# Sourced after ~/.zshenv and the system /etc/zprofile (macOS path_helper).
# PATH and homebrew are set up in ~/.zshenv and ~/zsh/95-homebrew-path.zsh, so
# this file is only for login-time concerns like starting a graphical session.
# =========================================================

# (linux) start hyprland on the first virtual terminal. Uncomment once the
# compositor is installed. $XDG_VTNR avoids a subprocess; the $OSTYPE guard
# keeps it inert on macOS.
#
#   if [[ $OSTYPE == linux* && -z $DISPLAY && $XDG_VTNR == 1 ]]; then
#     exec Hyprland
#   fi
