#!/bin/bash
# Quick launcher for Diamond Dashboard
# Usage: bind in Hyprland config

# Check if already running and focused
if hyprctl activewindow | grep -q "DiamondDashboard"; then
    # Already focused, minimize or close
    hyprctl dispatch closewindow
else
    # Check if running but not focused
    if hyprctl clients | grep -q "DiamondDashboard"; then
        # Focus existing window
        hyprctl dispatch focuswindow class:DiamondDashboard
    else
        # Launch new instance
        /home/rooutt/bin/money-dashboard --webapp > /dev/null 2>&1 &
    fi
fi