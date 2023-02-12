#!/usr/bin/env zsh
if test $+commands[brew] -eq 0; then
    echo "Installing homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file="$HOME/scripts/Brewfile" </dev/null
