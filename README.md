# Wadwax's Dotfiles

Cross-platform dotfiles for Linux and macOS with automatic OS detection.

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

## Features

- **OS Detection**: Automatically detects and configures for Linux or macOS
- **Organized Structure**: Separate configurations for common, Linux-specific, and macOS-specific settings
- **Safe Installation**: Backs up existing dotfiles before creating symlinks
- **Minimal macOS Bloat**: Clean Linux configuration without unnecessary macOS-specific content

## Directory Structure

```
dotfiles/
├── common/           # Shared configurations across all OS
│   ├── .gitconfig
│   ├── .gitignore
│   ├── .hushlogin
│   ├── .inputrc
│   ├── .screenrc
│   ├── .tmux.conf
│   ├── .zshrc       # Common zsh config (used by macOS)
│   └── .ssh/
│       └── config
├── linux/            # Linux-specific configurations
│   ├── .zshrc       # Linux-optimized zsh config
│   └── install-packages.sh
├── macos/            # macOS-specific configurations
│   ├── .tmux.conf.osx
│   ├── Brewfile
│   ├── brew.sh
│   ├── macos.sh
│   └── iterm/
├── install.sh        # Main installation script with OS detection
└── README.md
```

## Installation

### Prerequisites

1. Git must be installed
2. For macOS: Command Line Tools
3. For Linux: Basic development tools

### Quick Install

```bash
cd ~
git clone https://github.com/wadwax/dotfiles.git
cd dotfiles
./install.sh
```

The installation script will:
1. Detect your operating system (Linux or macOS)
2. Create backups of existing dotfiles (with timestamp)
3. Create symlinks to the appropriate configuration files
4. Offer to install OS-specific packages (optional)

### Manual Installation Steps

If you prefer to set up manually:

#### For Linux:

```bash
cd ~/dotfiles

# Install common dotfiles
ln -sf ~/dotfiles/common/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/common/.gitignore ~/.gitignore
ln -sf ~/dotfiles/common/.hushlogin ~/.hushlogin
ln -sf ~/dotfiles/common/.inputrc ~/.inputrc
ln -sf ~/dotfiles/common/.screenrc ~/.screenrc
ln -sf ~/dotfiles/common/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/common/.ssh/config ~/.ssh/config

# Install Linux-specific dotfiles
ln -sf ~/dotfiles/linux/.zshrc ~/.zshrc

# Optional: Install packages
bash ~/dotfiles/linux/install-packages.sh
```

#### For macOS:

```bash
cd ~/dotfiles

# Install common dotfiles (same as Linux)
ln -sf ~/dotfiles/common/.gitconfig ~/.gitconfig
# ... (other common files)

# Install macOS-specific dotfiles
ln -sf ~/dotfiles/common/.zshrc ~/.zshrc
ln -sf ~/dotfiles/macos/.tmux.conf.osx ~/.tmux.conf.osx

# Optional: Install Homebrew packages
bash ~/dotfiles/macos/brew.sh

# Optional: Set macOS defaults
sudo bash ~/dotfiles/macos/macos.sh
```

## Package Installation

### Linux

The Linux package installer supports multiple package managers (apt, dnf, yum, pacman) and installs:

- Core utilities: curl, wget, git, zsh, tmux, neovim
- Development tools: ripgrep, tree, htop, build-essential
- Shell enhancements: oh-my-zsh, powerlevel9k theme

Run separately:
```bash
bash ~/dotfiles/linux/install-packages.sh
```

### macOS

The macOS package installer uses Homebrew to install:

- Development tools and CLI utilities
- GUI applications (Arc, Cursor, iTerm2, etc.)
- Fonts (Fira Code, Hack Nerd Font)
- Terminal utilities (neovim, tmux, zsh enhancements)

See `macos/Brewfile` for the complete list.

Run separately:
```bash
bash ~/dotfiles/macos/brew.sh
```

## Configuration Details

### Common Configurations

These configurations are shared across all operating systems:

- **Git**: Aliases, color schemes, and global settings
- **Tmux**: Terminal multiplexer with custom keybindings (C-a prefix)
- **SSH**: Basic SSH configuration with GitHub setup
- **Input**: Readline configuration for better CLI input handling
- **Screen**: Screen configuration for terminal management

### Linux-Specific

