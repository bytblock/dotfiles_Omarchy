#!/bin/bash
# Backup current configs to dotfiles repo
# Usage: ./backup.sh

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Backing up configs to $DOTFILES_DIR"

# Hyprland
echo "Backing up Hyprland configs..."
cp ~/.config/hypr/*.conf "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true

# Waybar
echo "Backing up Waybar configs..."
cp ~/.config/waybar/config.jsonc ~/.config/waybar/style.css "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true

# Alacritty
echo "Backing up Alacritty config..."
cp ~/.config/alacritty/alacritty.toml "$DOTFILES_DIR/config/alacritty/" 2>/dev/null || true

# Starship
echo "Backing up Starship config..."
cp ~/.config/starship.toml "$DOTFILES_DIR/config/" 2>/dev/null || true

# Home files
echo "Backing up home directory files..."
cp ~/.bashrc "$DOTFILES_DIR/home/" 2>/dev/null || true
cp ~/.gitconfig "$DOTFILES_DIR/home/" 2>/dev/null || true

# Claude
echo "Backing up Claude configs..."
cp ~/.claude/CLAUDE.md "$DOTFILES_DIR/claude/" 2>/dev/null || true
cp -r ~/.claude/commands "$DOTFILES_DIR/claude/" 2>/dev/null || true

# Git commit
cd "$DOTFILES_DIR"
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit."
else
    git add -A
    git commit -m "Backup $(date +%Y-%m-%d-%H%M)"
    echo "Changes committed to git."
fi

echo "Backup complete!"
