#!/bin/bash
# Restore dotfiles from backup
# Usage: ./restore.sh [--dry-run]

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=""

if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="echo [DRY-RUN] "
    echo "=== DRY RUN MODE - No changes will be made ==="
fi

echo "Restoring dotfiles from $DOTFILES_DIR"

# Hyprland configs
echo "Restoring Hyprland configs..."
for f in "$DOTFILES_DIR"/config/hypr/*.conf; do
    [ -f "$f" ] && $DRY_RUN cp "$f" ~/.config/hypr/
done

# Waybar
if [ -d "$DOTFILES_DIR/config/waybar" ]; then
    echo "Restoring Waybar configs..."
    $DRY_RUN cp "$DOTFILES_DIR"/config/waybar/* ~/.config/waybar/ 2>/dev/null || true
fi

# Alacritty
if [ -f "$DOTFILES_DIR/config/alacritty/alacritty.toml" ]; then
    echo "Restoring Alacritty config..."
    $DRY_RUN cp "$DOTFILES_DIR/config/alacritty/alacritty.toml" ~/.config/alacritty/
fi

# Starship
if [ -f "$DOTFILES_DIR/config/starship.toml" ]; then
    echo "Restoring Starship config..."
    $DRY_RUN cp "$DOTFILES_DIR/config/starship.toml" ~/.config/
fi

# Home directory files
if [ -f "$DOTFILES_DIR/home/.bashrc" ]; then
    echo "Restoring .bashrc..."
    $DRY_RUN cp "$DOTFILES_DIR/home/.bashrc" ~/
fi

if [ -f "$DOTFILES_DIR/home/.gitconfig" ]; then
    echo "Restoring .gitconfig..."
    $DRY_RUN cp "$DOTFILES_DIR/home/.gitconfig" ~/
fi

# Claude configs
if [ -d "$DOTFILES_DIR/claude" ]; then
    echo "Restoring Claude configs..."
    $DRY_RUN cp "$DOTFILES_DIR/claude/CLAUDE.md" ~/.claude/ 2>/dev/null || true
    $DRY_RUN cp -r "$DOTFILES_DIR/claude/commands" ~/.claude/ 2>/dev/null || true
fi

echo "Done! Run 'hyprctl reload' to apply Hyprland changes."
