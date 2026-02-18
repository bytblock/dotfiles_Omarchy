# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Re-enable command hashing for nvm (Omarchy disables it for mise)
set -h

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
. "$HOME/.cargo/env"

. "$HOME/.local/share/../bin/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Load secrets (API keys, tokens) from separate file
[ -f ~/.secrets.sh ] && source ~/.secrets.sh

export PATH="$PATH:/home/rooutt/.config/.foundry/bin"

# Zoxide - smarter cd command (use 'z' instead of 'cd')
eval "$(zoxide init bash)"

# Ollama quick aliases
alias ask='ollama run deepseek-coder:33b'
alias chat='ollama run mistral'

# Claude Code alias
alias c='claude'

# Ask Ollama about a file
askfile() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: askfile <file> <question>"
        echo "Example: askfile main.sol 'review this contract'"
        return 1
    fi
    cat "$1" | ollama run deepseek-coder:33b "$2"
}

# Docker aliases
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dlog='docker logs -f'
alias dex='docker exec -it'
alias drm='docker rm -f'
alias drmi='docker rmi'
alias dprune='docker system prune -a'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias lzd='lazydocker'

# Quick container launchers
drun() {
    case $1 in
        postgres|pg)
            docker run -d --name postgres -e POSTGRES_PASSWORD=${2:-secret} -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgres:16-alpine
            echo "PostgreSQL running on localhost:5432 (password: ${2:-secret})"
            ;;
        redis)
            docker run -d --name redis -p 6379:6379 redis:alpine
            echo "Redis running on localhost:6379"
            ;;
        mongo)
            docker run -d --name mongo -p 27017:27017 -v mongodata:/data/db mongo:7
            echo "MongoDB running on localhost:27017"
            ;;
        nginx)
            docker run -d --name nginx -p ${2:-80}:80 -v "$(pwd)":/usr/share/nginx/html:ro nginx:alpine
            echo "Nginx serving current dir on localhost:${2:-80}"
            ;;
        anvil)
            docker run -d --name anvil -p 8545:8545 ghcr.io/foundry-rs/foundry anvil --host 0.0.0.0
            echo "Anvil testnet running on localhost:8545"
            ;;
        *)
            echo "Usage: drun <service> [options]"
            echo "Services: postgres|pg, redis, mongo, nginx, anvil"
            echo "Examples:"
            echo "  drun postgres           # Start PostgreSQL (password: secret)"
            echo "  drun pg mypassword      # Start PostgreSQL with custom password"
            echo "  drun redis              # Start Redis"
            echo "  drun nginx 8080         # Start Nginx on port 8080"
            echo "  drun anvil              # Start Anvil local testnet"
            ;;
    esac
}
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Smart CPU Performance Management
alias cpu-auto='smart-performance'  # Auto-adjust based on AC power
alias cpu-medium='echo "medium" > ~/.config/battery-mode && smart-performance'  # Battery medium performance  
alias cpu-eco='echo "eco" > ~/.config/battery-mode && smart-performance'        # Battery eco mode
alias cpu-status='echo "Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor) | EPP: $(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference) | AC: $([ $(cat /sys/class/power_supply/AC/online) = 1 ] && echo \"🔌\" || echo \"🔋\") | Battery Mode: $(cat ~/.config/battery-mode 2>/dev/null || echo \"medium\")"'
alias cpu-monitor='cpu-monitor'  # Live monitoring of CPU governor changes

# Legacy aliases (for compatibility)
alias cpu-performance='sudo cpupower frequency-set -g performance && echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null && echo "CPU: PERFORMANCE mode"'
alias cpu-powersave='sudo cpupower frequency-set -g powersave && echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null && echo "CPU: POWERSAVE mode"'

alias cb="clawdbot tui --session main"
export GOG_ACCOUNT=brandonaculp@gmail.com
export GOG_ACCOUNT=b@bytblock.io
alias studio='ssh macstudio'
alias money='money-dashboard'
alias money-stop='pkill -f "next dev" && echo "💰 Diamond Dashboard stopped"'
alias money-status='pgrep -f "next dev" > /dev/null && echo "✅ Diamond Dashboard is running" || echo "❌ Diamond Dashboard is not running"'
alias money-logs='tail -f /tmp/diamond-dashboard.log'

# Quick access to Omarchy Expert for system administration
alias admin='claude "I need Omarchy system administration help"'

# ============================================================================
# CLAUDE CODE AUTONOMOUS MODE (YOLO MODE)
# ============================================================================
# Safety-first autonomous coding with automatic git checkpoints
# Based on: https://medium.com/@ernestodotnet/stop-babysitting-your-ai-coder
# ============================================================================

# Full YOLO mode - no permission prompts (requires git repo)
alias yolo='_claude_yolo'

# Safe YOLO - read/edit only, no shell commands
alias yolo-safe='_claude_yolo_safe'

# Read-only YOLO - exploration without modifications
alias yolo-read='_claude_yolo_read'

# YOLO with custom tool permissions
alias yolo-custom='_claude_yolo_custom'

