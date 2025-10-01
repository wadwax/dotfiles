#!/usr/bin/env bash

# Linux package installation script
# This script installs common development tools and utilities for Linux

set -e

echo "Installing common development tools for Linux..."

# Detect package manager
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt-get"
    INSTALL_CMD="sudo apt-get install -y"
    UPDATE_CMD="sudo apt-get update"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    UPDATE_CMD="sudo dnf check-update || true"
elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
    INSTALL_CMD="sudo yum install -y"
    UPDATE_CMD="sudo yum check-update || true"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    UPDATE_CMD="sudo pacman -Sy"
else
    echo "No supported package manager found. Please install packages manually."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"
echo "Updating package lists..."
$UPDATE_CMD

# Core utilities
echo "Installing core utilities..."
$INSTALL_CMD \
    curl \
    wget \
    git \
    zsh \
    ripgrep \
    tree \
    htop \
    unzip \
    build-essential 2>/dev/null || $INSTALL_CMD curl wget git zsh ripgrep tree htop unzip

# Install tmux 3.3+ from source (required for allow-passthrough for image.nvim)
echo "Checking tmux version..."
TMUX_VERSION=$(tmux -V 2>/dev/null | grep -oP '\d+\.\d+' | head -1 || echo "0.0")
REQUIRED_VERSION="3.3"

if awk "BEGIN {exit !($TMUX_VERSION < $REQUIRED_VERSION)}"; then
    echo "Current tmux version $TMUX_VERSION is too old. Building tmux 3.4 from source..."

    # Install build dependencies
    if [ "$PKG_MANAGER" = "apt-get" ]; then
        $INSTALL_CMD libevent-dev ncurses-dev bison pkg-config
    elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
        $INSTALL_CMD libevent-devel ncurses-devel bison
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        $INSTALL_CMD libevent ncurses bison
    fi

    # Build and install tmux 3.4
    cd /tmp
    wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
    tar -xzf tmux-3.4.tar.gz
    cd tmux-3.4
    ./configure
    make
    sudo make install
    cd ~
    rm -rf /tmp/tmux-3.4 /tmp/tmux-3.4.tar.gz

    echo "tmux 3.4 installed successfully"
else
    echo "tmux $TMUX_VERSION is already installed and meets requirements"
fi

# Install Lua 5.1 and luarocks (required for image.nvim)
echo "Installing Lua 5.1 and luarocks for image.nvim..."
if [ "$PKG_MANAGER" = "apt-get" ]; then
    $INSTALL_CMD lua5.1 liblua5.1-0-dev luarocks
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD lua lua-devel luarocks
elif [ "$PKG_MANAGER" = "yum" ]; then
    $INSTALL_CMD lua lua-devel luarocks
elif [ "$PKG_MANAGER" = "pacman" ]; then
    $INSTALL_CMD lua51 luarocks
fi

# Install ImageMagick (required for image.nvim)
echo "Installing ImageMagick for Neovim image support..."
if [ "$PKG_MANAGER" = "apt-get" ]; then
    $INSTALL_CMD imagemagick libmagickwand-dev
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD ImageMagick ImageMagick-devel
elif [ "$PKG_MANAGER" = "yum" ]; then
    $INSTALL_CMD ImageMagick ImageMagick-devel
elif [ "$PKG_MANAGER" = "pacman" ]; then
    $INSTALL_CMD imagemagick
fi

# Install magick luarock for image.nvim
echo "Installing magick luarock..."
sudo luarocks install magick

# Install Node.js and npm (required for LSP servers)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js and npm..."
    if [ "$PKG_MANAGER" = "apt-get" ]; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        $INSTALL_CMD nodejs
    elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        $INSTALL_CMD nodejs
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        $INSTALL_CMD nodejs npm
    fi
else
    echo "Node.js $(node --version) is already installed"
fi

# Install neovim from PPA (apt-get only)
if [ "$PKG_MANAGER" = "apt-get" ]; then
    echo "Installing neovim from PPA..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt-get update
    sudo apt-get install neovim -y
else
    echo "Installing neovim from default repository..."
    $INSTALL_CMD neovim
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash

    # Add ~/.local/bin to PATH if not already present
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "Adding ~/.local/bin to PATH..."
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
else
    echo "Claude Code is already installed."
fi

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel9k theme if not already installed
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]; then
    echo "Installing powerlevel9k theme..."
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
fi

# Install mise (polyglot runtime manager)
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh

    # Add mise activation to .zshrc if not already present
    if ! grep -q 'mise activate zsh' "$HOME/.zshrc" 2>/dev/null; then
        echo "Adding mise activation to .zshrc..."
        echo '' >> "$HOME/.zshrc"
        echo '# Activate mise' >> "$HOME/.zshrc"
        echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$HOME/.zshrc"
    fi
else
    echo "mise is already installed."
fi

echo "Package installation complete!"
echo "Note: You may need to install additional packages depending on your needs."