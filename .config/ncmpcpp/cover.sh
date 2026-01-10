#!/bin/bash
# ================================================
# NCMPCPP Albüm Kapağı Gösterici (Kitty Protocol)
# ================================================

MUSIC_DIR="$HOME/Müzik"
COVER_CACHE="$HOME/.cache/ncmpcpp/covers"
COVER_SIZE=300

# Cache dizinini oluştur
mkdir -p "$COVER_CACHE"

# Şu an çalan şarkının bilgilerini al
file="$(mpc --format %file% current)"
album="$(mpc --format %album% current)"
artist="$(mpc --format %artist% current)"

# Eğer şarkı yoksa çık
[[ -z "$file" ]] && exit 1

# Albüm dizinini bul
album_dir="$MUSIC_DIR/$(dirname "$file")"

# Albüm kapağını ara (yaygın isimler)
cover_path=""
for cover_name in "cover.jpg" "cover.png" "folder.jpg" "folder.png" "front.jpg" "front.png" "album.jpg" "album.png" "Cover.jpg" "Folder.jpg"; do
    if [[ -f "$album_dir/$cover_name" ]]; then
        cover_path="$album_dir/$cover_name"
        break
    fi
done

# Eğer albüm kapağı bulunamadıysa, dosyanın içine gömülü kapağı çıkar
if [[ -z "$cover_path" ]]; then
    music_file="$album_dir/$(basename "$file")"
    cache_file="$COVER_CACHE/$(echo "$artist-$album" | md5sum | cut -d' ' -f1).jpg"
    
    if [[ ! -f "$cache_file" ]]; then
        ffmpeg -i "$music_file" -an -vcodec copy "$cache_file" 2>/dev/null
    fi
    
    if [[ -f "$cache_file" ]]; then
        cover_path="$cache_file"
    fi
fi

# Eğer hala kapak yoksa varsayılan göster
if [[ -z "$cover_path" ]] || [[ ! -f "$cover_path" ]]; then
    echo "🎵 Albüm kapağı bulunamadı"
    exit 1
fi

# Kitty protokolü ile göster
kitten icat --clear --silent 2>/dev/null
kitten icat --silent --transfer-mode=memory --place="${COVER_SIZE}x${COVER_SIZE}@0x0" "$cover_path" 2>/dev/null
