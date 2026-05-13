#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles..."

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Helper function to create symlink
link_file() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            echo "Already linked: $dest"
            return
        fi
        echo "Backing up existing: $dest -> ${dest}.backup"
        mv "$dest" "${dest}.backup"
    fi
    
    echo "Linking: $src -> $dest"
    ln -s "$src" "$dest"
}

# Helper function to copy a file
copy_file() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
            echo "Already copied: $dest"
            return
        fi

        if [ -L "$dest" ]; then
            echo "Removing existing symlink: $dest"
            rm "$dest"
        else
            local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
            echo "Backing up existing: $dest -> $backup"
            mv "$dest" "$backup"
        fi
    fi
    
    echo "Copying: $src -> $dest"
    cp "$src" "$dest"
}

# nvim
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# zed
mkdir -p "$HOME/.config/zed"
copy_file "$DOTFILES_DIR/zed/keymap.json" "$HOME/.config/zed/keymap.json"
copy_file "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
copy_file "$DOTFILES_DIR/zed/tasks.json" "$HOME/.config/zed/tasks.json"

# tmux
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# vim
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

echo "Done!"
