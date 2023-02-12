#!/usr/bin/env zsh
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/v3"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh
git checkout -f
$HOME/scripts/install-brewfile.sh.sh
$HOME/scripts/install-tweaks.sh
