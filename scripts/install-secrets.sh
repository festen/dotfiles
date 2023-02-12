#!/usr/bin/env zsh
SECRETS="$HOME/Library/Mobile Documents/com~apple~CloudDocs/private-settings"

for secretPath in "$SECRETS"/*; do
  secret=$(basename "$secretPath")
  echo "Linking ${secret}..."
  rm -rf "$HOME/.${secret}"
  ln -sf "$secretPath" "$HOME/.${secret}"
done
