#!/usr/bin/env zsh

# Source stuff
load() { test -f "$1" && source "$1" || echo "$1 not found" }
load "$HOME/.exports"
load "$HOME/.aliases"
load "$HOME/.functions"

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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
bindkey "^[[3~" delete-char

# history search
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
autoload -U compinit && compinit

# Post source evaluation
eval "$(thefuck --alias fck)"

test -e "${HOME}/.iterm/shell_integration"\
 && source "${HOME}/.iterm/shell_integration"\
 || echo "${YELLOW}WARNING:${RESET} No shell integration available."
