#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "Setting up dotfiles..."

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

backup_path() {
    local dest="$1"
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"

    while [ -e "$backup" ] || [ -L "$backup" ]; do
        backup="${backup}.$RANDOM"
    done

    echo "Backing up existing: $dest -> $backup"
    mv "$dest" "$backup"
}

# Helper function to create symlink
link_file() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            echo "Already linked: $dest"
            return
        fi
        backup_path "$dest"
    fi

    echo "Linking: $src -> $dest"
    ln -s "$src" "$dest"
}

# Helper function to copy a file
copy_file() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
            echo "Already copied: $dest"
            return
        fi

        if [ -L "$dest" ]; then
            echo "Removing existing symlink: $dest"
            rm "$dest"
        else
            backup_path "$dest"
        fi
    fi

    echo "Copying: $src -> $dest"
    cp "$src" "$dest"
}

# Helper function to copy a directory
copy_dir() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            echo "Removing existing symlink: $dest"
            rm "$dest"
        elif diff -qr "$src" "$dest" >/dev/null; then
            echo "Already copied: $dest"
            return
        else
            backup_path "$dest"
        fi
    fi

    echo "Copying: $src -> $dest"
    cp -R "$src" "$dest"
}

# nvim
link_file "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

# zed
copy_file "$DOTFILES_DIR/zed/keymap.json" "$CONFIG_DIR/zed/keymap.json"
copy_file "$DOTFILES_DIR/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
copy_file "$DOTFILES_DIR/zed/tasks.json" "$CONFIG_DIR/zed/tasks.json"
copy_dir "$DOTFILES_DIR/zed/themes" "$CONFIG_DIR/zed/themes"

case "$(uname -s)" in
    Darwin)
        zed_data_dir="${ZED_USER_DATA_DIR:-$HOME/Library/Application Support/Zed}"
        ;;
    Linux)
        zed_data_dir="${ZED_USER_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zed}"
        ;;
    *)
        zed_data_dir=""
        ;;
esac

if [ -n "$zed_data_dir" ] && [ -d "$DOTFILES_DIR/zed/extensions" ]; then
    for ext_dir in "$DOTFILES_DIR"/zed/extensions/*; do
        [ -d "$ext_dir" ] || continue
        copy_dir "$ext_dir" "$zed_data_dir/extensions/installed/$(basename "$ext_dir")"
    done
fi

# ghostty
link_file "$DOTFILES_DIR/ghostty/config.ghostty" "$CONFIG_DIR/ghostty/config.ghostty"
link_file "$DOTFILES_DIR/ghostty/themes" "$CONFIG_DIR/ghostty/themes"

if [ "$(uname -s)" = "Darwin" ]; then
    ghostty_macos_dir="$HOME/Library/Application Support/com.mitchellh.ghostty"
    link_file "$DOTFILES_DIR/ghostty/config.ghostty" "$ghostty_macos_dir/config.ghostty"
fi

# tmux
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# vim
copy_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

echo "Done!"
