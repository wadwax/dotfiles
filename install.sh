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

# Function to use stow for symlinking
stow_package() {
    local package=$1
    local dotfiles_dir=$(pwd)

    echo "  Stowing $package..."
    stow -d "$dotfiles_dir" -t "$HOME" --restow "$package" 2>&1 | grep -v "BUG in find_stowed_path" || true
    echo "  ✓ $package symlinked"
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

# Check if stow is installed, try to install if not
if ! command -v stow &> /dev/null; then
    echo "stow is not installed. Attempting to install..."
    if command -v brew &> /dev/null; then
        brew install stow
        echo "  ✓ stow installed via Homebrew"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stow
        echo "  ✓ stow installed via apt-get"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y stow
        echo "  ✓ stow installed via dnf"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow
        echo "  ✓ stow installed via pacman"
    else
        echo "Error: Could not install stow automatically."
        echo "Please install stow manually and run this script again:"
        echo "  macOS: brew install stow"
        echo "  Linux: sudo apt-get install stow (or equivalent for your distro)"
        exit 1
    fi
fi
echo ""

# Install common dotfiles
echo "Installing common dotfiles..."
DOTFILES_DIR="$(pwd)"

stow_package "common"

# Reload tmux config if running
if command -v tmux &> /dev/null; then
    if tmux info &> /dev/null; then
        # Tmux is running, reload config
        tmux source-file "$HOME/.tmux.conf"
        echo "  Reloaded tmux configuration"
    fi
fi

echo ""

# Install OS-specific dotfiles
if [[ "$OS" == "linux" ]]; then
    echo "Installing Linux-specific dotfiles..."

    stow_package "linux"

    echo "Installing common packages..."
    bash "$DOTFILES_DIR/common/install-packages.sh"
    echo ""
    echo "Installing Linux-specific packages..."
    bash "$DOTFILES_DIR/linux/brew.sh"

elif [[ "$OS" == "macos" ]]; then
    echo "Installing macOS-specific dotfiles..."

    stow_package "macos"

    echo ""
    echo "Would you like to install packages? (y/n)"
    read -r install_packages

    if [[ "$install_packages" =~ ^[Yy]$ ]]; then
        echo "Installing common packages..."
        bash "$DOTFILES_DIR/common/install-packages.sh"
        echo ""
        echo "Installing macOS-specific packages and GUI applications..."
        bash "$DOTFILES_DIR/macos/brew.sh"
    else
        echo "Skipping package installation."
        echo "You can run it later with:"
        echo "  bash $DOTFILES_DIR/common/install-packages.sh"
        echo "  bash $DOTFILES_DIR/macos/brew.sh"
    fi

    echo ""
    echo "Would you like to set macOS defaults? (y/n)"
    read -r set_defaults

    if [[ "$set_defaults" =~ ^[Yy]$ ]]; then
        echo "Setting macOS defaults..."
        sudo bash "$DOTFILES_DIR/macos/macos.sh"
    else
        echo "Skipping macOS defaults."
        echo "You can run it later with: sudo bash $DOTFILES_DIR/macos/macos.sh"
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
