# Wadwax's dotfiles

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Init

Open Terminal
```bash
git --version
```

Install developer tools

Create ssh for git
```bash
ssh-keygen -t rsa -b 4096 -C "hekohki@gmail.com"
```

Copy the ssha to your clipboard from `~/.ssh/id_rsa.pub`

Log in to GitHub and paste the public key in SSH keys setting page

### Using Git and the bootstrap script

```bash
cd ~
git clone https://github.com/wadwax/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
./bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
./bootstrap.sh -f
```
### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
sudo ./macos.sh
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
sudo ./brew.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`. If you don’t plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

### Change iTerm2 Profile

```bash
open .
```

You will find wadwax iterm profile, open up iterm and click preference, and then replace the current profile
