#!/usr/bin/env zsh
set -e
sudo -v
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v15"

function remoteExecute {
   curl -s "$RAW_URL"/scripts/"$1" | /usr/bin/env zsh
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh

git checkout -f
cd $HOME || exit 1
source .zshrc || true
nvm install --lts
nvm alias default node

echo "SKIPPING BREWFILE/TWEAKS"
#"$HOME"/scripts/install-brewfile.sh || true
#"$HOME"/scripts/install-tweaks.sh || true
echo 'DONE'
