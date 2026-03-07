#!/bin/bash
# Hyprland seri tıklama toggle (100 click/saniye)
# mouse:275 tuşuna basarak aç/kapa

PIDFILE=/tmp/autoclick.pid

if [ -f "$PIDFILE" ]; then
    kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE"
    notify-send "AutoClick" "❌ Kapandı" -t 2000
else
    notify-send "AutoClick" "✅ Açıldı (100/s)" -t 2000
    ydotool click 0xC0 --repeat 99999 --delay 10 &
    echo $! > "$PIDFILE"
fi
