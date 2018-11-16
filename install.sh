#!/bin/sh

### VARS
#RED='\033[00;31m'
#GREEN='\033[00;32m'
#YELLOW='\033[00;33m'
#BLUE='\033[00;34m'
#RESET='\033[0m'
#BOLD='\033[1m'
#DIM='\033[2m'
mkdir -p $HOME/.config/dotfiles
dotdir="$HOME/.config/dotfiles"
shell=/bin/zsh
repository="https://github.com/festen/dotfiles.git"
brewfile="https://raw.githubusercontent.com/festen/dotfiles/master/.brewfile"

function cleanup {
    test -d $temp && rm -rfv $temp
}

function title {
    echo "\n\033[1m$@\033[0m"
}

function prompt  {
    echo -n "\033[00;33m$@\033[0m"
}

function running {
    echo "\033[2m$@\033[0m"
}

function success {
    echo "\033[00;32m$@\033[0m"
}

function warn {
    echo "\033[00;33m$@\033[0m"
}

function error {
    echo "\033[00;31m$@\033[0m"
}

### MAIN
trap 'cleanup' ERR EXIT
title "Dotfile installer script"
echo "This script will (re)install brew packages and casks, (re)link dotfiles and
fetch dotfiles from git. For the script to work, it needs root privileges, which
will be prompted after reviewing the installation settings
"

# Contents:
# - global vars
# - helper functions
# - main script
#  - Homebrew
#   - check/install homebrew itself
#   - install brews
#   - install casks
#  - link dotfiles
#  - run .macos tweaks


###
title "Prerequisits"
###

running "Checking homebrew install"
brew --version > /dev/null 2>&1 && hasHomebrew=1 || hasHomebrew=0
running "Checking xcode utils"
xcrun --version > /dev/null 2>&1 && hasXCodeUtils=1 || hasXCodeUtils=0
running "Checking zplugin"
test -f $HOME/.zplugin && hasZPlugin=1 || hasZPlugin=0
running "Checking shell"
test "${SHELL}" = "${shell}" && shellSet=1 || shellSet=0

###
title Settings
###
echo "Home location:     $HOME"
echo "Dotfile location:  $dotdir"
echo ""
(($hasXCodeUtils)) || warn "XCode Utils marked for installation"
(($hasHomebrew)) || warn "Homebrew marked for installation"
(($shellSet)) || warn "Default shell will change ($SHELL -> $shell)"

echo "\nTo start the installation, enter you root password and press enter"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###
title Checking dotfiles dotdir
###
if [ -d $dotdir ]; then
  if [ -n "$(git -C $dotdir status --porcelain)" ]; then
    error "$dotdir has Uncomitted changes, commit them first"
    exit 3
  fi
  running 'Pulling any new version'
  git -C $dotdir pull || { error "could not complete pull, do it manually or rerun this script after deleting $dotdir"; exit 5; }
  running 'Pushing any local changes'
  git -C $dotdir push || { error "could not complete push, do it manually or rerun this script after deleting $dotdir"; exit 4; }
fi

###
title Installing
###
temp=$(mktemp -d)

# xcode
if [ "${hasXCodeUtils}" -ne 1 ]; then
    running "Installing XCode Utils"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l |
      grep "\*.*Command Line" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ *//' |
      tr -d '\n')
    softwareupdate -i "$PROD" --verbose
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi

# homebrew
if [ "${hasHomebrew}" -ne 1 ]; then
    running "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    test $? -eq 0 || { error "Unable to install homebrew"; exit 5; }
else
    running "Making sure latest brew is installed"
    brew update
    running "Updating outdated brew packages"
    brew upgrade
fi

###
title Installing managed binaries
###
running Downloading latest brew bundle defintions
curl -fsSLo ${temp}/Brewfile ${brewfile}
running Installing brew bundle definitions
#brew bundle install --file=${temp}/Brewfile

###
title Setting up dotfiles
###
if [ ! -d $dotdir ]; then
    running Dotfiles not found, downloading dotfiles to ${dotdir}
    mkdir -p ${dotdir}
    git clone ${repository} ${dotdir}
fi

running Making sure GNU stow is installed
which stow >/dev/null 2>&1 && echo "GNU stow found at $(which stow)" || brew install stow
dirsToStow=("$(find $HOME/dots/ -mindepth 1 -maxdepth 1 -type d -not -name '\.*' -exec basename {} \;)")
for d in $dirsToStow; do
    running Linking $d
    stow -d ${dotdir} $d
done

###
title Installing ui/ux tweaks
###
source ${dotdir}/.macos

###
title Cleaning dead links
###
find -L $HOME(N) -maxdepth 1 -name -prune -o -type l -exec rm -rf {} + &

# echo "3) install ui/ux tweaks"
