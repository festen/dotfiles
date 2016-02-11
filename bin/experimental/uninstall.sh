#!/bin/sh

LOGFILE=/tmp/dotfiles.log
DOTFILES=${HOME}/dotfiles
echo > ${LOGFILE}

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  printf '\nInstallation failed, error:\n\033[0;31m'
  cat ${LOGFILE} | sed -e 's/^/  /'
  printf '\033[0m'
  exit 1
}

remove_broken_links() {
  sudo find -L $1 -name -prune -o -type l -exec rm {} +
}

isDarwin() {
    [ "$(uname)" = 'Darwin' ]
    return $?
}

# Ask for the administrator password upfront
user 'Please provide your sudo password:'
read -s sudo_password
sudo -S sudo -v <<< ${sudo_password}
if [ $? -eq 0 ]; then success 'Password provided'; else fail "Wrong password"; fi
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if isDarwin; then
    info 'Uninstalling Homebrew'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)" <<< y >/dev/null 2>${LOGFILE}
    rm -rf /usr/local/bin/brew /usr/local/Cellar /opt/hombrew-cask
    if [ $? -eq 0 ]; then success 'Uninstalled Homebrew'; else fail "Uninstalling Homebrew failed"; fi
fi

if $(which npm >/dev/null 2>&1); then
    info 'Uninstalling NPM'
    rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/npm* >/dev/null 2>${LOGFILE}
    rm -rf /usr/local/lib/node_modules >/dev/null 2>${LOGFILE}
    if [ $? -eq 0 ]; then success 'Uninstalled NPM'; else fail "Uninstalling NPM failed"; fi
fi

info 'Cleaning links in ~'
rm -rf ${HOME}/{bin,docs,dotfiles} ${HOME}/.{DS_Store,Trash,antigen,atom,dictionary,gitconfig,gitignore,hushlogin,iterm,ssh,subversion,zcompdump,zsh_history,zshrc} >/dev/null 2>${LOGFILE}
if [ $? -eq 0 ]; then success 'Cleaned links in ~'; else fail "Cleaning links in ~ failed"; fi

info 'Changing shell to /bin/sh'
newShell=$(which sh)
sudo -S chsh -s $newShell ${USER} <<< ${sudo_password} >/dev/null 2>${LOGFILE}
if [ $? -eq 0 ]; then success "Changed shell to $newShell"; SHELL=$newShell; else fail "Changing shell to $newShell failed"; fi

info 'Removing broken links'
remove_broken_links /usr/local/bin
remove_broken_links ${HOME}
if isDarwin; then
    remove_broken_links /Applications
    remove_broken_links ${HOME}/Applications
fi
if [ $? -eq 0 ]; then success 'Removed broken links'; else fail "Removing broken links failed"; fi
