eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$HOME/.nodebrew/current/bin:$PATH

# NVIM aliases
alias vim="nvim"
alias vi="nvim"
alias oldvim="\vim"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
# Load API keys from local file (not tracked in git)
[ -f ~/.api_keys ] && source ~/.api_keys
