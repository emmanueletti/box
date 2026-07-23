bindkey -e
bindkey "\e[3~" delete-char
bindkey "^[[3;5~" kill-word     # ctrl + delete
bindkey "^H" backward-kill-word # ctrl + backspace
bindkey "^[[1;5C" forward-word  # ctrl + ->
bindkey "^[[1;5D" backward-word # ctrl + <-
bindkey '^[[H' beginning-of-line # Home key
bindkey '^[[F' end-of-line       # End key
