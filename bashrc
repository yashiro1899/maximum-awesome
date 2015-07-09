export NODE_PATH="/usr/local/lib/node_modules"
export PYTHONSTARTUP="$HOME/.pythonrc"
export SASS_BINARY_SITE="http://ued.qunar.com/node-sass/release"

alias rm='rm -i'
alias ls='ls --color'
alias vi="/usr/bin/vim"

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'
