################################################################################
# Exports
################################################################################
mkdir -p $HOME/.cache/zsh $HOME/.config/zsh #$HOME/.local

# ENVIRONMENT
test -f "$HOME/.private" && source "$HOME/.private"
export SHELL="/bin/zsh"
export LESSHISTFILE='-'
export HISTFILE=.cache/history
export HISTSIZE=1000
export SAVEHIST=1000
export EDITOR='nano'
export ZDOTDIR="${HOME}/.config/zsh"

# PATH
PATH=''
-add-path() { PATH="$PATH:$@" }
-add-path "./.bin"
-add-path "./bin"
-add-path "./node_modules/.bin"
-add-path "$HOME/bin"
-add-path "/usr/local/opt/coreutils/libexec/gnubin"
-add-path "/usr/local/opt/gnu-sed/libexec/gnubin"
-add-path "/usr/local/opt/gnu-tar/libexec/gnubin"
-add-path "/usr/local/opt/gnu-indent/libexec/gnubin"
-add-path "/usr/local/bin"
-add-path "/usr/bin"
-add-path "/bin"
-add-path "/usr/sbin"
-add-path "/sbin"
export PATH

################################################################################
# Aliases
################################################################################
# Basics
alias ls='ls -h --color'
alias rm='rm -rfv'
alias copy='rsync --archive --human-readable --info progress2'
alias tree="tree -a -I '.git'"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Utils
alias backup='copyd --acls --archive --delete --hard-links --hfs-compression --one-file-system --protect-decmpfs --sparse --stats --xattrs'
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias pubkey="cat $HOME/.ssh/personal.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias trash='trash -v'
alias ip='curl -sS ipinfo.io/ip | tee /dev/tty | pbcopy'

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
alias grh'git reset HEAD'
alias gss='git status -s'
alias gst='git status'
alias gwip='git commit -vam "wip" && git push'
alias la='ls -lA'
alias run='npm run --silent'
alias runit='docker run --rm -it'
alias save='npm install --save'
alias savedev='npm install --save-dev'
alias start='npm start --silent'

# TODO
# List only files/folders --> alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
# Rest api colorized methods --> for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do alias "$method"="lwp-request -m '$method'"; done

################################################################################
# Plugins
################################################################################
source "${ZDOTDIR}/.zplugin/bin/zplugin.zsh" || { sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)" && source "${ZDOTDIR}/.zplugin/bin/zplugin.zsh" }
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
ZPLGM[MUTE_WARNINGS]=1
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
zplugin snippet https://iterm2.com/shell_integration/zsh
zplugin ice blockf wait"1" silent
zplugin load zsh-users/zsh-completions
zplugin ice atinit"autoload compinit; mkdir -p $HOME/.cache/zsh; compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION; zpcdreplay" wait"1" silent
zplugin load lukechilds/zsh-better-npm-completion
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
setopt extended_glob auto_cd inc_append_history share_history
test $+commands[npm] -eq 1 && source <(npm completion zsh)
test $+commands[npx] -eq 1 && source <(npx --shell-auto-fallback zsh)
