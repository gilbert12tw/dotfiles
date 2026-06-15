# gilbert12tw's Dotfiles

These are my personal dotfiles for easily setting up my environment on a new machine.

## Contents

- **Neovim** (`nvim/`) - Configuration for Neovim (init.lua, lazy plugin manager, etc.)
- **Ghostty** (`ghostty/`) - Ghostty terminal config and bundled themes
- **Zed** (`zed/`) - Zed editor settings, keymap, tasks, custom themes, and required icon theme extension
- **Tmux** (`tmux/.tmux.conf`) - Tmux multiplexer configuration
- **Vim** (`vim/.vimrc`) - Classic Vim configuration

## Installation

You can set up everything instantly on a new machine by running the installation script. It will automatically install the configuration files to their appropriate locations in your home directory (`~`). Existing files will be backed up with a `.backup.YYYYMMDDHHMMSS` suffix.

```bash
git clone https://github.com/gilbert12tw/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### What the script does

* Symlinks `nvim/` to `~/.config/nvim`
* Symlinks `ghostty/config.ghostty` to `~/.config/ghostty/config.ghostty`
* Symlinks `ghostty/themes/` to `~/.config/ghostty/themes`
* On macOS, also symlinks `ghostty/config.ghostty` to `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
* Copies `zed/keymap.json` to `~/.config/zed/keymap.json`
* Copies `zed/settings.json` to `~/.config/zed/settings.json`
* Copies `zed/tasks.json` to `~/.config/zed/tasks.json`
* Symlinks `zed/themes/` to `~/.config/zed/themes`
* Symlinks bundled Zed extensions, currently `catppuccin-icons`, into Zed's user data directory
* Symlinks `tmux/.tmux.conf` to `~/.tmux.conf`
* Symlinks `vim/.vimrc` to `~/.vimrc`

## Requirements

Ensure you have the corresponding software installed before or after setting up the dotfiles:

* [Neovim](https://neovim.io/)
* [Ghostty](https://ghostty.org/)
* [Zed](https://zed.dev/)
* [Tmux](https://github.com/tmux/tmux/wiki)
* [Vim](https://www.vim.org/)
