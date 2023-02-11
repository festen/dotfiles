set -v
REPO_URL=${REPO_URL:-"https://github.com/festen/dotfiles.git"}

cd ~ || exit 1
tmpdir=$(mktemp -d)
git clone -c status.showUntrackedFiles=no -n --separate-git-dir "$HOME/.git" "$REPO_URL" "$tmpdir"
rm -r "$tmpdir"
git checkout -f
source "$HOME/scripts/install-secrets.sh"
source "$HOME/scripts/install-brewfile.sh"
source "$HOME/scripts/install-tweaks.sh"
