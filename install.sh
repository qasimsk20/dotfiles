#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Vanilla Arch Dotfiles Installer ==="
echo "Installing basic app configs"
echo

# Check for AUR helper
AUR_HELPER=""
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "Warning: No AUR helper found"
fi

# Install packages
echo "==> Installing official packages..."
sudo pacman -S --needed - < "$DOTFILES_DIR/packages/pacman.list"

if [[ -n "$AUR_HELPER" ]]; then
    echo "==> Installing AUR packages..."
    $AUR_HELPER -S --needed - < "$DOTFILES_DIR/packages/aur.list"
fi

# Backup existing configs
echo "==> Backing up existing configs..."
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for dir in nvim nushell ghostty mpd mpd-discord-rpc atuin fastfetch git tmux; do
    if [[ -d "$HOME/.config/$dir" ]]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

for file in starship.toml; do
    if [[ -f "$HOME/.config/$file" ]]; then
        cp "$HOME/.config/$file" "$BACKUP_DIR/"
    fi
done

# Install configurations
echo "==> Installing configurations..."

if command -v stow &> /dev/null; then
    cd "$DOTFILES_DIR"
    stow .config/ -t "$HOME"
    stow .local/ -t "$HOME"
else
    echo "Copying files directly..."
    cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"
    mkdir -p "$HOME/.local/bin"
    cp -r "$DOTFILES_DIR/.local/bin/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*
fi

echo
echo "==> Installation complete!"
echo "Backup: $BACKUP_DIR"
echo "Restart your terminal or reload shell"
