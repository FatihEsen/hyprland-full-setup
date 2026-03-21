#!/bin/bash

# Function to get the ID of the connected Bluetooth sink
get_bt_sink_id() {
    # It searches for common Bluetooth identifiers in the Sinks section of wpctl status.
    # Wuzhi, bluez, and common brand names or 'Audio' often appear.
    wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep -oP '\d+(?=\. (?:Wuzhi|bluez|Audio|Headphone|Earbud))' | head -n 1
}

ACTION=$1
TARGET=$2

if [ "$TARGET" == "bt" ]; then
    SINK=$(get_bt_sink_id)
else
    # Dynamic behavior: prioritize BT if connected
    BT_SINK=$(get_bt_sink_id)
    if [ -n "$BT_SINK" ]; then
        SINK="$BT_SINK"
    else
        SINK="@DEFAULT_AUDIO_SINK@"
    fi
fi

# Fallback in case SINK is empty or not found
if [ -z "$SINK" ]; then
    SINK="@DEFAULT_AUDIO_SINK@"
fi

case $ACTION in
    up)
        wpctl set-volume "$SINK" 5%+
        ;;
    down)
        wpctl set-volume "$SINK" 5%-
        ;;
    mute)
        wpctl set-mute "$SINK" toggle
        ;;
esac

# Signal waybar to refresh the volume module
pkill -RTMIN+2 waybar
