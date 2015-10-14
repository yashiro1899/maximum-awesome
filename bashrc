export NODE_PATH="/usr/local/lib/node_modules/"
export PYTHONSTARTUP="$HOME/.pythonrc"

alias rm='rm -i'
alias ls='ls --color'
alias vi="/usr/bin/vim"

completion="/usr/share/bash-completion/bash_completion"
[[ -f $completion ]] && . $completion

GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'
