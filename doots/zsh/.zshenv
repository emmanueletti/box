# sourced for ALL zsh (login, interactive, scripts); keep cheap & silent, no subprocesses/output

export EDITOR="hx"
export VISUAL="hx"
export PAGER="less -R"
export LESS="-FRX"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"                              # groff overstrike mode, required for col -bx above
export _ZO_DOCTOR=0                                 # silences a zoxide false-positive in tool-spawned shells
export BOX_ROOT="$HOME/box"
export BOX_SCRIPTS_DIR="$BOX_ROOT/scripts/.local/bin/box-scripts"

# homebrew PATH is built in .zshrc instead, not here -- macOS's path_helper (/etc/zprofile)
# and `mise activate` both run after this file and reorder PATH, so building it late there wins
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
