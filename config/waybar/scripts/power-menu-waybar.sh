#!/bin/bash
# Power menu for enhanced Waybar

# Use walker if available, otherwise fallback to basic menu
if command -v walker &> /dev/null; then
    CHOICE=$(echo -e "🔒 Lock\n🌙 Sleep\n🔄 Restart\n⏻ Shutdown\n📱 iPhone Dashboard\n⚡ CPU Status\n⚙️ Settings" | \
        walker --dmenu \
               --prompt="Power " \
               --no-actions \
               --width=250 \
               --height=200)
else
    # Fallback to basic selection
    CHOICE=$(echo -e "Lock\nSleep\nRestart\nShutdown\niPhone Dashboard\nCPU Status" | dmenu -p "Power:")
fi

case "$CHOICE" in
    *"Lock"*)
        if command -v hyprlock &> /dev/null; then
            hyprlock
        elif command -v swaylock &> /dev/null; then
            swaylock -f -c 000000
        else
            loginctl lock-session
        fi
        ;;
    *"Sleep"*)
        systemctl suspend
        ;;
    *"Restart"*)
        if command -v walker &> /dev/null; then
            CONFIRM=$(echo -e "Yes\nNo" | walker --dmenu --prompt="Restart system? ")
        else
            CONFIRM=$(echo -e "Yes\nNo" | dmenu -p "Restart system?")
        fi
        if [ "$CONFIRM" = "Yes" ]; then
            systemctl reboot
        fi
        ;;
    *"Shutdown"*)
        if command -v walker &> /dev/null; then
            CONFIRM=$(echo -e "Yes\nNo" | walker --dmenu --prompt="Shutdown system? ")
        else
            CONFIRM=$(echo -e "Yes\nNo" | dmenu -p "Shutdown system?")
        fi
        if [ "$CONFIRM" = "Yes" ]; then
            systemctl poweroff
        fi
        ;;
    *"iPhone Dashboard"*)
        if command -v kitty &> /dev/null; then
            kitty --title "iPhone Dashboard" -e iphone-dashboard &
        else
            $TERMINAL -e iphone-dashboard &
        fi
        ;;
    *"CPU Status"*)
        if command -v kitty &> /dev/null; then
            kitty --title "CPU Performance" -e cpu-status &
        else
            $TERMINAL -e cpu-status &
        fi
        ;;
    *"Settings"*)
        if command -v gnome-control-center &> /dev/null; then
            gnome-control-center &
        elif command -v systemsettings &> /dev/null; then
            systemsettings &
        else
            if command -v kitty &> /dev/null; then
                kitty --title "System Monitor" -e htop &
            else
                $TERMINAL -e htop &
            fi
        fi
        ;;
esac