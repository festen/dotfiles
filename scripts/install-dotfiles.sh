#!/usr/bin/env zsh
REPO_URL=${REPO_URL:-"git@github.com:festen/dotfiles.git"}
cd ~ || exit 1
tmpdir=$(mktemp -d)
git clone -c status.showUntrackedFiles=no -n --separate-git-dir "$HOME/.git" "$REPO_URL" "$tmpdir"
rm -r "$tmpdir"
