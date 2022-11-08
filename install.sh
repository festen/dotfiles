#!/usr/bin/env zsh
set -xe

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

#echo -n "Checking Command Line Tools... "
#if ! xcode-select -p >/dev/null 2>&1; then
#  echo "not found"
#  echo "Asking for sudo pw to search for Command Line Tools online"
#  sudo -v
#  echo "Searching online for the Command Line Tools"
#  clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
#  /usr/bin/touch ${clt_placeholder}
#  clt_label=$(/usr/sbin/softwareupdate -l | grep -E "Label: Command Line Tools" | sed 's/^\* Label: //' | sort | tail -n1)
#  echo "Installing ${clt_label}"
#  sudo /usr/sbin/softwareupdate -i ${clt_label}
#  sudo /bin/rm -f ${clt_placeholder}
#  sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
#else
#  echo "done"
#fi

# Ensure node installation
echo "Checking node.js... "
if ! node --version >/dev/null 2>&1; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh 2>/dev/null | $SHELL >/dev/null 2>&1
    . "${HOME}"/.nvm/nvm.sh
    nvm install --lts
    test $? -eq 0 || exit 103
fi
echo "done, using node.js version $(node --version)"

# Download dotfiles
/usr/bin/curl -sLo "${TMP_DIR}/temp.zip" https://github.com/festen/dotfiles/archive/refs/heads/master.zip || exit 104
/usr/bin/unzip "${TMP_DIR}/temp" || exit 105

cd "${TMP_DIR}/dotfiles-master/installer" || exit 106
npm install --silent || exit 107
npm start --silent install || exit 108
