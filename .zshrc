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
setopt extended_glob auto_cd inc_append_history share_history
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
bindkey "^[[3~" delete-char

# history search
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
autoload -U compinit && compinit -d $ANTIGEN_COMPDUMPFILE

# Post source evaluation
eval "$(thefuck --alias fck)"

# Enable shell integration
test -e "${HOME}/.iterm/shell_integration"\
 && source "${HOME}/.iterm/shell_integration"\
 || echo "${YELLOW}WARNING:${RESET} No shell integration available."

# attach to "sys" session
if [ -z "$TMUX" ]; then
    tminit && tma sys
fi
