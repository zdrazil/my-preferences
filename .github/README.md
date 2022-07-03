# @zdrazil dotfiles

These are dotfiles that I use every day. They're managed with [yadm](https://yadm.io/).

## Install

These commands will:

- Install [Homebrew](https://brew.sh/) and [yadm](https://yadm.io/).
- Install dotfiles to your home directory.
- Run a [boostrap script](../.config/yadm/bootstrap).

For dotfiles, if a file already exists locally and has content that differs from the one in this repository, the local file will be left unmodified, and you’ll have to review and resolve the differences.

This does not apply for the [boostrap script](../.config/yadm/bootstrap). Please read through it to understand what it does.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install yadm
yadm clone https://github.com/zdrazil/system-bootstrap.git
```

## Setup git

Use instructions from [GitHub guide](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and in [Proper use of SSH client in Mac OS X](https://www.getpagespeed.com/work/proper-use-of-ssh-client-in-mac-os-x) to setup SSH keys or use the quick setup in next section.

### Quick setup

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
```

#### Mac

Add this to `~/.ssh/config`:

```ssh
Host *
   UseKeychain yes
   AddKeysToAgent yes
   IdentityFile ~/.ssh/id_ed25519
```

```bash
chmod 600 ~/.ssh/config
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
```

#### Linux

```bash
ssh-add ~/.ssh/id_ed25519
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
```

#### Windows

```bash
clip < ~/.ssh/id_ed25519.pub
```
