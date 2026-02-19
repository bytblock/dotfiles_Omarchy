#!/bin/bash
# Backup current configs to dotfiles repo
# Usage: ./backup.sh
# Repo: github.com/bytblock/dotfiles_Omarchy
#
# SAFE TO EDIT: ~/.config/ (user configs)
# DO NOT TOUCH: ~/.local/share/omarchy (Omarchy system files)

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Backing up configs to $DOTFILES_DIR"

# ── Hyprland ──────────────────────────────────────────────────────────────────
echo "Backing up Hyprland configs..."
cp ~/.config/hypr/*.conf "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
# Subdirs
cp ~/.config/hypr/rules/*.conf "$DOTFILES_DIR/config/hypr/rules/" 2>/dev/null || true
cp ~/.config/hypr/scripts/*.sh "$DOTFILES_DIR/config/hypr/scripts/" 2>/dev/null || true
# Note: ~/.config/hypr/shaders/ contains only symlinks to /usr/share/aether - skip

# ── Waybar ────────────────────────────────────────────────────────────────────
echo "Backing up Waybar configs..."
cp ~/.config/waybar/config.jsonc "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/style.css "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/config-enhanced.jsonc "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/style-subtle.css "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/style-enhanced.css "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/style-enhanced-compatible.css "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
cp ~/.config/waybar/scripts/*.sh "$DOTFILES_DIR/config/waybar/scripts/" 2>/dev/null || true

# ── Alacritty ─────────────────────────────────────────────────────────────────
echo "Backing up Alacritty config..."
cp ~/.config/alacritty/alacritty.toml "$DOTFILES_DIR/config/alacritty/" 2>/dev/null || true

# ── Mako (notifications) ──────────────────────────────────────────────────────
echo "Backing up Mako config..."
cp ~/.config/mako/config "$DOTFILES_DIR/config/mako/" 2>/dev/null || true

# ── Walker (launcher) ─────────────────────────────────────────────────────────
echo "Backing up Walker config..."
cp ~/.config/walker/config.toml "$DOTFILES_DIR/config/walker/" 2>/dev/null || true
# Walker themes (CSS only, no images)
find ~/.config/walker/themes/ -name "*.css" -exec cp {} "$DOTFILES_DIR/config/walker/themes/" \; 2>/dev/null || true

# ── Starship (prompt) ─────────────────────────────────────────────────────────
echo "Backing up Starship config..."
cp ~/.config/starship.toml "$DOTFILES_DIR/config/starship.toml" 2>/dev/null || true

# ── Omarchy custom themes ─────────────────────────────────────────────────────
# Only the text/config files - backgrounds excluded by .gitignore (large images)
echo "Backing up Omarchy custom themes (configs only, not backgrounds)..."
for theme in aetheria gold-rush temerald; do
    THEME_SRC="$HOME/.config/omarchy/themes/$theme"
    THEME_DST="$DOTFILES_DIR/config/omarchy/themes/$theme"
    if [ -d "$THEME_SRC" ]; then
        mkdir -p "$THEME_DST"
        # Copy all non-image, non-.git files (these themes have their own .git dirs)
        find "$THEME_SRC" -type f \
            ! -path "*/.git/*" \
            ! -name "*.jpg" ! -name "*.jpeg" ! -name "*.png" \
            ! -name "*.gif" ! -name "*.webp" ! -name "*.bmp" \
            | while read -r f; do
                REL="${f#$THEME_SRC/}"
                DEST_DIR="$THEME_DST/$(dirname "$REL")"
                mkdir -p "$DEST_DIR"
                cp "$f" "$DEST_DIR/"
            done 2>/dev/null || true
        # Remove any .git dirs that may have been created by mkdir -p above
        rm -rf "$THEME_DST/.git"
    fi
done

# Omarchy hooks (sample configs)
cp ~/.config/omarchy/hooks/*.sample "$DOTFILES_DIR/config/omarchy/hooks/" 2>/dev/null || true

# ── Neovim ────────────────────────────────────────────────────────────────────
echo "Backing up Neovim config..."
cp ~/.config/nvim/init.lua ~/.config/nvim/lazyvim.json ~/.config/nvim/lazy-lock.json \
   ~/.config/nvim/stylua.toml "$DOTFILES_DIR/config/nvim/" 2>/dev/null || true
# Lua config files
find ~/.config/nvim/lua/ -type f -name "*.lua" | while read -r f; do
    REL="${f#$HOME/.config/nvim/}"
    DEST_DIR="$DOTFILES_DIR/config/nvim/$(dirname "$REL")"
    mkdir -p "$DEST_DIR"
    cp "$f" "$DEST_DIR/"
done 2>/dev/null || true
# Plugin specs
find ~/.config/nvim/plugin/ -type f | while read -r f; do
    REL="${f#$HOME/.config/nvim/}"
    DEST_DIR="$DOTFILES_DIR/config/nvim/$(dirname "$REL")"
    mkdir -p "$DEST_DIR"
    cp "$f" "$DEST_DIR/"
done 2>/dev/null || true

# ── Fish shell ────────────────────────────────────────────────────────────────
echo "Backing up Fish config..."
find ~/.config/fish/ -type f -name "*.fish" | while read -r f; do
    REL="${f#$HOME/.config/fish/}"
    DEST_DIR="$DOTFILES_DIR/config/fish/$(dirname "$REL")"
    mkdir -p "$DEST_DIR"
    cp "$f" "$DEST_DIR/"
done 2>/dev/null || true

# ── Lazygit ───────────────────────────────────────────────────────────────────
echo "Backing up Lazygit config..."
cp ~/.config/lazygit/config.yml "$DOTFILES_DIR/config/lazygit/" 2>/dev/null || true

# ── Btop ──────────────────────────────────────────────────────────────────────
echo "Backing up Btop config..."
find ~/.config/btop/ -type f | while read -r f; do
    REL="${f#$HOME/.config/btop/}"
    DEST_DIR="$DOTFILES_DIR/config/btop/$(dirname "$REL")"
    mkdir -p "$DEST_DIR"
    cp "$f" "$DEST_DIR/"
done 2>/dev/null || true

# ── Fastfetch ─────────────────────────────────────────────────────────────────
echo "Backing up Fastfetch config..."
find ~/.config/fastfetch/ -type f | while read -r f; do
    cp "$f" "$DOTFILES_DIR/config/fastfetch/"
done 2>/dev/null || true

# ── Omarchy Webapps ───────────────────────────────────────────────────────────
echo "Backing up Omarchy webapps..."
mkdir -p "$DOTFILES_DIR/config/applications/icons"
# Only backup omarchy-launch-webapp desktop files (not system-generated ones)
grep -rl "omarchy-launch-webapp" ~/.local/share/applications/*.desktop 2>/dev/null | while read -r f; do
    cp "$f" "$DOTFILES_DIR/config/applications/"
done
# Copy webapp icons
cp -r ~/.local/share/applications/icons/. "$DOTFILES_DIR/config/applications/icons/" 2>/dev/null || true

# ── Home directory files ──────────────────────────────────────────────────────
echo "Backing up home directory files..."
cp ~/.bashrc "$DOTFILES_DIR/home/" 2>/dev/null || true
cp ~/.bash_profile "$DOTFILES_DIR/home/" 2>/dev/null || true
cp ~/.zshrc "$DOTFILES_DIR/home/" 2>/dev/null || true
cp ~/.gitconfig "$DOTFILES_DIR/home/" 2>/dev/null || true

# ── Claude Code ───────────────────────────────────────────────────────────────
echo "Backing up Claude configs..."
cp ~/.claude/CLAUDE.md "$DOTFILES_DIR/claude/" 2>/dev/null || true
cp ~/.claude/settings.json "$DOTFILES_DIR/claude/" 2>/dev/null || true
# Commands
cp ~/.claude/commands/*.md "$DOTFILES_DIR/claude/commands/" 2>/dev/null || true
# Agents
cp ~/.claude/agents/*.md "$DOTFILES_DIR/claude/agents/" 2>/dev/null || true

# ── Git commit and push ───────────────────────────────────────────────────────
cd "$DOTFILES_DIR"
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit."
else
    git add -A
    git commit -m "Backup $(date +%Y-%m-%d-%H%M)"
    echo "Changes committed to git."

    echo "Pushing to GitHub..."
    git push origin master
    echo "Pushed to GitHub successfully."
fi

echo "Backup complete!"
