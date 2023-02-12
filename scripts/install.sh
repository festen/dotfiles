#!/usr/bin/env zshz
RAW_URL="https://raw.githubusercontent.com/festen/dotfiles/HEAD"

function remoteExecute {
  source <(curl -s "$RAW_URL"/scripts/"$1")
}

remoteExecute install-secrets.sh
remoteExecute install-dotfiles.sh
git checkout -f
remoteExecute install-brewfile.sh
remoteExecute install-tweaks.sh
