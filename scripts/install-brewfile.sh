#!/usr/bin/env zsh
if test $+commands[brew] -eq 0; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
fi
brew bundle --file="$HOME/scripts/Brewfile" </dev/null
