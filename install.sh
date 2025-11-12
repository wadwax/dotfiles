#!/usr/bin/env bash

# Dotfiles installation script with OS detection
# This script sets up dotfiles for Linux or macOS

set -e

cd "$(dirname "$0")"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

echo "=================================="
echo "Dotfiles Installation Script"
echo "=================================="
echo "Detected OS: $OS"
echo ""

if [[ "$OS" == "unknown" ]]; then
    echo "Error: Unsupported operating system: $OSTYPE"
    exit 1
fi

# Function to create symlink with backup
safe_symlink() {
    local source=$1
    local target=$2

    # Remove existing symlink or file to force relink
    rm -rf "$target"
    ln -sf "$source" "$target"
    echo "  Linked: $target -> $source"
}

# Pull latest changes
echo "Pulling latest changes from git..."
# git pull origin main 2>/dev/null || echo "  (Skipping git pull - not in a git repo or no remote)"
echo ""

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p ~/.ssh
mkdir -p ~/.config
echo ""

# Install common dotfiles
echo "Installing common dotfiles..."
DOTFILES_DIR="$(pwd)"
COMMON_DIR="$DOTFILES_DIR/common"

# Install starship prompt
if ! command -v starship &> /dev/null; then
    echo "Installing starship prompt..."
    if [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew install starship
        else
            curl -sS https://starship.rs/install.sh | sh
        fi
    elif [[ "$OS" == "linux" ]]; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    fi
    echo "  Starship installed"
else
    echo "  Starship already installed"
fi

safe_symlink "$COMMON_DIR/.gitconfig" "$HOME/.gitconfig"
safe_symlink "$COMMON_DIR/.hushlogin" "$HOME/.hushlogin"
safe_symlink "$COMMON_DIR/.inputrc" "$HOME/.inputrc"
safe_symlink "$COMMON_DIR/.screenrc" "$HOME/.screenrc"
safe_symlink "$COMMON_DIR/.tmux.conf" "$HOME/.tmux.conf"
# Reload tmux config
if command -v tmux &> /dev/null; then
    if tmux info &> /dev/null; then
        # Tmux is running, reload config
        tmux source-file "$HOME/.tmux.conf"
        echo "  Reloaded tmux configuration"
    else
        # Start temp session to load config, then kill it
        tmux new-session -d -s temp_config_load && tmux source-file "$HOME/.tmux.conf" && tmux kill-session -t temp_config_load
        echo "  Loaded tmux configuration"
    fi
fi
safe_symlink "$COMMON_DIR/.zshrc" "$HOME/.zshrc"
safe_symlink "$COMMON_DIR/.ssh/config" "$HOME/.ssh/config"
safe_symlink "$COMMON_DIR/.config/nvim" "$HOME/.config/nvim"
safe_symlink "$COMMON_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

echo ""

# Install OS-specific dotfiles
if [[ "$OS" == "linux" ]]; then
    echo "Installing Linux-specific dotfiles..."
    LINUX_DIR="$DOTFILES_DIR/linux"

    safe_symlink "$LINUX_DIR/.zprofile" "$HOME/.zprofile"

    echo "Installing common packages..."
    bash "$COMMON_DIR/install-packages.sh"
    echo ""
    echo "Installing Linux-specific packages..."
    bash "$LINUX_DIR/brew.sh"

elif [[ "$OS" == "macos" ]]; then
    echo "Installing macOS-specific dotfiles..."
    MACOS_DIR="$DOTFILES_DIR/macos"

    safe_symlink "$MACOS_DIR/.zprofile" "$HOME/.zprofile"
    safe_symlink "$MACOS_DIR/.tmux.conf.osx" "$HOME/.tmux.conf.osx"
    safe_symlink "$MACOS_DIR/.config/aerospace" "$HOME/.config/aerospace"

    echo ""
    echo "Would you like to install packages? (y/n)"
    read -r install_packages

    if [[ "$install_packages" =~ ^[Yy]$ ]]; then
        echo "Installing common packages..."
        bash "$COMMON_DIR/install-packages.sh"
        echo ""
        echo "Installing macOS-specific packages and GUI applications..."
        bash "$MACOS_DIR/brew.sh"
    else
        echo "Skipping package installation."
        echo "You can run it later with:"
        echo "  bash $COMMON_DIR/install-packages.sh"
        echo "  bash $MACOS_DIR/brew.sh"
    fi

    echo ""
    echo "Would you like to set macOS defaults? (y/n)"
    read -r set_defaults

    if [[ "$set_defaults" =~ ^[Yy]$ ]]; then
        echo "Setting macOS defaults..."
        sudo bash "$MACOS_DIR/macos.sh"
    else
        echo "Skipping macOS defaults."
        echo "You can run it later with: sudo bash $MACOS_DIR/macos.sh"
    fi
fi

echo ""
echo "=================================="
echo "Installation complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure your SSH keys if needed"
echo "  3. Customize your dotfiles as needed"
echo ""
