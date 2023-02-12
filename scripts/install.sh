#!/usr/bin/env zsh
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v6"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

sudo -v

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
source "$HOME"/.zshrc
nvm install --lts
nvm alias default lts

"$HOME"/scripts/install-brewfile.sh
"$HOME"/scripts/install-tweaks.sh
