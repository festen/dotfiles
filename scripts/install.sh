#!/usr/bin/env zsh
set -eo pipefail

RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v9"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

sudo -v

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

set +eo pipefail

git checkout -f
source "$HOME"/.zshrc
nvm install --lts
nvm alias default node

"$HOME"/scripts/install-brewfile.sh
"$HOME"/scripts/install-tweaks.sh
