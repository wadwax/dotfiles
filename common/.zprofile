# Load OS-specific configuration
[ -f ~/.zprofile.local ] && source ~/.zprofile.local

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$HOME/.nodebrew/current/bin:$PATH

# NVIM aliases
alias vim="nvim"
alias vi="nvim"
alias oldvim="\vim"

# Load API keys from local file (not tracked in git)
[ -f ~/.api_keys ] && source ~/.api_keys
