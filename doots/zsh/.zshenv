# sourced for ALL zsh (login, interactive, scripts); keep cheap & silent, no subprocesses/output

export EDITOR="hx"
export VISUAL="hx"
export PAGER="less -R"
export LESS="-FRXi"
export MANWIDTH=80
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;37m'
export LESS_TERMCAP_se=$'\e[0m'
export _ZO_DOCTOR=0                                 # silences a zoxide false-positive in tool-spawned shells
export _ZO_EXCLUDE_DIRS="$HOME:*/server:*/ios:*/android:*/marketing"
export BOX_ROOT="$HOME/box"
export BOX_SCRIPTS_DIR="$BOX_ROOT/scripts/.local/bin/box-scripts"

# homebrew PATH is built in .zprofile, not here -- macOS's path_helper
# (/etc/zprofile) runs after this file and would reorder anything set here
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

if [[ $OSTYPE == darwin* ]]; then
  if [[ $CPUTYPE == arm64 ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew
  else
    export HOMEBREW_PREFIX=/usr/local
  fi
fi

if [[ $OSTYPE == darwin* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.local/bin/box-scripts
  $path
)

for _d in $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator \
          $ANDROID_HOME/cmdline-tools/latest/bin $HOME/android-studio/bin \
          $HOME/.docker/bin; do
  [[ -d $_d ]] && path=($path $_d)
done
unset _d
