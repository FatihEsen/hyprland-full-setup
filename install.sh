#!/bin/bash

# --- RENKLER ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}    ARCH LINUX MAGIC SETUP - YENİLENMİŞ          ${NC}"
echo -e "${BLUE}==================================================${NC}"

# Sudo kontrolü
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Lütfen bu scripti root (sudo) olarak çalıştırmayın.${NC}"
   exit 1
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# 1. Temel Gereksinimler ve YAY Kurulumu
echo -e "${YELLOW}[1/5] Temel araçlar ve yay kuruluyor...${NC}"
sudo pacman -Syu --noconfirm --needed base-devel git wget zsh stow

if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}yay-bin kuruluyor...${NC}"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd -
fi

# 2. Paketlerin Kurulumu
echo -e "${YELLOW}[2/5] Paketler listelerden kuruluyor...${NC}"

# Resmi paketleri kur
if [ -f "$SCRIPT_DIR/pkglist.txt" ]; then
    echo -e "${BLUE}pkglist.txt paketleri kuruluyor...${NC}"
    sudo pacman -S --noconfirm --needed - < "$SCRIPT_DIR/pkglist.txt"
else
    echo -e "${RED}Hata: pkglist.txt bulunamadı!${NC}"
fi

# AUR paketlerini kur
if [ -f "$SCRIPT_DIR/aurpkglist.txt" ]; then
    echo -e "${BLUE}aurpkglist.txt paketleri kuruluyor...${NC}"
    yay -S --noconfirm --needed - < "$SCRIPT_DIR/aurpkglist.txt"
else
    echo -e "${RED}Hata: aurpkglist.txt bulunamadı!${NC}"
fi

# 3. ZSH & Oh-My-Zsh Setup
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}[3/5] Oh-My-Zsh kuruluyor...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Config Dosyalarını Yerleştirme
echo -e "${YELLOW}[4/5] Config dosyaları yerleştiriliyor...${NC}"

# .config klasörünü kopyala
if [ -d "$SCRIPT_DIR/.config" ]; then
    mkdir -p ~/.config
    cp -r "$SCRIPT_DIR"/.config/* ~/.config/
fi

# .local/bin klasörünü kopyala
if [ -d "$SCRIPT_DIR/.local/bin" ]; then
    mkdir -p ~/.local/bin
    cp -r "$SCRIPT_DIR"/.local/bin/* ~/.local/bin/
    chmod +x ~/.local/bin/*
fi

# .zshrc dosyasını kopyala
if [ -f "$SCRIPT_DIR/.zshrc" ]; then
    cp "$SCRIPT_DIR/.zshrc" ~/
fi

# 5. Yetkiler ve Servisler
echo -e "${YELLOW}[5/5] Son ayarlar yapılıyor...${NC}"
sudo systemctl enable --now NetworkManager 2>/dev/null || true
# Bluetooth servisi (kaldırıldıysa pasif kalsın)
# sudo systemctl enable --now bluetooth 2>/dev/null || true
sudo usermod -aG input $USER

# Libinput gestures ayarı (kuruluysa)
if command -v libinput-gestures-setup &> /dev/null; then
    libinput-gestures-setup autostart
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}   KURULUM TAMAMLANDI! Sistemi yeniden başlat.    ${NC}"
echo -e "${BLUE}==================================================${NC}"
