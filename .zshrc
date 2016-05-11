#!/usr/bin/env zsh
source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions
# check_updates # check if config still up to date
source $VAR/iterm.sh
source $VAR/antigen.sh
  antigen use oh-my-zsh
  antigen bundle git
  antigen bundle rupa/z
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-completions src
  antigen theme agnoster
  antigen apply
eval $(docker-machine env default 2> /dev/null)
# eval "$(thefuck --alias fck NOOP)"
alias l='ls -lh' # this gets overwritten by antigen

# TODO: move this to a .inputrc file
setopt extended_glob

# End manual run config
