set -v
REPO_URL=${REPO_URL:-"git@github.com:festen/dotfiles.git"}

while true; do
    read -p "This will overwrite dotfiles in $HOME, continue? [yn]" yn
    case $yn in
        [Yy]* ) break;;
        *) exit;;
    esac
done

cd ~ || exit 1
tmpdir=$(mktemp -d)
git clone -c status.showUntrackedFiles=no -n --separate-git-dir "$HOME/.git" "$REPO_URL" "$tmpdir"
rm -r "$tmpdir"
git checkout -f
source "$HOME/scripts/install-secrets.sh"
source "$HOME/scripts/install-brewfile.sh"
source "$HOME/scripts/install-tweaks.sh"
