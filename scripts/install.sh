#!/usr/bin/env zsh
set -e
sudo -v
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v12"

function remoteExecute {
   curl -s "$RAW_URL"/scripts/"$1" | /usr/bin/env zsh
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
source "$HOME"/.zshrc
nvm install --lts
nvm alias default node

"$HOME"/scripts/install-brewfile.sh
"$HOME"/scripts/install-tweaks.sh
