export HOMEBREW_INSTALL_BADGE=$'\xf0\x9f\x8d\xbc'
export NODE_PATH="/usr/local/lib/node_modules/"
export PYTHONSTARTUP="$HOME/.pythonrc"

[[ ${PATH/\/Users/} == $PATH ]] && PATH=$PATH:$HOME/.bin
export PATH

alias ls='ls -G'
alias rm='rm -i'
alias vi="/usr/local/bin/vim"
alias ag="ag --pager 'less -r'"

completion=$(brew --prefix)/etc/bash_completion
[[ -f $completion ]] && . $completion

GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'
