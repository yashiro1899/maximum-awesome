if [[ -n "$SSH_ORIGINAL_COMMAND" ]]; then
  export TERM='dumb'
else
  reset
  shopt -s globstar
  tabs -4
fi

export EDITOR="/usr/local/bin/vim"
export HOMEBREW_INSTALL_BADGE=$'\xf0\x9f\x90\xb3'
export NODE_PATH="/usr/local/lib/node_modules/"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/opt/mongodb-osx-x86_64-3.6.2/bin:$PATH"
export PATH="/usr/local/opt/protoc-3.6.1-osx-x86_64/bin:$PATH"
export PYTHONSTARTUP="$HOME/.pythonrc"

# aliases
alias ag="ag --pager 'less -r'"
alias gu='git commit -am $(date +%s)'
alias j='ssh jump'
alias ls='ls -G'
alias rm='rm -i'
alias vi="/usr/local/bin/vim"
alias sshx="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias myCourse='mycli -uroot -hlocalhost bloomberg'

# completion
completion=$(/usr/local/bin/brew --prefix)/etc/bash_completion
[[ -f $completion ]] && . $completion
[[ -n "$(which aws_completer)" ]] && complete -C aws_completer aws

_pc_completion() {
    _command $1 $2 $3
}
complete -F _pc_completion proxychains4
complete -F _ssh sshx

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

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2> /dev/null  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# gvm
source $HOME/.gvm/scripts/gvm

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GOPATH="$HOME/go"
