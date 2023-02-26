# PRIVATE
export PRIVATE="$HOME/.private"
test -f "$PRIVATE" && source "$PRIVATE"

# CACHES
export CACHE="${HOME}/.cache"
export HISTFILE="${CACHE}/history"
export npm_config_cache="${CACHE}/npm"
export ZSHZ_DATA="${CACHE}/zshz"
export LESSHISTFILE=-

# CONFIGS
export CONFIG="${HOME}/.config"
export NVM_DIR="${CONFIG}/nvm"
export HOMEBREW_BUNDLE_FILE="${HOME}/scripts/Brewfile"
export HISTSIZE=100000 # 100k
export SAVEHIST=100000
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
export HISTORY_SUBSTRING_SEARCH_FUZZY=true
