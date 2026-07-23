setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS   # supersedes HIST_IGNORE_DUPS
setopt SHARE_HISTORY          # already implies INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_GLOB
setopt PROMPT_SUBST
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT  # cd builds a stack: cd -<TAB>
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS        # dedupe search + saved history
setopt EXTENDED_HISTORY                            # timestamps in history

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
