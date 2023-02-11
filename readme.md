# Dotfiles

## Easy install
This will overwrite any existing files in your home directory. Use at your own risk. it is a condensed version of what is described below.
```shell
source <(curl -s https://raw.githubusercontent.com/festen/dotfiles/HEAD/scripts/install.sh)
```

## Raw process
Based on an article (copied below): Dotfiles the easy way
https://dev.to/bowmanjd/dotfiles-the-easy-way-3iio

### Step one: git clone
```shell
cd ~ || exit 1
git clone -c status.showUntrackedFiles=no -n --separate-git-dir .git $REPO_URL tmpdir
rm -r tmpdir
```
Rationale:
- `status.showUntrackedFiles` is set to "no" so that future `git status` requests only show files that were intentionally tracked with `git add` and `git commit`
- `-n` means no checkout. We aren't ready for it yet.
- `--separate-git-dir .git` takes some explanation. It is impossible to `git clone` into a non-empty directory without some extra steps. This trick does it in one step (two if you count the deletion of the throwaway directory). Tell Git to use a separate Git directory but then, sneaky miscreants that we are, we name the directory the default: `.git`
- The undesirable side effect is an extra directory `tmpdir` that has a single `.git` file of no consequence. The entire directory can safely be removed.

### Step two for non-empty repo: git checkout
```shell
git checkout
```
Deal with any file conflicts. For instance, you might backup and remove an existing `.bashrc`. Then run git checkout again. If you are sure that overwriting is OK, you can pass the force flag:
```shell
git checkout -f
```

### Step two if new (empty) repo: add files and push
If this is a brand new setup, your repo is likely empty. Add some files:
```shell
git add .bashrc
git commit -m "initial commit of Bash config"
```
Repeat as necessary with additional files and directories. Then push:
```shell
git push
```

### Step three: maintain
Keep your files up to date with `git add`, `git commit`, `git push`. Pull remote changes with `git pull`. In other words, manage your home directory as you would any other Git repo. Please avoid `git add .` as that will track every file in your home directory, an undesirable endeavor.

If this spawns other creative ideas or optimizations, feel free to post in the comments!
