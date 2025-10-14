#!/usr/bin/env bash

# Linux-specific package installation
# Additional packages and tools specific to Linux

set -e

cd "$(dirname "$0")"

echo "=================================="
echo "Linux-Specific Package Installation"
echo "=================================="
echo ""

# Ensure Homebrew is available
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please run common/install-packages.sh first."
    exit 1
fi

# Detect native package manager
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
    echo "No supported package manager found for native packages."
    PKG_MANAGER="none"
fi

# Install tmux 3.3+ (build from source if needed)
install_tmux() {
    echo "Checking tmux version..."
    TMUX_VERSION=$(tmux -V 2>/dev/null | grep -oP '\d+\.\d+' | head -1 || echo "0.0")
    REQUIRED_VERSION="3.3"

    if awk "BEGIN {exit !($TMUX_VERSION < $REQUIRED_VERSION)}"; then
        echo "  Current tmux version $TMUX_VERSION is too old. Building tmux 3.4 from source..."

        # Install build dependencies
        if [ "$PKG_MANAGER" = "apt-get" ]; then
            $UPDATE_CMD
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

        echo "  ✓ tmux 3.4 installed successfully"
    else
        echo "  ✓ tmux $TMUX_VERSION meets requirements"
    fi
    echo ""
}

# Install Linux-specific utilities
install_linux_utilities() {
    echo "Installing Linux-specific utilities..."

    if [ "$PKG_MANAGER" != "none" ]; then
        $UPDATE_CMD
        $INSTALL_CMD unzip 2>/dev/null || true
        echo "  ✓ Linux utilities installed"
    fi
    echo ""
}

# Main installation flow
main() {
    install_tmux
    install_linux_utilities

    echo "=================================="
    echo "Linux-specific installation complete!"
    echo "=================================="
    echo ""
}

# Run main installation
main
