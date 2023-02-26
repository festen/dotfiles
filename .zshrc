################################################################################
# Exports
################################################################################
# PRIVATE
export PRIVATE="$HOME/.private"
test -f "$PRIVATE" && source "$PRIVATE"
#export AWS_SHARED_CREDENTIALS_FILE="${PRIVATE}/aws/credentials"
#export AWS_CONFIG_FILE="${PRIVATE}/aws/config"

# CACHES
export CACHE="${HOME}/.cache"
export HISTFILE="${CACHE}/history"
export npm_config_cache="${CACHE}/npm"
export ZSHZ_DATA="${CACHE}/zshz"
export LESSHISTFILE=-

# CONFIGS
export CONFIG="${HOME}/.config"
export ZDOTDIR="${CONFIG}/zsh"
export NVM_DIR="${CONFIG}/nvm"
export HOMEBREW_BUNDLE_FILE="${HOME}/scripts/Brewfile"

# ENVIRONMENT
export EDITOR='nano'
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
export HOMEBREW_NO_ANALYTICS=1
export HISTSIZE=100000 # 100k
export SAVEHIST=100000
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
export HISTORY_SUBSTRING_SEARCH_FUZZY=true

# PATH
PATH=''
-add-path() { PATH="$PATH:$@" }
-add-path "./.bin"
-add-path "./bin"
-add-path "./node_modules/.bin"
-add-path "../node_modules/.bin"
-add-path "../../node_modules/.bin"
-add-path "../../../node_modules/.bin"
-add-path "$NVM_DIR/current/bin"
-add-path "$HOME/bin"
-add-path "/opt/bin"
-add-path "/usr/local/bin"
-add-path "/usr/bin"
-add-path "/usr/sbin"
-add-path "/bin"
-add-path "/sbin"
eval $(/opt/homebrew/bin/brew shellenv)
export PATH

################################################################################
# Aliases
################################################################################
# Basics
#alias ls='ls -h --color'
alias rm='rm -rfv'
alias copy='rsync --archive --human-readable --info progress2'
alias tree="tree -a -I '.git,.idea,node_modules'"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Utils
#alias backup='rsync --acls --archive --delete --delete-excluded --exclude node_modules --exclude .DS_Store --exclude dist --exclude build --hard-links --human-readable --info progress2 --one-file-system --progress --sparse --stats --verbose --whole-file --xattrs'
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias pubkey="cat $HOME/.ssh/personal.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias trash='trash -v'
alias ip='curl -sS ipinfo.io/ip | tee /dev/tty | pbcopy'
alias edit='storm'

# Single letter aliases
alias c='copy'
alias d='docker'
alias e='edit'
alias g='git'
alias l='ls -l'
alias t='trash'
alias x='extract'

# all other aliases
alias cl='clear && ls -l'
alias cla='clear && ls -lA'
alias copyd='copy --delete'
alias cy='(cd "$HOME/code/essent/mijn" && yarn e2e-cypress --app mijn-essent --environment localhost --serve serve --tags manual)'
alias dc='docker-compose'
alias ez='edit ~/.zshrc'
alias ff='git flow feature'
alias ffs='ff start'
alias fff='ff finish'
alias fr='git flow release'
alias frs='fr start'
alias frf='fr finish'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -va'
alias gca!='git commit -va --amend'
alias gcan!='git commit -va --amend --no-edit'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias gp='git push'
alias grh='git reset HEAD'
alias gss='git status -s'
alias gst='git status'
alias gwip='git commit -vam "wip" && git push'
alias la='ls -lA'
alias nxtest='nx affected:test --parallel --maxParallel=5 --only-failed --head=HEAD --base=master'
alias run='npm run --silent'
alias runit='docker run --rm -it'
alias save='npm install --save'
alias savedev='npm install --save-dev'
alias start='npm start --silent'
alias swagger='$HOME/code/essent/swagger/run.sh'
alias tzx='zx "$HOME/code/me/tzx/register.js"'

# TODO
# List only files/folders --> alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# Rest api colorized methods --> for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do alias "$method"="lwp-request -m '$method'"; done

################################################################################
# Plugins
################################################################################
declare -A ZINIT
ZINIT[MUTE_WARNINGS]=1
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=0 # gives 10ms speedup if set to 1
ZINIT[COMPINIT_OPTS]="-C"
ZINIT[BIN_DIR]="${CONFIG}/zinit/bin"
ZINIT[HOME_DIR]="${CONFIG}/zinit"
ZINIT[BIN]="${CONFIG}/zinit/bin/zinit.zsh"
ZINIT[REPO]="https://github.com/zdharma-continuum/zinit.git"
ZINIT[BRANCH]="v3.9.0"
mkdir -p $ZINIT[BIN_DIR]
test -f "${ZINIT[BIN]}" || git clone --branch "${ZINIT[BRANCH]}" "${ZINIT[REPO]}" "${ZINIT[BIN_DIR]}"
source "${ZINIT[BIN]}"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# turbo mode (async loaded)
zinit wait lucid light-mode for\
  atload"!_zsh_autosuggest_start"\
  atinit"zicompinit; zicdreplay"\
 zsh-users/zsh-autosuggestions\
 zsh-users/zsh-syntax-highlighting\
 djui/alias-tips\
 agkozak/zsh-z\
 lukechilds/zsh-nvm

# loaded sync
zinit lucid for\
  https://iterm2.com/shell_integration/zsh\
    pick"async.zsh"\
    src"pure.zsh"\
    light-mode\
  sindresorhus/pure\
    atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'\
    wait"1"\
  zsh-users/zsh-history-substring-search

# if no match, case-insensitive,partial-word and then substring completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt extended_glob auto_cd inc_append_history share_history HIST_IGNORE_ALL_DUPS

return 0 # avoids running anything that is auto added below

