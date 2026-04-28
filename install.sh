#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up symlinks for dotfiles..."

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

# nvim
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# tmux
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# vim
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

echo "Done!"
