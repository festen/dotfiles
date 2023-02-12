#!/usr/bin/env zsh
set -e
sudo -v
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v26"

function remoteExecute {
   curl -s "$RAW_URL"/scripts/"$1" | /usr/bin/env zsh
}

cd "$HOME" || exit 1
remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
"$HOME"/scripts/install-brewfile.sh || true
"$HOME"/scripts/install-tweaks.sh || true

eval "$(/opt/homebrew/bin/brew shellenv)"
export NVM_DIR="${HOME}/.config/nvm"
source "$(brew --prefix nvm)/nvm.sh"
nvm install --lts
nvm alias default node

exec zsh
