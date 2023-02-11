################################################################################
# Exports
################################################################################
mkdir -p $HOME/.cache/zsh $HOME/.config/zsh/.zplugin/bin

# ENVIRONMENT
test -f "$HOME/.private" && source "$HOME/.private"
export LESSHISTFILE='-'
export HISTFILE="${HOME}/.cache/history"
export HISTSIZE=1000
export SAVEHIST=1000
export EDITOR='nano'
export ZDOTDIR="${HOME}/.config/zsh"
export NVM_DIR="${HOME}/.nvm"
export NVM_LAZY_LOAD=false
export NVM_AUTO_USE=true
export HOMEBREW_BUNDLE_FILE="${HOME}/.homebrew/Brewfile"

# PATH
PATH=''
-add-path() { PATH="$PATH:$@" }
-add-path "./.bin"
-add-path "./bin"
-add-path "./node_modules/.bin"
-add-path "../node_modules/.bin"
-add-path "../../node_modules/.bin"
-add-path "../../../node_modules/.bin"
-add-path "$NVM_DIR/current"
-add-path "$HOME/bin"
-add-path "/opt/homebrew/bin/"
-add-path "/opt/bin"
-add-path "/usr/local/bin"
-add-path "/usr/bin"
-add-path "/usr/sbin"
-add-path "/bin"
-add-path "/sbin"
-add-path "$BUN_INSTALL/bin"
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
declare -A ZPLGM
ZPLGM[MUTE_WARNINGS]=1
ZPLGM[BIN_DIR]="${ZDOTDIR}/.zplugin/bin"
ZPLGM[HOME_DIR]="${ZDOTDIR}/.zplugin"
ZPLGM[BIN]="${ZDOTDIR}/.zplugin/bin/zplugin.zsh"

test -f "${ZPLGM[BIN]}" || git clone https://github.com/festen/zplugin.git "${ZPLGM[BIN_DIR]}"
source "${ZPLGM[BIN]}"

autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
zplugin light rupa/z
zplugin light mafredri/zsh-async
zplugin ice pick"async.zsh" src"pure.zsh"
zplugin light sindresorhus/pure
zplugin light zsh-users/zsh-syntax-highlighting
zplugin light zsh-users/zsh-history-substring-search
zplugin ice wait"1" atload'_zsh_autosuggest_start' silent
zplugin light zsh-users/zsh-autosuggestions
zplugin ice wait"1" silent
zplugin light djui/alias-tips
zplugin ice wait"1" silent
zplugin light arzzen/calc.plugin.zsh
zplugin light buonomo/yarn-completion
zplugin snippet https://iterm2.com/shell_integration/zsh
zplugin ice blockf wait"1" silent
zplugin load zsh-users/zsh-completions
zplugin ice atinit"autoload compinit; compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION; zpcdreplay" wait"1" silent
zplugin load lukechilds/zsh-better-npm-completion
zplugin ice blockf wait"1" silent
zplugin load lukechilds/zsh-nvm
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
setopt extended_glob auto_cd inc_append_history share_history

test $+commands[npm] -eq 1 && source <(npm completion zsh) # npm completions

return 0
