#!/usr/bin/env bash

# Common package installation script for both macOS and Linux
# Uses Homebrew as the unified package manager

set -e

echo "=================================="
echo "Common Package Installation"
echo "=================================="
echo ""

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
echo "Detected OS: $OS"
echo ""

# Install build dependencies for Homebrew on Linux
install_linux_build_deps() {
    if [[ "$OS" != "linux" ]]; then
        return 0
    fi

    echo "Installing build dependencies for Homebrew..."

    # Detect package manager and install build tools
    if command -v apt-get &> /dev/null; then
        echo "  Installing build tools (Debian/Ubuntu)..."
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git
    elif command -v dnf &> /dev/null; then
        echo "  Installing build tools (Fedora/CentOS)..."
        sudo dnf groupinstall -y 'Development Tools'
        sudo dnf install -y procps-ng curl file git
    elif command -v yum &> /dev/null; then
        echo "  Installing build tools (CentOS/RHEL)..."
        sudo yum groupinstall -y 'Development Tools'
        sudo yum install -y procps-ng curl file git
    elif command -v pacman &> /dev/null; then
        echo "  Installing build tools (Arch Linux)..."
        sudo pacman -S --noconfirm base-devel procps-ng curl file git
    else
        echo "  Warning: Could not detect package manager. Please install build tools manually."
        echo "  See: https://docs.brew.sh/Homebrew-on-Linux#requirements"
    fi
    echo ""
}

# Install Homebrew if not already installed
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        echo "✓ Homebrew is already installed"
    else
        # Install build dependencies on Linux first
        if [[ "$OS" == "linux" ]]; then
            install_linux_build_deps
        fi

        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH based on OS
        if [[ "$OS" == "linux" ]]; then
            # Check both possible Linux locations
            if [ -d "$HOME/.linuxbrew" ]; then
                eval "$($HOME/.linuxbrew/bin/brew shellenv)"
            elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fi
        elif [[ "$OS" == "macos" ]]; then
            # For Apple Silicon
            if [[ -d "/opt/homebrew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            # For Intel
            elif [[ -d "/usr/local/Homebrew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        echo "✓ Homebrew installed successfully"
    fi
    echo ""
}

# Install common CLI tools via Homebrew
install_common_tools() {
    echo "Installing common CLI tools..."

    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    echo "  Running: brew bundle --file $script_dir/Brewfile"
    brew bundle --file "$script_dir/Brewfile"
    echo ""
}

# Setup ZSH
setup_zsh() {
    echo "Setting up ZSH..."

    if command -v zsh >/dev/null 2>&1; then
        echo "  ✓ ZSH is already installed"
    else
        echo "  Installing ZSH..."
        brew install zsh
    fi

    # Check if zsh is the default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        local zsh_path=$(which zsh)

        # Add zsh to /etc/shells if not present
        if ! grep -q "$zsh_path" /etc/shells 2>/dev/null; then
            echo "  Adding $zsh_path to /etc/shells..."
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi

        echo "  Setting ZSH as default shell..."
        sudo chsh -s "$zsh_path" "$USER"
        echo ""
        echo "  ⚠️  ZSH has been set as your default shell."
        echo "      Please log out and log back in for this to take effect."
    else
        echo "  ✓ ZSH is already the default shell"
    fi
    echo ""
}

# Install Claude Code
install_claude_code() {
    echo "Installing Claude Code..."

    if command -v claude &> /dev/null; then
        echo "  ✓ Claude Code is already installed"
    else
        echo "  Installing Claude Code..."
        # Download the installer script first
        local installer="/tmp/claude-install-$$.sh"
        if curl -fsSL https://claude.ai/install.sh -o "$installer"; then
            chmod +x "$installer"
            # Try normal install first, if it fails due to lock, wait and retry with --force
            if ! bash "$installer" 2>/dev/null; then
                echo "  First attempt failed, waiting for any existing installation..."
                sleep 5
                # Retry with --force to override lock check
                bash "$installer" --force || {
                    echo "  ⚠️  Claude Code installation failed. You can install manually later with:"
                    echo "     curl -fsSL https://claude.ai/install.sh | sh --force"
                    rm -f "$installer"
                    return 0
                }
            fi
            rm -f "$installer"
            echo "  ✓ Claude Code installed"
        else
            echo "  ⚠️  Failed to download Claude Code installer"
            return 0
        fi
    fi
    echo ""
}

# Install mise (polyglot runtime manager)
install_mise() {
    echo "Installing mise..."

    if command -v mise &> /dev/null; then
        echo "  ✓ mise is already installed"
    else
        echo "  Installing mise..."
        curl https://mise.run | sh
        echo "  ✓ mise installed"
    fi
    echo ""
}

# Main installation flow
main() {
    install_homebrew
    install_common_tools
    setup_zsh
    install_claude_code
    install_mise

    echo "=================================="
    echo "Common package installation complete!"
    echo "=================================="
    echo ""
    echo "Next steps:"
    echo "  1. Run OS-specific package installers:"
    if [[ "$OS" == "linux" ]]; then
        echo "     bash ~/dotfiles/linux/brew.sh"
    elif [[ "$OS" == "macos" ]]; then
        echo "     bash ~/dotfiles/macos/brew.sh"
        echo "     brew bundle --file ~/dotfiles/macos/Brewfile"
    fi
    echo "  2. Restart your terminal or run: exec zsh"
    echo "  3. If ZSH was just set as default, log out and log back in"
    echo ""
}

# Run main installation
main
