#!/bin/sh
set -e

### VARS
#RED='\033[00;31m'
#GREEN='\033[00;32m'
#YELLOW='\033[00;33m'
#BLUE='\033[00;34m'
#RESET='\033[0m'
#BOLD='\033[1m'
#DIM='\033[2m'
mkdir -p $HOME/.config
dotdir="$HOME/.config/dotfiles"
shell=/bin/zsh
repository="https://github.com/festen/dotfiles.git"
brewfile="https://raw.githubusercontent.com/festen/dotfiles/master/Brewfile"

# Run everything be default
runSyncDotfiles=1
runChangeShell=1
runUpdateHomebrew=1
runInstallBundle=1
runLinkDotfiles=1
runCheckPermissions=1
runInstallTweaks=1

function cleanup {
    title Cleanup
    zsh -c "find -L {/usr/local/bin,/Applications,$HOME,$HOME/Applications}(N) -maxdepth 1 -name -prune -o -type l -exec rm -rfv {} +"
    test -n "$temp" && test -d $temp && rm -rfv $temp
}

function status {
    git -C $dotdir status
    exit 0
}

function sync {
    git -C $dotdir add .
    git -C $dotdir commit --all --message '.'
    git -C $dotdir pull
    git -C $dotdir push
    exit 0
}

function help {
    function filename {
        printf "\033[00;33mdots $@\033[0m"
    }
    echo "Usage: $(filename install)"
    echo 'Installs updates the dotfiles and runs package managers'
    echo ''
    echo 'Optionally, when --only flag is passed, it will run a partial install'
    echo 'you can include multiple parts comma seperated, for example --only check,update'
    echo 'Possible values for --only flag:'
    echo '  sync:    Check if dotfiles are up to date and sync otherwise'
    echo '  check:   Check default shell and permissions'
    echo '  update:  Upgrade homebrew installation and installed packages'
    echo '  install: Run brew bundle'
    echo '  link:    Link dotfiles'
    echo '  tweaks:  Run macos tweaks'
    echo ""
    echo "the following auxillary runs are available"
    echo "  $(filename sync):   Will commit and pull/push latest version of dotfiles"
    echo "  $(filename status): Displays the version control status (git status)"
    echo "  $(filename --help): Displays this helper"
    exit 0
}

function title {
    echo "\n\033[1m$@\033[0m"
}

