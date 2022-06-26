# @zdrazil dotfiles

These are dotfiles that I use every day. They're managed with [yadm](https://yadm.io/), a dotfile manager.

## Install

These commands will install dotfiles to your home directory and they will also run a [boostrap script](../.config/yadm/bootstrap).

For dotfiles, if a file already exists locally and has content that differs from the one in this repository, the local file will be left unmodified, and you’ll have to review and resolve the differences.

This does not apply for the bootstrap script. Please read through it to understand what it does.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install yadm
yadm clone https://github.com/zdrazil/system-bootstrap.git
```

## Setup git

Use instructions from [GitHub guide](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) to setup SSH keys or use the quick setup in next section.

### Quick setup

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"

# Mac
ssh-add -K ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub

# Linux
ssh-add ~/.ssh/id_ed25519
xclip -selection clipboard < ~/.ssh/id_ed25519.pub

# Windows
clip < ~/.ssh/id_ed25519.pub
```
