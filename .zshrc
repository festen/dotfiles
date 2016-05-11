#!/usr/bin/env zsh

# Source stuff
source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions
source $VAR/iterm.sh # shell integrations

# Antibody initialization (and download if not found)
test $+commands[antibody] -eq 1 || curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -s
source <(antibody init)
antibody bundle <<EOL
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
zsh-users/zsh-completions
rupa/z
mafredri/zsh-async
sindresorhus/pure
EOL

# ZSH options
setopt extended_glob
setopt auto_cd

# history search
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
autoload -U compinit && compinit

# Post source evaluation
eval $(docker-machine env default 2> /dev/null)
eval "$(thefuck --alias fck)"
