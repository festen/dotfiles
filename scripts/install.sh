#!/usr/bin/env zsh
set -e
sudo -v
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v11"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
source "$HOME"/.zshrc
nvm install --lts
nvm alias default node

"$HOME"/scripts/install-brewfile.sh
"$HOME"/scripts/install-tweaks.sh
