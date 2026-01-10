#!/bin/bash
# Bluetooth Toggle
STATE=$(bluetoothctl show | grep "Powered: yes")
if [ -z "$STATE" ]; then
    bluetoothctl power on
else
    bluetoothctl power off
fi
python3 ~/.config/swaync/scripts/status_monitor.py