- **Zsh**: Cleaned up version without macOS-specific aliases (pbcopy, Finder, etc.)
- Package manager support for apt, dnf, yum, and pacman

### macOS-Specific

- **Zsh**: Full-featured with macOS aliases and utilities
- **Homebrew**: Comprehensive package list via Brewfile
- **System defaults**: macOS system preferences automation
- **iTerm2**: Terminal emulator profiles

## Customization

### SSH Keys

After installation, set up your SSH keys:

```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
cat ~/.ssh/id_rsa.pub
```

Copy the public key to GitHub/GitLab/etc.

### Git Configuration

Update your Git user information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Zsh Theme

The dotfiles use powerlevel9k theme by default. To customize:

1. Edit `~/.zshrc` (or the source in `linux/.zshrc` / `common/.zshrc`)
2. Modify the `POWERLEVEL9K_*` variables
3. Reload: `source ~/.zshrc`

### Adding Your Own Configurations

1. Fork this repository
2. Add your configurations to the appropriate directory (common/linux/macos)
3. Update `install.sh` if you add new files to symlink
4. Test the installation script
5. Commit and push your changes

## Updating

To update your dotfiles to the latest version:

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

The installation script will backup existing files before overwriting.

## Uninstallation

To remove symlinks and restore backups:

```bash
cd ~
# Remove symlinks
rm .gitconfig .gitignore .hushlogin .inputrc .screenrc .tmux.conf .zshrc
rm .ssh/config  # or manually edit if you have other configs

# Restore from backups (if desired)
# Look for files with .backup.YYYYMMDD_HHMMSS extensions
```

## Shell Configuration

### Zsh Plugins

Currently using basic oh-my-zsh with:
- Git plugin
- Powerlevel9k theme

To add more plugins, edit the `plugins=()` array in your `.zshrc`.

### Aliases

Common aliases included:

- Navigation: `..`, `...`, `....`, `.....`
- Git: `g` (git shorthand)
- Tmux: `ta` (attach), `tks` (kill-server), `tls` (list sessions)
- Neovim: `vim`, `vi` (both point to nvim)

See the full list in `linux/.zshrc` or `common/.zshrc`.

## Troubleshooting

### Symlinks Not Working

If symlinks aren't being created:
1. Check file permissions: `ls -la ~/dotfiles`
2. Ensure the install script is executable: `chmod +x install.sh`
3. Run with bash explicitly: `bash install.sh`

### Oh-My-Zsh Theme Not Loading

If powerlevel9k isn't working:
1. Check if oh-my-zsh is installed: `ls -la ~/.oh-my-zsh`
2. Check if theme is installed: `ls -la ~/.oh-my-zsh/custom/themes/powerlevel9k`
3. Install manually: `git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k`

### Package Installation Fails

For Linux:
- Ensure your package manager is up to date
- You may need sudo privileges
- Check internet connectivity

For macOS:
- Install Homebrew first: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Ensure Xcode Command Line Tools are installed

## Warning

**Important**: If you want to use these dotfiles, you should:
1. Fork this repository
2. Review the code and configurations
3. Remove things you don't want or need
4. Customize to your preferences

Don't blindly use these settings unless you understand what they do!

## Credits

Originally forked and customized from various dotfiles repositories. Special thanks to the open-source community for inspiration and tools.

## iTerm2 Setup (macOS)

After running the install script, iTerm2 users should import the provided configurations:

### Import Color Scheme

1. Open iTerm2 → Preferences (⌘,)
2. Go to Profiles → Colors
3. Click "Color Presets..." dropdown → "Import..."
4. Navigate to `~/dotfiles/iterm/catppuccin-mocha.itermcolors`
5. Select the imported "Catppuccin Mocha" from the Color Presets dropdown

### Import Profile

1. Open iTerm2 → Preferences (⌘,)
2. Go to Profiles
3. Click the "Other Actions..." dropdown (bottom left) → "Import JSON Profiles..."
4. Navigate to `~/dotfiles/iterm/profile.json`
5. Select and import the profile

### Import Key Mappings

1. Open iTerm2 → Preferences (⌘,)
2. Go to Profiles → Keys → Key Mappings
3. Click "Presets..." dropdown → "Import..."
4. Navigate to `~/dotfiles/iterm/iterm.itermkeymap`
5. Load the key mappings

## License

MIT License - See LICENSE-MIT.txt for details.