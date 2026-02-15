#!/bin/bash
# Tüm oynatıcıları kontrol et
players=$(playerctl -l 2>/dev/null)
# Önce 'Playing' durumundakini ara
for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" == "Playing" ]; then
        artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
        title=$(playerctl -p "$player" metadata title 2>/dev/null)
        if [ -n "$title" ]; then
            echo "🎵 $artist - $title"
            exit 0
        fi
    fi
done
# Eğer çalan yoksa, 'Paused' olanı göster
for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" == "Paused" ]; then
        artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
        title=$(playerctl -p "$player" metadata title 2>/dev/null)
        if [ -n "$title" ]; then
            echo "⏸️ $artist - $title"
            exit 0
        fi
    fi
done
# Hiçbir şey yoksa boş döndür
echo ""
