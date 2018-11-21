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
shell=/usr/local/bin/zsh
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
    test -d $temp && rm -rfv $temp
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
        printf "\033[00;33m$(basename $0) $@\033[0m"
    }
    echo "Usage: $(filename install)"
    echo 'Installs updates the dotfiles and runs package managers'
    echo ''
    echo 'Optionally, when --only flag is passed, it will run a partial install'
    echo 'you can include multiple parts comma seperated, for example --only check,update'
    echo 'Possible values for --only flag:'
    echo '  sync:              Check if dotfiles are up to date and sync otherwise'
    echo '  '
    # sync dotfiles
    # change shell
    # update Homebrew
    # install bundle
    # link Dotfiles
    # check permissions
    # install tweaks
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
echo "Home location:     $HOME"
echo "Dotfile location:  $dotdir"
(($hasXCodeUtils)) || warn "XCode Utils marked for installation"
(($hasHomebrew)) || warn "Homebrew marked for installation"
(($shellSet)) || warn "Default shell will change ($SHELL -> $shell)"

echo "To start the installation, enter you root password and press enter"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###
title Checking default shell
###
if [ "$SHELL" != "$shell" ]; then
  echo "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell"
  # TODO only if not present
  cat /etc/shells | grep $shell >/dev/null || sudo sh -c "echo $shell >> /etc/shells"
  chsh -s /usr/local/bin/zsh
fi

###
title Checking dotfiles dotdir
###
if [ -d $dotdir ]; then
  if [ -n "$(git -C $dotdir status --porcelain)" ]; then
    error "$dotdir has Uncomitted changes, commit them first"
    exit 3
  fi
  echo 'Pulling any new version'
  git -C $dotdir pull || { error "could not complete pull, do it manually or rerun this script after deleting $dotdir"; exit 5; }
fi

###
title Installing
###
temp=$(mktemp -d)

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
if [ "${hasHomebrew}" -ne 1 ]; then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    test $? -eq 0 || { error "Unable to install homebrew"; exit 5; }
else
    echo "Making sure latest brew is installed"
    brew update
    echo "Updating outdated brew packages"
    brew upgrade
fi

###
title Installing managed binaries
###
echo Downloading latest brew bundle defintions
curl -fsSLo ${temp}/Brewfile ${brewfile}
echo Installing brew bundle definitions
#brew bundle install --file=${temp}/Brewfile

###
title Setting up dotfiles
###
if [ ! -d $dotdir ]; then
    echo Dotfiles not found, downloading dotfiles to ${dotdir}
    mkdir -p ${dotdir}
    git clone ${repository} ${dotdir}
fi

echo Making sure GNU stow is installed
which stow >/dev/null 2>&1 && echo "GNU stow found at $(which stow)" || brew install stow
dirsToStow=("$(find $dotdir -mindepth 1 -maxdepth 1 -type d -not -name '\.*' -exec basename {} \;)")
for d in $dirsToStow; do
    echo Linking $d
    stow --dir=${dotdir} --target=${HOME} --restow $d
done
echo 'Linking iCloud'
ln -fs Library/Mobile\ Documents/com~apple~CloudDocs $HOME/icloud
stow --dir="${HOME}/icloud" --target="${HOME}" --restow 'private-settings'

###
title Checking file permissions
zsh -c "chmod 755 ${HOME}/bin/*(N)"
echo "Permissions: ~/bin/* -> 755"
zsh -c "chmod 644 ${HOME}/.ssh/{config,known_hosts}"
echo "Permissions: ~/.ssh/{config,known_hosts} -> 644"
zsh -c "chmod 444 ${HOME}/.ssh/*.pub(N)"
echo "Permissions: ~/.ssh/*.pub -> 444"
zsh -c "chmod 400 ${HOME}/.ssh/*.key(N)"
echo "Permissions: ~/.ssh/*.key -> 400"

###
title Installing ui/ux tweaks
###
source ${dotdir}/macos.sh $hostname $dotdir
exit 0
}

test "${1}" == "--help" && help
test "${1}" == "sync" && sync
test "${1}" == 'status' && status
if [ "${1}" == "install" ]; then
    if [ "${2}" == "--only" ]; then
        runSyncDotfiles=0
        runChangeShell=0
        runUpdateHomebrew=0
        runInstallBundle=0
        runLinkDotfiles=0
        runCheckPermissions=0
        runInstallTweaks=0
        while "${3}"; do
            echo "FLAG"
            shift
        done
    fi


    flags=${@: -3}


    echo \$runSyncDotfiles=
    echo \$runChangeShell=
    echo \$runUpdateHomebrew=
    echo \$runInstallBundle=
    echo \$runLinkDotfiles=
    echo \$runCheckPermissions=
    echo \$runInstallTweaks=

    echo \$0=$0
    echo \$1=$1
    echo \$2=$2
    echo \$3=$3
    #install
fi
test "$#" -ge 1 && error "unknown argument(s): $@"
help
