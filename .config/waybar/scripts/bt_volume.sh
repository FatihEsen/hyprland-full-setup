#!/bin/bash

# Function to get the ID of the connected Bluetooth sink
get_bt_sink_id() {
    # This filters wpctl status for Bluetooth sinks. 
    # Usually they have [bluez5] or are in the Sinks block.
    # Looking for 'Wuzhi' specifically as seen in user's config, or any bluez sink.
    wpctl status | grep -A 20 "Sinks:" | grep -E "Wuzhi|bluez" | head -n 1 | awk '{print $2}' | tr -d '.' | grep -E '^[0-9]+$'
}

get_default_sink_id() {
    wpctl status | grep -A 10 "Sinks:" | grep "*" | head -n 1 | awk '{print $3}' | tr -d '.' | grep -E '^[0-9]+$'
    # If the above fails, fallback to @DEFAULT_AUDIO_SINK@
    if [ $? -ne 0 ]; then
        echo "@DEFAULT_AUDIO_SINK@"
    fi
}

ACTION=$1
SINK_ID=$(get_bt_sink_id)

# If no BT sink found, fallback to default sink
if [ -z "$SINK_ID" ]; then
    SINK_ID="@DEFAULT_AUDIO_SINK@"
fi

case $ACTION in
    up)
        wpctl set-volume "$SINK_ID" 5%+
        ;;
    down)
        wpctl set-volume "$SINK_ID" 5%-
        ;;
    mute)
        wpctl set-mute "$SINK_ID" toggle
        ;;
esac

# Update Waybar volume module (if it uses signal 2)
pkill -RTMIN+2 waybar
