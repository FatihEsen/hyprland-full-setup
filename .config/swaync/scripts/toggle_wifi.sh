#!/bin/bash
# WiFi Toggle
STATE=$(nmcli radio wifi)
if [ "$STATE" = "enabled" ]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
python3 ~/.config/swaync/scripts/status_monitor.py
