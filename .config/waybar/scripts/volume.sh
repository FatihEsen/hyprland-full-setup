#!/bin/bash

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

if [[ "$VOLUME" == *"MUTED"* ]]; then
    echo '{"text": "MUTED", "class": "muted"}'
else
    PERCENT=$(echo "$VOLUME" | awk '{printf "%.0f", $2 * 100}')
    if (( PERCENT == 0 )); then
        ICON="Low"
    elif (( PERCENT < 50 )); then
        ICON="Half"
    else
        ICON="Full"
    fi
    echo "{\"text\": \"$ICON $PERCENT%\", \"percentage\": $PERCENT}"
fi
