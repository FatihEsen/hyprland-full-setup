#!/bin/bash

# --- RENKLER ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}    ARCH LINUX MAGIC SETUP - HIZLI MOD (BIN)      ${NC}"
echo -e "${BLUE}==================================================${NC}"

# Sudo kontrolü (Script içinde sudo kullanılacağı için kullanıcı şifresi istenecek)
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Lütfen bu scripti root (sudo) olarak çalıştırmayın. Script içinde gerekince sudo kullanılacaktır.${NC}"
   exit 1
fi

# 1. Update ve Temel Gereksinimler
echo -e "${YELLOW}[1/6] Sistem güncelleniyor ve temel araçlar kuruluyor...${NC}"
sudo pacman -Syu --noconfirm --needed base-devel git wget zsh stow

# 2. YAY-BIN (Hızlı AUR Helper) Kurulumu
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}[2/6] yay-bin (Pre-compiled) kuruluyor...${NC}"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    cd -
else
    echo -e "${GREEN}yay zaten kurulu.${NC}"
fi

# 3. Paket Listesi (Senin sistemindeki tüm kritik uygulamalar)
echo -e "${YELLOW}[3/6] Paketler kuruluyor...${NC}"

OFFICIAL_PKGS=(
    "hyprland" "waybar" "swaync" "kitty" "neovim" "lf" "ncmpcpp" "mpd" "cava" 
    "wofi" "thunar" "htop" "mpv" "brightnessctl" "wireplumber" "grim" "slurp" 
    "wl-clipboard" "libnotify" "hypridle" "hyprlock" "network-manager-applet" 
    "blueman" "pavucontrol" "xdg-desktop-portal-hyprland" "qt5-wayland" "qt6-wayland"
    "fastfetch" "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "papirus-icon-theme"
)

AUR_PKGS=(
    "swww" "cliphist" "wl-clip-persist-bin" "libinput-gestures" 
    "bibata-cursor-theme-bin" "nwg-look"
)

echo -e "${BLUE}Resmi paketler kuruluyor...${NC}"
sudo pacman -S --noconfirm --needed "${OFFICIAL_PKGS[@]}"

echo -e "${BLUE}AUR paketleri kuruluyor...${NC}"
yay -S --noconfirm --needed "${AUR_PKGS[@]}"

# 4. ZSH & Oh-My-Zsh Setup
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}[4/6] Oh-My-Zsh kuruluyor...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Config Dosyalarını Yerleştirme
echo -e "${YELLOW}[5/6] Config dosyaları yerleştiriliyor...${NC}"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

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

# 6. Yetkiler ve Servisler
echo -e "${YELLOW}[6/6] Son ayarlar yapılıyor...${NC}"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo usermod -aG input $USER
# Libinput gestures ayarı
libinput-gestures-setup autostart

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}   HER ŞEY HAZIR! Sistemini yeniden başlatabilirsin. ${NC}"
echo -e "${BLUE}==================================================${NC}"
