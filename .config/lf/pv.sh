#!/bin/sh

file=$1
w=$2
h=$3
x=$4
y=$5

if [ ! -f "$file" ]; then
    exit
fi

# Dosya türünü tespit et
mime=$(file --dereference --brief --mime-type -- "$file")

case "$mime" in
    image/*)
        # Kitty'nin kendi resim protokolünü kullan (Wayland dostu)
        kitten icat --silent --stdin=no --transfer-mode=memory --place "${w}x${h}@${x}x${y}" "$file" < /dev/null > /dev/tty
        exit 1
        ;;
    video/*)
        # Video için thumbnail oluştur
        cache="$HOME/.cache/lf/$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$file")" | sha256sum | awk '{print $1}')"
        [ ! -f "$cache" ] && ffmpegthumbnailer -i "$file" -o "$cache" -s 0
        kitten icat --silent --stdin=no --transfer-mode=memory --place "${w}x${h}@${x}x${y}" "$cache" < /dev/null > /dev/tty
        exit 1
        ;;
    application/pdf)
        # PDF için ilk sayfanın resmini oluştur
        cache="$HOME/.cache/lf/$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$file")" | sha256sum | awk '{print $1}').jpg"
        [ ! -f "$cache" ] && pdftoppm -jpeg -f 1 -l 1 -scale-to-x 1920 -scale-to-y -1 -singlefile "$file" "${cache%.*}"
        kitten icat --silent --stdin=no --transfer-mode=memory --place "${w}x${h}@${x}x${y}" "$cache" < /dev/null > /dev/tty
        exit 1
        ;;
    text/* | application/json | application/javascript | application/x-sh)
        # Metin dosyaları için bat kullan
        bat --color=always --style=plain --wrap=character --terminal-width="$((w - 2))" "$file"
        ;;
    *)
        # Diğer dosyalar için basit bilgi
        echo "$mime"
        file -b "$file"
        ;;
esac
