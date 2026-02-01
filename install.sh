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

# 3. Paket Listesi
echo -e "${YELLOW}[3/6] Paketler kuruluyor...${NC}"

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Varsayılan paketler (Dosyalar yoksa kullanılacak)
OFFICIAL_PKGS=(
    "hyprland" "hyprlock" "hypridle" "hyprcursor" "hyprgraphics" "hyprlang" "hyprutils" "hyprwayland-scanner"
    "waybar" "swaync" "kitty" "neovim" "lf" "ncmpcpp" "mpd" "mpc" "cava" 
    "wofi" "thunar" "htop" "btop" "mpv" "brightnessctl" "wireplumber" "grim" "slurp" 
    "wl-clipboard" "libnotify" "network-manager-applet" "blueman" "pavucontrol" 
    "xdg-desktop-portal-hyprland" "qt5-wayland" "qt6-wayland" "polkit-kde-agent"
    "playerctl" "pamixer" "jq" "socat" "gvfs" "ffmpegthumbnailer" "tumbler"
    "thunar-archive-plugin" "file-roller" "imv" "swappy" "hyprpicker" "wlogout"
    "swww" "cliphist" "nwg-look" "wl-clip-persist"
    "fastfetch" "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "papirus-icon-theme" "zsh" "stow"
)

AUR_PKGS=(
    "libinput-gestures" "bibata-cursor-theme-bin"
)

# Resmi paketleri kur
if [ -f "$SCRIPT_DIR/pkglist.txt" ]; then
    echo -e "${BLUE}pkglist.txt bulundu, paketler kuruluyor...${NC}"
    sudo pacman -S --noconfirm --needed - < "$SCRIPT_DIR/pkglist.txt"
else
    echo -e "${BLUE}Varsayılan resmi paketler kuruluyor...${NC}"
    sudo pacman -S --noconfirm --needed "${OFFICIAL_PKGS[@]}"
fi

# AUR paketlerini kur
if [ -f "$SCRIPT_DIR/aurpkglist.txt" ]; then
    echo -e "${BLUE}aurpkglist.txt bulundu, paketler kuruluyor...${NC}"
    yay -S --noconfirm --needed - < "$SCRIPT_DIR/aurpkglist.txt"
else
    echo -e "${BLUE}Varsayılan AUR paketleri kuruluyor...${NC}"
    yay -S --noconfirm --needed "${AUR_PKGS[@]}"
fi

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
