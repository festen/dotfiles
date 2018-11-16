#!/bin/zsh

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

### GLOBAL VARIABLES
DOTS=$(realpath $(dirname $0))

### GLOBAL FUNCTIONS
function running {
    echo "> $@"
}

echo "\$HOME=${HOME}"
echo "\$DOTS=${DOTS}"
echo "(re)linking dot files"

# PROMPT
echo "Installing and updating dotfiles"
echo "Root password: "
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# INSTALL
running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit 2
  fi
else
  ok
  # Make sure we’re using the latest Homebrew
  running "updating homebrew"
  brew update
  ok
  bot "before installing brew packages, we can upgrade any outdated packages."
  read -r -p "run brew upgrade? [y|N] " response
  if [[ $response =~ ^(y|yes|Y) ]];then
      # Upgrade any already-installed formulae
      action "upgrade brew packages..."
      brew upgrade
      ok "brews updated..."
  else
      ok "skipped brew package upgrades.";
  fi
fi


# LINK

# .macos tweaks

# echo "1) install brew stuff"
# echo "2) linking dotfiles"
# echo "3) install ui/ux tweaks"
