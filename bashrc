function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/((/(/' -e 's/))/)/'
}
function proml() {
    local GREEN="\[\033[0;32m\]"
    local COLOR_END="\033[0m"
    PS1="[\u@\h \W$GREEN\$(parse_git_branch)$COLOR_END]\$ "
}
proml

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

alias rm='rm -i'
alias vi="/usr/bin/vim"
if [ -e /usr/bin/vimx ]; then
    alias vi="/usr/bin/vimx"
    alias vim="/usr/bin/vimx"
fi
