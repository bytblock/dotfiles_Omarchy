#!/bin/bash
# iPhone integration status for enhanced Waybar

# Check LocalSend status
if pgrep -x localsend > /dev/null; then
    LOCALSEND_ACTIVE=true
else
    LOCALSEND_ACTIVE=false
fi

# Check network connectivity
if ping -c 1 -W 1 google.com &>/dev/null; then
    NETWORK_ACTIVE=true
else
    NETWORK_ACTIVE=false
fi

# Check for iPhone hotspot connection
if nmcli dev wifi 2>/dev/null | grep -i "iphone" &>/dev/null; then
    IPHONE_HOTSPOT=true
else
    IPHONE_HOTSPOT=false
fi

# Determine status and styling
if $LOCALSEND_ACTIVE && $IPHONE_HOTSPOT; then
    # iPhone connected with full features
    ICON="📱✨"
    STATUS="connected"
    TOOLTIP="iPhone Integration: Connected\n• LocalSend: Active\n• iPhone Hotspot: Connected\n• File sharing ready"
elif $LOCALSEND_ACTIVE && $NETWORK_ACTIVE; then
    # LocalSend ready, network available
    ICON="📱"
    STATUS="ready"  
    TOOLTIP="iPhone Integration: Ready\n• LocalSend: Active\n• Network: Connected\n• Ready for file sharing"
elif $LOCALSEND_ACTIVE; then
    # LocalSend running but limited connectivity
    ICON="📱"
    STATUS="ready"
    TOOLTIP="iPhone Integration: Limited\n• LocalSend: Active\n• Network: Limited"
else
    # Basic connectivity only
    ICON="📱💤"
    STATUS="inactive"
    TOOLTIP="iPhone Integration: Inactive\n• LocalSend: Not running\n• Click to view dashboard"
fi

# Output JSON for Waybar
cat << EOF
{
    "text": "$ICON",
    "tooltip": "$TOOLTIP",
    "class": "$STATUS"
}
EOF