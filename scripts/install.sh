#!/usr/bin/env zsh
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v5"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
source "$HOME"/.zshrc
nvm install default
nvm alias default node

"$HOME"/scripts/install-brewfile.sh
"$HOME"/scripts/install-tweaks.sh
