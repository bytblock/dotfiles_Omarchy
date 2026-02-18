#!/bin/bash
# CPU performance status for enhanced Waybar

# Check current governor
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")

# Check EPP (Energy Performance Preference) if available
EPP=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "unknown")

# Check AC power status
AC_STATUS=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo "0")

# Check battery mode preference
BATTERY_MODE=$(cat ~/.config/battery-mode 2>/dev/null || echo "medium")

# Determine status and icon
if [ "$AC_STATUS" = "1" ]; then
    # AC Power - Performance mode
    if [ "$GOVERNOR" = "performance" ]; then
        ICON="⚡"
        STATUS="performance"
        MODE="Performance"
        TOOLTIP="CPU: Performance Mode\n• AC Power connected\n• Maximum performance\n• Governor: $GOVERNOR"
    else
        ICON="🔌"
        STATUS="performance"
        MODE="AC Power"
        TOOLTIP="CPU: AC Power\n• Plugged in\n• Governor: $GOVERNOR\n• EPP: $EPP"
    fi
else
    # Battery power
    if [ "$EPP" = "balance_performance" ] || [ "$BATTERY_MODE" = "medium" ]; then
        ICON="🔋"
        STATUS="balanced"
        MODE="Balanced"
        TOOLTIP="CPU: Battery Balanced\n• Good performance + efficiency\n• Governor: $GOVERNOR\n• EPP: $EPP\n• Mode: $BATTERY_MODE"
    elif [ "$EPP" = "balance_power" ] || [ "$BATTERY_MODE" = "eco" ]; then
        ICON="🔋💚"
        STATUS="powersave"
        MODE="Eco"
        TOOLTIP="CPU: Battery Eco\n• Maximum battery life\n• Governor: $GOVERNOR\n• EPP: $EPP\n• Mode: $BATTERY_MODE"
    else
        ICON="🔋"
        STATUS="balanced"
        MODE="Battery"
        TOOLTIP="CPU: Battery Mode\n• Governor: $GOVERNOR\n• EPP: $EPP\n• Battery mode: $BATTERY_MODE"
    fi
fi

# Output JSON for Waybar
cat << EOF
{
    "text": "$ICON",
    "tooltip": "$TOOLTIP",
    "class": "$STATUS"
}
EOF