function prompt  {
    echo -n "\033[00;33m$@\033[0m"
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
function install {
trap 'cleanup' ERR EXIT
title "Dotfile installer script"
echo "This script will (re)install brew packages and casks, (re)link dotfiles and
fetch dotfiles from git. For the script to work, it needs root privileges, which
will be prompted after reviewing the installation settings"

###
title "Prerequisits"
###

echo "Checking homebrew install"
brew --version > /dev/null 2>&1 && hasHomebrew=1 || hasHomebrew=0
echo "Checking xcode utils"
xcrun --version > /dev/null 2>&1 && hasXCodeUtils=1 || hasXCodeUtils=0
echo "Checking zplugin"
test -f $HOME/.zplugin && hasZPlugin=1 || hasZPlugin=0
echo "Checking shell"
test "${SHELL}" = "${shell}" && shellSet=1 || shellSet=0

###
title Settings
###
echo "Home location:   $HOME"
echo "Dotfile location: $dotdir"
(($hasXCodeUtils)) || warn "XCode Utils marked for installation"
if [ "$runUpdateHomebrew" -eq 1 ]; then (($hasHomebrew)) || warn "Homebrew marked for installation"; fi
if [ "$runChangeShell" -eq 1 ]; then (($shellSet)) || warn "Default shell will change ($SHELL -> $shell)"; fi

echo "To start the installation, enter you root password and press enter"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$runChangeShell" -eq 1 ] && [ "$SHELL" != "$shell" ]; then
  ###
  title Checking default shell
  ###
  echo "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell"
  # TODO only if not present
  cat /etc/shells | grep $shell >/dev/null || sudo sh -c "echo $shell >> /etc/shells"
  chsh -s /usr/local/bin/zsh
fi

if [ "$runSyncDotfiles" -eq 1 ] && [ -d $dotdir ]; then
  ###
  title Checking dotfiles dotdir
  ###
  if [ -n "$(git -C $dotdir status --porcelain)" ]; then
    error "$dotdir has Uncomitted changes, commit them first"
    exit 3
  fi
  echo 'Pulling any new version'
  git -C $dotdir pull || { error "could not complete pull, do it manually or rerun this script after deleting $dotdir"; exit 5; }
fi

if [ "${hasXCodeUtils}" -ne 1 -o "${runUpdateHomebrew}" -eq 1 ]; then
    ###
    title Installing prerequisits
    ###
fi


# xcode
if [ "${hasXCodeUtils}" -ne 1 ]; then
    echo "Installing XCode Utils"
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
if [ "${runUpdateHomebrew}" -eq 1 ] && [ "${hasHomebrew}" -ne 1 ]; then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    test $? -eq 0 || { error "Unable to install homebrew"; exit 5; }
else
    echo "Making sure latest brew is installed"
    brew update
    echo "Updating outdated brew packages"
    brew upgrade
fi

if [ "${runInstallBundle}" -eq 1 ]; then
    ###
    title Installing managed binaries
    ###
    temp=$(mktemp -d)
    echo Downloading latest brew bundle defintions
    curl -fsSLo ${temp}/Brewfile ${brewfile}
    echo Installing brew bundle definitions
    brew bundle install --file=${temp}/Brewfile
fi

if [ "${runLinkDotfiles}" -eq 1 ] && [ ! -d $dotdir ]; then
    ###
    title Setting up dotfiles
    ###
    echo Dotfiles not found, downloading dotfiles to ${dotdir}
    mkdir -p ${dotdir}
    git clone ${repository} ${dotdir}

    echo Making sure GNU stow is installed
    which stow >/dev/null 2>&1 && echo "GNU stow found at $(which stow)" || brew install stow
    dirsToStow=("$(gfind $dotdir -mindepth 1 -maxdepth 1 -type d -not -name '\.*' -printf "%f\n")")
    for d in $dirsToStow; do
        echo Linking $d
        stow --dir=${dotdir} --target=${HOME} --restow $d
    done
    echo 'Linking iCloud'
    ln -fs Library/Mobile\ Documents/com~apple~CloudDocs $HOME/icloud
    stow --dir="${HOME}/icloud" --target="${HOME}" --restow 'private-settings'
fi

if [ "$runCheckPermissions" -eq 1 ]; then
    ###
    title Checking file permissions
    ###
    zsh -c "chmod 755 ${HOME}/bin/*(N)"
    echo "Permissions: ~/bin/* -> 755"
    zsh -c "chmod 644 ${HOME}/.ssh/{config,known_hosts}"
    echo "Permissions: ~/.ssh/{config,known_hosts} -> 644"
    zsh -c "chmod 444 ${HOME}/.ssh/*.pub(N)"
    echo "Permissions: ~/.ssh/*.pub -> 444"
    zsh -c "chmod 400 ${HOME}/.ssh/*.key(N)"
    echo "Permissions: ~/.ssh/*.key -> 400"
fi

if [ "$runInstallTweaks" -eq 1 ]; then
    ###
    title Installing ui/ux tweaks
    ###
    source ${dotdir}/macos.sh $hostname $dotdir
fi

exit 0
}

test "${1}" == "--help" && help
test "${1}" == "sync" && sync
test "${1}" == 'status' && status
if [ "${1}" == "--only" ]; then
    runSyncDotfiles=0
    runChangeShell=0
    runUpdateHomebrew=0
    runInstallBundle=0
    runLinkDotfiles=0
    runCheckPermissions=0
    runInstallTweaks=0
    shift 1
    while test -n "$1"; do
        test "$1" = 'sync' && runSyncDotfiles=1
        test "$1" = 'check' && runChangeShell=1
        test "$1" = 'update' && runUpdateHomebrew=1
        test "$1" = 'install' && runInstallBundle=1
        test "$1" = 'link' && runLinkDotfiles=1
        test "$1" = 'check' && runCheckPermissions=1
        test "$1" = 'tweaks' && runInstallTweaks=1
        shift 1
    done
fi
test "$#" -ge 1 && error "unknown argument(s): $@"
install
