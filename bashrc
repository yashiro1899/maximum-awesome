export EDITOR="/usr/local/bin/vim"
export HOMEBREW_INSTALL_BADGE=$'\xf0\x9f\x8d\xbc'
export NODE_PATH="/usr/local/lib/node_modules/"
export PYTHONSTARTUP="$HOME/.pythonrc"

[[ ${PATH/\/Users/} == $PATH ]] && export PATH="$PATH:$HOME/.bin"

# aliases
alias ag="ag --pager 'less -r'"
alias gu='git commit -am $(date +%s)'
alias ls='ls -G'
alias rm='rm -i'
alias vi="/usr/local/bin/vim"

# completion
completion=$(brew --prefix)/etc/bash_completion
[[ -f $completion ]] && . $completion
[[ -n "$(which aws_completer)" ]] && complete -C aws_completer aws

# git
GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "[\u@\h \W" "]\$ "'

# colorful less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;208m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;111m'

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

pc() {
    proxychains4 $@ 2> /dev/null
}

_pc_completion() {
    _command $1 $2 $3
}
complete -F _pc_completion pc
