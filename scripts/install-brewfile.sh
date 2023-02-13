#!/usr/bin/env zsh
if test $+commands[brew] -eq 0; then
    echo "Installing homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# pinCask <cask> <commit>
#   cask: the name of the cask to pin
#   commit: the commit hash of the cask to pin to
#   example: pinCask bettertouchtool 6465265e8046847447b6812e3871eb9691a2f1ac
#   see: https://remarkablemark.org/blog/2017/02/03/install-brew-package-version/
function pinCask {
  curl "https://raw.githubusercontent.com/Homebrew/homebrew-cask/$2/Casks/$1.rb" 2>/dev/null > "$(find "$(brew --repository)" -name $1.rb)"
}

pinCask bettertouchtool 6465265e8046847447b6812e3871eb9691a2f1ac
brew bundle --file="$HOME/scripts/Brewfile" </dev/null
