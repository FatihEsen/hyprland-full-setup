#!/bin/bash

# --- RENKLER ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Başlık
echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}    ARCH LINUX MAGIC SETUP - INTERAKTIF KURULUM  ${NC}"
echo -e "${BLUE}==================================================${NC}"

# Sudo kontrolü
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Lütfen bu scripti root (sudo) olarak çalıştırmayın.${NC}"
   exit 1
fi

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Yardımcı Fonksiyon: Kullanıcıya Sor
ask_user() {
    echo -ne "${YELLOW}$1 [y/N]: ${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 1. Temel Gereksinimler
echo -e "${BLUE}[1/5] Temel araçlar kontrol ediliyor...${NC}"
sudo pacman -Syu --needed base-devel git wget zsh

# YAY Kurulumu
if ! command -v yay &> /dev/null; then
    if ask_user "Sistemde 'yay' (AUR yardımcısı) bulunamadı. Kurulsun mu?"; then
        echo -e "${YELLOW}yay-bin kuruluyor...${NC}"
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        cd /tmp/yay-bin && makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
    else
        echo -e "${RED}Uyarı: 'yay' kurulmadı. AUR paketleri atlanacak.${NC}"
    fi
fi

# 2. Paketlerin Kurulumu
echo -e "${BLUE}[2/5] Paket kurulumları...${NC}"

# Resmi paketleri kur
if [ -f "$SCRIPT_DIR/pkglist.txt" ]; then
    if ask_user "Resmi paketler (pkglist.txt) kurulsun mu?"; then
        sudo pacman -S --needed - < "$SCRIPT_DIR/pkglist.txt"
    fi
fi

# AUR paketlerini kur
if [ -f "$SCRIPT_DIR/aurpkglist.txt" ] && command -v yay &> /dev/null; then
    if ask_user "AUR paketleri (aurpkglist.txt) kurulsun mu?"; then
        yay -S --needed - < "$SCRIPT_DIR/aurpkglist.txt"
    fi
fi

# 3. ZSH & Oh-My-Zsh Setup
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if ask_user "Oh-My-Zsh kurulsun mu?"; then
        echo -e "${YELLOW}Oh-My-Zsh indiriliyor...${NC}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
fi

# 4. Config Dosyalarını Yerleştirme
echo -e "${BLUE}[4/5] Yapılandırma dosyaları...${NC}"

if ask_user "Konfigürasyon dosyaları (~/.config ve ~/.local/bin) kopyalansın mı?"; then
    # .config klasörünü kopyala
    if [ -d "$SCRIPT_DIR/.config" ]; then
        mkdir -p ~/.config
        cp -rv "$SCRIPT_DIR"/.config/* ~/.config/
    fi

    # .local/bin klasörünü kopyala
    if [ -d "$SCRIPT_DIR/.local/bin" ]; then
        mkdir -p ~/.local/bin
        cp -rv "$SCRIPT_DIR"/.local/bin/* ~/.local/bin/
        chmod +x ~/.local/bin/*
    fi

    # .zshrc dosyasını kopyala
    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        cp -v "$SCRIPT_DIR"/.zshrc ~/
    fi
fi

# 5. Yetkiler ve Servisler
echo -e "${BLUE}[5/5] Sistem ayarları...${NC}"

if ask_user "Sistem servisleri etkinleştirilsin mi? (NetworkManager, Input Group vb.)"; then
    sudo systemctl enable --now NetworkManager 2>/dev/null || true
    sudo usermod -aG input $USER
    
    # Libinput gestures ayarı (kuruluysa)
    if command -v libinput-gestures-setup &> /dev/null; then
        libinput-gestures-setup autostart
    fi
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}   KURULUM TAMAMLANDI! Sistemi yeniden başlat.    ${NC}"
echo -e "${BLUE}==================================================${NC}"