# Git checkpoint helpers
alias checkpoint='_git_checkpoint'
alias checkpoint-reset='_git_checkpoint_reset'
alias checkpoint-diff='_git_checkpoint_diff'

# Full YOLO mode implementation
_claude_yolo() {
    if [ -z "$1" ]; then
        echo "Usage: yolo \"your prompt here\""
        echo "Example: yolo \"refactor authentication to use JWT\""
        return 1
    fi

    # Verify we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository!"
        echo "YOLO mode requires git for safety. Run: git init"
        return 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "⚠️  Warning: You have uncommitted changes"
        echo "Creating safety checkpoint before YOLO mode..."
        git add -A
        git commit -m "Pre-YOLO checkpoint: $(date '+%Y-%m-%d %H:%M:%S')" || true
    fi

    # Create YOLO branch if not exists
    current_branch=$(git branch --show-current)
    if [[ ! "$current_branch" =~ yolo ]]; then
        yolo_branch="yolo-session-$(date +%s)"
        echo "🚀 Creating YOLO branch: $yolo_branch"
        git checkout -b "$yolo_branch"
    fi

    echo "🎯 YOLO MODE ACTIVATED - No permission prompts"
    echo "📍 Branch: $(git branch --show-current)"
    echo "💾 Auto-checkpointing enabled"
    echo ""

    claude --dangerously-skip-permissions "$@"

    echo ""
    echo "✅ YOLO session complete"
    echo "📊 Review changes with: checkpoint-diff"
    echo "♻️  Reset if needed with: checkpoint-reset"
}

# Safe YOLO - only read and edit operations
_claude_yolo_safe() {
    if [ -z "$1" ]; then
        echo "Usage: yolo-safe \"your prompt here\""
        echo "Safe mode: Read, Grep, Edit, Write only (no shell commands)"
        return 1
    fi

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository!"
        return 1
    fi

    echo "🛡️  SAFE YOLO MODE - File operations only, no shell commands"
    claude --allowedTools "Read,Grep,Glob,Edit,Write" "$@"
}

# Read-only YOLO - exploration mode
_claude_yolo_read() {
    if [ -z "$1" ]; then
        echo "Usage: yolo-read \"your prompt here\""
        echo "Read mode: Analyze codebase without modifications"
        return 1
    fi

    echo "👀 READ-ONLY YOLO MODE - No file modifications"
    claude --allowedTools "Read,Grep,Glob" "$@"
}

# Custom YOLO with user-specified tools
_claude_yolo_custom() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: yolo-custom \"Tools\" \"your prompt here\""
        echo "Example: yolo-custom \"Read,Edit,Bash\" \"update docker configs\""
        echo ""
        echo "Available tools: Read, Grep, Glob, Edit, Write, Bash, Task"
        return 1
    fi

    tools="$1"
    shift
    echo "🎨 CUSTOM YOLO MODE - Tools: $tools"
    claude --allowedTools "$tools" "$@"
}

# Create git checkpoint
_git_checkpoint() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi

    msg="${1:-Checkpoint: $(date '+%Y-%m-%d %H:%M:%S')}"
    git add -A
    git commit -m "$msg"
    echo "✅ Checkpoint created: $msg"
}

# Show diff from last checkpoint
_git_checkpoint_diff() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi

    echo "📊 Changes since last checkpoint:"
    echo ""
    git diff --stat HEAD
    echo ""
    echo "Full diff:"
    git diff HEAD
}

# Reset to last checkpoint
_git_checkpoint_reset() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi

    echo "⚠️  This will discard all changes since last checkpoint!"
    echo "Changes to be discarded:"
    git diff --stat HEAD
    echo ""
    read -p "Are you sure? (yes/no): " confirm

    if [ "$confirm" = "yes" ]; then
        git reset --hard HEAD
        echo "♻️  Reset to last checkpoint"
    else
        echo "Cancelled"
    fi
}

# Crypto monitoring aliases
alias crypto='cointop'
alias btc='cointop price -c bitcoin'
alias eth='cointop price -c ethereum'
alias prices='ticker -w BTC-USD,ETH-USD,SOL-USD,USDT-USD -i 10 --show-fundamentals'

# Brave browser performance helpers
alias brave-cache-clear='rm -rf ~/.cache/BraveSoftware/Brave-Browser/Default/Cache/ && mkdir -p ~/.cache/BraveSoftware/Brave-Browser/Default/Cache/ && echo "✓ Brave cache cleared"'
alias brave-mem='ps aux | grep brave | grep -v grep | awk "{sum+=\$6} END {print \"Brave RAM usage: \" sum/1024 \" MB\"}"'

# Brave cache monitoring
alias brave-cache-size='du -sh ~/.cache/BraveSoftware/ 2>/dev/null || echo "Cache not found"'
alias brave-cache-log='tail -20 ~/.cache/brave-cleanup.log 2>/dev/null || echo "No cleanup log yet"'
export NPM_CONFIG_PREFIX="$HOME/.local"
export PATH="$HOME/.local/bin:$PATH"
