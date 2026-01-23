################################################################################
# Exports
################################################################################

test -f $HOME/.private && source $HOME/.private

# ENVIRONMENT
test -f /opt/bin/storm\
 && export EDITOR='/opt/bin/storm -e'\
 || export EDITOR='nano'
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
export HOMEBREW_NO_ANALYTICS=1
export ZDOTDIR="$HOME/.config/zsh"

# CACHES
export CACHE="${HOME}/.cache"
export HISTFILE="${CACHE}/history"
export npm_config_cache="${CACHE}/npm"
export ZSHZ_DATA="${CACHE}/zshz"
export LESSHISTFILE=-

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
-add-path "$HOME/.local/bin"
-add-path "/opt/bin"
-add-path "/opt/homebrew/bin"
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
alias edit='storm -e'

# Single letter aliases
alias c='copy'
alias d='docker'
alias e='edit'
alias l='ls -l'
alias t='trash'
alias x='extract'

# all other aliases
alias cl='clear && ls -l'
alias cla='clear && ls -lA'
alias claude='claude --dangerously-skip-permissions'
alias copilot='copilot --model claude-opus-4.5'
alias copyd='copy --delete'
alias dc='docker-compose'
alias ez='edit ~/.zshrc'
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
alias gcm='git checkout main'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull'
alias gmr='git push -o merge_request.create -o merge_request.target=master -o merge_request.merge_when_pipeline_succeeds -o merge_request.remove_source_branch -o merge_request.assign="@David" -o merge_request.title="$(git log -1 --pretty=%B | head -n1)"'
alias gp='git push'
alias grh='git reset HEAD'
alias gss='git status -s'
alias gst='git status'
alias gwip='git commit -vam "wip" && git push'
alias hb='handbrake --preset="Very Fast 1080p30"'
alias la='ls -lA'
alias nxtest='nx affected:test --parallel --maxParallel=5 --only-failed --head=HEAD --base=main'
alias run='npm run --silent'
alias runit='docker run --rm -it'

function fixics {
  curl -s https://gist.githubusercontent.com/festen/3fa31d22747d987282d7717ca8e3910e/raw/329fc2c131f8a3f418abc9785f14a35f9c73acd2/removeInvitees.sh | bash -s -- "$1" "$1.tmp"
  mv "$1.tmp" "$1"
}

function cdp {
  mkdir -p "$1"
  cd "$1"
}

export GGML_METAL_PATH_RESOURCES="$(brew --prefix whisper-cpp)/share/whisper-cpp"
hear() {
  input="$1"
  base="${input%.*}"
  ext="${input##*.}"

  # Check if input is a video format
  case "${ext:l}" in
    mp4|mov|avi|mkv|flv|wmv|webm|m4v|mpg|mpeg|3gp)
      echo "Detected video format, converting to WAV first..."
      temp_wav=$(mktemp).wav
      ffmpeg -i "$input" -vn "$temp_wav"
      process_file="$temp_wav"
      echo "temporary WAV file created at $temp_wav"
      ;;
    *)
      process_file="$input"
      ;;
  esac

  whisper-cli \
    --language nl \
    --print-colors \
    --model $HOME/models/ggml-large-v3-turbo.bin \
    --output-vtt \
    --output-json-full \
    --file "$process_file" \
    --tinydiarize \
    --output-file "$base"

  # Clean up temp file if it was created
  [[ -n "$temp_wav" ]] && rm -f "$temp_wav"
}

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

# GitHub Copilot Suggest - Mimics the old gh copilot suggest using new copilot CLI
# Add this to your ~/.zshrc

# Suggest a shell command using Copilot
# Usage: suggest "your request here"
# Example: suggest "find all files larger than 100MB"
suggest() {
    if [[ -z "$1" ]]; then
        echo "Usage: suggest \"your request\""
        echo "Example: suggest \"find all files larger than 100MB\""
        return 1
    fi

    local query="$*"
    local prompt="You are a shell command suggestion assistant. The user needs a command for: ${query}

IMPORTANT: Respond with ONLY the shell command, nothing else. No explanation, no markdown formatting, no code blocks, just the raw command that can be executed directly.

Context:
- Shell: zsh
- OS: $(uname -s)
- Current directory: $(pwd)"

    echo "Thinking..."
    local cmd
    cmd=$(copilot -p "$prompt" 2>/dev/null)

    if [[ -z "$cmd" ]]; then
        echo "Error: Could not get suggestion from Copilot"
        return 1
    fi

    # Clean up the command (remove any accidental markdown or whitespace)
    cmd=$(echo "$cmd" | sed 's/^```[a-z]*//; s/```$//; s/^[[:space:]]*//; s/[[:space:]]*$//' | head -1)

    echo ""
    echo "Suggested command:"
    echo "  \033[1;32m$cmd\033[0m"
    echo ""

    # Ask user what to do
    echo -n "Execute? [y]es / [n]o / [c]opy / [e]dit: "
    read -r choice

    case "$choice" in
        y|Y|yes|Yes)
            echo "Executing..."
            eval "$cmd"
            # Add to history
            print -s "$cmd"
            ;;
        c|C|copy|Copy)
            echo -n "$cmd" | pbcopy
            echo "Copied to clipboard!"
            ;;
        e|E|edit|Edit)
            # Pre-fill the command line for editing
            print -z "$cmd"
            ;;
        *)
            echo "Cancelled."
            ;;
    esac
}

# Shorter alias
alias cs='suggest'

# Explain a command using Copilot
# Usage: explain "command to explain"
explain() {
    if [[ -z "$1" ]]; then
        echo "Usage: explain \"command to explain\""
        echo "Example: explain \"tar -xzvf archive.tar.gz\""
        return 1
    fi

    local cmd="$*"
    local prompt="Explain this shell command in simple terms: ${cmd}

Be concise but thorough. Break down each part of the command."

    copilot -p "$prompt"
}

# Shorter alias
alias ce='explain'

return 0 # avoids running anything that is auto added below

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/david/.lmstudio/bin"
# End of LM Studio CLI section

