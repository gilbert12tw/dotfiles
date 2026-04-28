# gilbert12tw's Dotfiles

These are my personal dotfiles for easily setting up my environment on a new machine.

## Contents

- **Neovim** (`nvim/`) - Configuration for Neovim (init.lua, lazy plugin manager, etc.)
- **Tmux** (`tmux/.tmux.conf`) - Tmux multiplexer configuration
- **Vim** (`vim/.vimrc`) - Classic Vim configuration

## Installation

You can set up everything instantly on a new machine by running the installation script. It will automatically symlink the configuration files to their appropriate locations in your home directory (`~`). Existing files will be backed up with a `.backup` extension.

```bash
git clone https://github.com/gilbert12tw/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### What the script does

* Symlinks `nvim/` to `~/.config/nvim`
* Symlinks `tmux/.tmux.conf` to `~/.tmux.conf`
* Symlinks `vim/.vimrc` to `~/.vimrc`

## Requirements

Ensure you have the corresponding software installed before or after setting up the symlinks:

* [Neovim](https://neovim.io/)
* [Tmux](https://github.com/tmux/tmux/wiki)
* [Vim](https://www.vim.org/)
