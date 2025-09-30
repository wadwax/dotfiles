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

# Function to backup existing files
backup_file() {
    local file=$1
    if [ -e "$file" ] || [ -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "  Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}

# Function to create symlink with backup
safe_symlink() {
    local source=$1
    local target=$2

    backup_file "$target"
    ln -sf "$source" "$target"
    echo "  Linked: $target -> $source"
}

# Pull latest changes
echo "Pulling latest changes from git..."
git pull origin main 2>/dev/null || echo "  (Skipping git pull - not in a git repo or no remote)"
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

safe_symlink "$COMMON_DIR/.gitconfig" "$HOME/.gitconfig"
safe_symlink "$COMMON_DIR/.gitignore" "$HOME/.gitignore"
safe_symlink "$COMMON_DIR/.hushlogin" "$HOME/.hushlogin"
safe_symlink "$COMMON_DIR/.inputrc" "$HOME/.inputrc"
safe_symlink "$COMMON_DIR/.screenrc" "$HOME/.screenrc"
safe_symlink "$COMMON_DIR/.tmux.conf" "$HOME/.tmux.conf"
safe_symlink "$COMMON_DIR/.ssh/config" "$HOME/.ssh/config"

echo ""

# Install OS-specific dotfiles
if [[ "$OS" == "linux" ]]; then
    echo "Installing Linux-specific dotfiles..."
    LINUX_DIR="$DOTFILES_DIR/linux"

    safe_symlink "$LINUX_DIR/.zshrc" "$HOME/.zshrc"

    echo ""
    echo "Would you like to install Linux packages? (y/n)"
    read -r install_packages

    if [[ "$install_packages" =~ ^[Yy]$ ]]; then
        echo "Installing Linux packages..."
        bash "$LINUX_DIR/install-packages.sh"
    else
        echo "Skipping package installation."
        echo "You can run it later with: bash $LINUX_DIR/install-packages.sh"
    fi

elif [[ "$OS" == "macos" ]]; then
    echo "Installing macOS-specific dotfiles..."
    MACOS_DIR="$DOTFILES_DIR/macos"

    safe_symlink "$COMMON_DIR/.zshrc" "$HOME/.zshrc"
    safe_symlink "$MACOS_DIR/.tmux.conf.osx" "$HOME/.tmux.conf.osx"

    echo ""
    echo "Would you like to install Homebrew packages? (y/n)"
    read -r install_packages

    if [[ "$install_packages" =~ ^[Yy]$ ]]; then
        echo "Installing Homebrew packages..."
        bash "$MACOS_DIR/brew.sh"
    else
        echo "Skipping Homebrew installation."
        echo "You can run it later with: bash $MACOS_DIR/brew.sh"
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