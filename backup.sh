#!/bin/bash

# --- RENKLER ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Klasör isimlerini ayarla
DOTFILES_DIR=$(dirname "$(realpath "$0")")
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}    HYPRLAND BACKUP SCRIPT                       ${NC}"
echo -e "${BLUE}==================================================${NC}"

# .config altındaki klasörleri güncelle
folders=("hypr" "kitty" "waybar" "swaync" "ncmpcpp" "lf" "nvim" "wofi" "fastfetch" "mpd" "htop" "btop")

for folder in "${folders[@]}"; do
    if [ -d "$CONFIG_DIR/$folder" ]; then
        echo -e "${YELLOW}Yedekleniyor: $folder${NC}"
        rm -rf "$DOTFILES_DIR/.config/$folder"
        mkdir -p "$DOTFILES_DIR/.config"
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

# Paket listelerini güncelle (Spesifik paketleri hariç tut)
echo -e "${YELLOW}Paket listeleri güncelleniyor...${NC}"
pacman -Qqen | grep -vE "^(inkscape)$" > "$DOTFILES_DIR/pkglist.txt"
pacman -Qqem | grep -vE "^(inkscape)$" > "$DOTFILES_DIR/aurpkglist.txt"

echo -e "${GREEN}Tüm dosyalar ve paket listeleri güncellendi.${NC}"

# Git İşlemleri
cd "$DOTFILES_DIR" || exit

if [ -d ".git" ]; then
    if git status --porcelain | grep -q .; then
        echo -e "${YELLOW}Değişiklikler algılandı, commit ediliyor...${NC}"
        git add .
        git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
        echo -e "${YELLOW}GitHub'a gönderiliyor...${NC}"
        git push origin main 2>/dev/null || echo -e "${RED}Push başarısız (Remote ayarlı olmayabilir).${NC}"
        echo -e "${GREEN}Başarıyla yedeklendi!${NC}"
    else
        echo -e "${BLUE}Herhangi bir değişiklik yok.${NC}"
    fi
else
    echo -e "${BLUE}Git reposu bulunamadı, sadece dosyalar güncellendi.${NC}"
fi

echo -e "${BLUE}==================================================${NC}"
