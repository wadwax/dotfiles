# Load OS-specific configuration
[ -f ~/.zprofile.local ] && source ~/.zprofile.local

# Homebrew on Linux
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Load API keys from local file (not tracked in git)
[ -f ~/.api_keys ] && source ~/.api_keys
