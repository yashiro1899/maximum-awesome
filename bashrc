export NODE_PATH="/usr/local/lib/node_modules/"
export PYTHONSTARTUP="$HOME/.pythonrc"

alias rm='rm -i'
alias ls='ls --color'
alias vi="/usr/bin/vim"

completion="/usr/share/bash-completion/bash_completion"
[[ -f $completion ]] && . $completion

GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'
complete -C aws_completer aws

# colorful less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;208m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;111m'
