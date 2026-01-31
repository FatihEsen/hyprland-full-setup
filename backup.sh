#!/bin/bash

# --- RENKLER ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}    DOTFILES BACKUP SCRIPT                       ${NC}"
echo -e "${BLUE}==================================================${NC}"

# .config altındaki klasörleri güncelle
folders=("hypr" "kitty" "waybar" "swaync" "ncmpcpp" "ncspot" "lf" "nvim" "wofi" "fastfetch" "cava" "mpd" "htop" "btop")

for folder in "${folders[@]}"; do
    if [ -d "$CONFIG_DIR/$folder" ]; then
        echo -e "${YELLOW}Yedekleniyor: $folder${NC}"
        rm -rf "$DOTFILES_DIR/.config/$folder"
        cp -r "$CONFIG_DIR/$folder" "$DOTFILES_DIR/.config/"
    fi
done

# .local/bin klasörünü güncelle
if [ -d "$HOME/.local/bin" ]; then
    echo -e "${YELLOW}Yedekleniyor: .local/bin${NC}"
    mkdir -p "$DOTFILES_DIR/.local"
    rm -rf "$DOTFILES_DIR/.local/bin"
    cp -r "$HOME/.local/bin" "$DOTFILES_DIR/.local/"
fi

# .zshrc dosyasını güncelle
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}Yedekleniyor: .zshrc${NC}"
    cp "$HOME/.zshrc" "$DOTFILES_DIR/"
fi

# Paket listelerini güncelle
echo -e "${YELLOW}Paket listeleri güncelleniyor...${NC}"
# Resmi paketler (explicitly installed, not as dependencies)
pacman -Qqen > "$DOTFILES_DIR/pkglist.txt"
# AUR paketleri (explicitly installed from AUR)
pacman -Qqem > "$DOTFILES_DIR/aurpkglist.txt"

echo -e "${GREEN}Tüm dosyalar ve paket listeleri $DOTFILES_DIR içine kopyalandı.${NC}"

# Git İşlemleri
cd "$DOTFILES_DIR" || exit

# Değişiklik var mı kontrol et
if git status --porcelain | grep -q .; then
    echo -e "${YELLOW}Değişiklikler algılandı, commit ediliyor...${NC}"
    git add .
    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${YELLOW}GitHub'a pushlanıyor...${NC}"
    git push origin main
    echo -e "${GREEN}Başarıyla yedeklendi ve GitHub'a gönderildi!${NC}"
else
    echo -e "${BLUE}Herhangi bir değişiklik yok.${NC}"
fi

echo -e "${BLUE}==================================================${NC}"
