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
echo -e "${GREEN}    DOTFILES RESTORE (GERI YÜKLEME)             ${NC}"
echo -e "${BLUE}==================================================${NC}"

# 1. GitHub'dan en güncel halini çek
echo -e "${YELLOW}GitHub'dan en güncel dosyalar çekiliyor...${NC}"
cd "$DOTFILES_DIR" || exit
git pull origin main

# 2. .config dosyalarını geri yükle
echo -e "${YELLOW}.config dosyaları geri yükleniyor...${NC}"
if [ -d "$DOTFILES_DIR/.config" ]; then
    mkdir -p "$CONFIG_DIR"
    cp -r "$DOTFILES_DIR"/.config/* "$CONFIG_DIR/"
fi

# 3. .local/bin klasörünü geri yükle
echo -e "${YELLOW}.local/bin klasörü geri yükleniyor...${NC}"
if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
    cp -r "$DOTFILES_DIR/.local/bin"/* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin"/*
fi

# 4. .zshrc dosyasını geri yükle
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    echo -e "${YELLOW}.zshrc geri yükleniyor...${NC}"
    cp "$DOTFILES_DIR/.zshrc" "$HOME/"
fi

echo -e "${GREEN}Tüm ayarlar başarıyla sisteme geri yüklendi!${NC}"
echo -e "${BLUE}Not: Bazı değişikliklerin (örneğin waybar veya hyprland) aktif olması için yenileme gerekebilir.${NC}"
echo -e "${BLUE}==================================================${NC}"
