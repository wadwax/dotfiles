#!/usr/bin/env bash

# macOS-specific CLI tool installation
# Additional CLI tools and utilities specific to macOS

set -e

cd "$(dirname "$0")"

echo "=================================="
echo "macOS-Specific CLI Tools Installation"
echo "=================================="
echo ""

# Ensure Homebrew is available
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please run common/install-packages.sh first."
    exit 1
fi

# Make sure we're using the latest Homebrew
echo "Updating Homebrew..."
brew update
echo ""

# Upgrade any already-installed formulae
echo "Upgrading installed packages..."
brew upgrade
echo ""

# Save Homebrew's installed location
BREW_PREFIX=$(brew --prefix)

echo "Installing macOS-specific CLI tools..."

# Install GNU core utilities (those that come with macOS are outdated)
echo "  Installing GNU core utilities..."
brew install coreutils
ln -sf "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum" 2>/dev/null || true

# Install some other useful utilities like `sponge`
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed

# Install more recent versions of some macOS tools
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install CTF tools (optional, comment out if not needed)
echo "  Installing CTF tools..."
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries
echo "  Installing additional utilities..."
brew install ack
brew install gs
brew install imagemagick
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install vbindiff
brew install zopfli

# Node.js version manager
brew install nodebrew

echo ""
echo "✓ macOS-specific CLI tools installed"
echo ""

# Install GUI applications from Brewfile
echo "=================================="
echo "Installing GUI Applications"
echo "=================================="
echo ""
echo "Running: brew bundle --file $PWD/Brewfile"
brew bundle --file "$PWD/Brewfile"
echo ""

# Remove outdated versions from the cellar
echo "Cleaning up..."
brew cleanup
echo ""

echo "=================================="
echo "macOS installation complete!"
echo "=================================="
echo ""