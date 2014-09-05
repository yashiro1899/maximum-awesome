if [[ ${PATH/\/Users/} == $PATH ]]; then
    PATH=$PATH:$HOME/.bin
    export PATH
fi
export NODE_PATH="/usr/local/lib/node_modules/"
export PYTHONSTARTUP="$HOME/.pythonrc"

alias ag="ag --pager 'less -r'"
alias ls='ls -G'
alias rm='rm -i'
alias vi="/usr/local/bin/vim"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'
