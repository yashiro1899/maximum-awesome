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

function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/((/(/' -e 's/))/)/'
}
function proml() {
    local GREEN="\[\033[0;32m\]"
    local COLOR_END="\033[0m"
    PS1="[\u@\h \W$GREEN\$(parse_git_branch)$COLOR_END]\$ "
}
proml
