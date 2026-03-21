#!/bin/bash

# Function to get the ID of the connected Bluetooth sink
get_bt_sink_id() {
    wpctl status | sed -n '/Sinks:/,/Sources:/p' | grep -oP '\d+(?=\. (?:Wuzhi|bluez|Audio|Headphone|Earbud))' | head -n 1
}

# Determine SINK
BT_SINK=$(get_bt_sink_id)
if [ -n "$BT_SINK" ]; then
    SINK="$BT_SINK"
else
    SINK="@DEFAULT_AUDIO_SINK@"
fi

# Get volume and mute status
VOLUME_INFO=$(wpctl get-volume "$SINK")

if echo "$VOLUME_INFO" | grep -q "\[MUTED\]"; then
    ICON=""
    echo "{\"text\": \"$ICON Sessiz\", \"class\": \"muted\", \"tooltip\": \"Ses Kapalı\"}"
    exit 0
fi

# Extract volume and convert to percentage
VOLUME=$(echo "$VOLUME_INFO" | awk '{print $2}')
PERCENT=$(echo "$VOLUME * 100 / 1" | bc)

# Active Sink Info for icons and tooltip
SINK_DESC=$(wpctl inspect "$SINK" | grep "node.description =" | cut -d '"' -f 2)

# Icon logic
if [[ "$SINK_DESC" == *"Bluetooth"* || "$SINK_DESC" == *"Wuzhi"* || "$SINK_DESC" == *"bluez"* ]]; then
    ICON="" # Bluetooth icon
elif [[ "$SINK_DESC" == *"Headphone"* || "$SINK_DESC" == *"Headset"* || "$SINK_DESC" == *"Kulaklık"* ]]; then
    ICON="" # Headphones icon
elif [ "$PERCENT" -eq 0 ]; then
    ICON="" # Zero volume
elif [ "$PERCENT" -lt 40 ]; then
    ICON="" # Low volume
else
    ICON="" # High volume
fi

echo "{\"text\": \"$ICON $PERCENT%\", \"percentage\": $PERCENT, \"tooltip\": \"Cihaz: $SINK_DESC\", \"class\": \"volume\"}"
