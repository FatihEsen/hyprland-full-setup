#!/bin/bash

# ================================================
# HYPRLAND OTOMATİK KURULUM SCRIPTI - FEVKALADENİN FEVKİNDE!
# Kullanım: chmod +x hyprland-setup.sh && ./hyprland-setup.sh
# ================================================

set -e

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Log fonksiyonu
log() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
    exit 1
}

# Başlık
echo -e "${BLUE}"
echo "================================================"
echo "   HYPRLAND OTOMATİK KURULUM SCRIPTI"
echo "         FEVKALADENİN FEVKİNDE!"
echo "================================================"
echo -e "${NC}"

# Kullanıcı kontrolü
if [[ $EUID -eq 0 ]]; then
    error "Bu script root olarak çalıştırılamaz!"
fi

# Dağıtım kontrolü
if ! command -v pacman &> /dev/null; then
    error "Bu script şu anda sadece Arch Linux/EndeavourOS için desteklenmektedir!"
fi

# Backup alma
backup_config() {
    local config_dir=$1
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [ -d "$config_dir" ]; then
        mkdir -p "$backup_dir"
        cp -r "$config_dir" "$backup_dir/" 2>/dev/null || true
        log "Mevcut config'ler yedeklendi: $backup_dir"
    fi
}

# Gerekli paketleri yükle
install_packages() {
    log "Gerekli paketler yükleniyor..."
    
    # Hyprland ve temel paketler
    sudo pacman -S --needed --noconfirm \
        hyprland \
        waybar \
        dunst \
        kitty \
        thunar \
        firefox \
        wofi \
        neovim \
        brightnessctl \
        grim \
        slurp \
        wl-clipboard \
        cliphist \
        pavucontrol \
        ttf-terminus-nerd \
        ttf-font-awesome \
        ttf-joypixels \
        noto-fonts-emoji \
        polkit-gnome || warn "Bazı paketler yüklenemedi, manuel kontrol önerilir"
}

# Config dizinlerini oluştur
create_directories() {
    log "Config dizinleri oluşturuluyor..."
    
    mkdir -p ~/.config/hypr
    mkdir -p ~/.config/waybar
    mkdir -p ~/.config/waybar/scripts
    mkdir -p ~/.config/kitty
    mkdir -p ~/.config/wofi
}

# Hyprland config yükle
setup_hyprland() {
    log "Hyprland config yükleniyor..."
    
    cat > ~/.config/hypr/hyprland.conf << 'EOF'
# ================================================
# HYPR LAND - TAM ÇALIŞIR KONFİG (2025)
# Kopyala-yapıştır → hyprctl reload
# ================================================

$mainMod = SUPER

monitor=,preferred,auto,1

input {
    kb_layout = tr
    follow_mouse = 1
    touchpad {
        natural_scroll = yes 
    }
    sensitivity = 0
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 1
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 5
    blur {
        enabled = true
        size = 3
        passes = 1
    }
}

animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# --- BAŞLANGIÇ UYGULAMALARI ---
exec-once = dunst &
exec-once = hyprpaper &
exec-once = wl-paste --watch cliphist store

# WAYBAR'I GEÇ BAŞLAT → IPC BAĞLANTISI İÇİN
exec = sleep 2 && waybar &

# --- MOUSE ---
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# --- WORKSPACES ---
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

# --- UYGULAMALAR ---
bind = $mainMod, Return, exec, kitty zsh
bind = $mainMod, Q, killactive
bind = $mainMod, E, exec, thunar
bind = $mainMod, B, exec, firefox
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, N, exec, kitty -e nvim

# --- PENCERE ---
bind = $mainMod, V, togglefloating
bind = $mainMod, F, fullscreen, 0
bind = $mainMod SHIFT, F, fullscreen, 1
bind = $mainMod, P, pseudo

# --- ODAK ---
bind = $mainMod, left,  movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up,    movefocus, u
bind = $mainMod, down,  movefocus, d

bind = $mainMod SHIFT, left,  movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up,    movewindow, u
bind = $mainMod SHIFT, down,  movewindow, d

# --- MEDYA ---
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# --- EKRAN GÖRÜNTÜSÜ ---
bind = , Print, exec, grim - | wl-copy && notify-send "Ekran görüntüsü panoya kopyalandı"
bind = SHIFT, Print, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Bölge panoya kopyalandı"

# --- PENCERE KURALLARI ---
windowrulev2 = float, class:^(thunar)$
windowrulev2 = fullscreen, class:^(firefox)$, title:^()$

env = GTK_THEME,Adwaita:dark
env = QT_STYLE_OVERRIDE,Adwaita-Dark
exec-once = gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
exec-once = gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
EOF
}

# Waybar config yükle
setup_waybar() {
    log "Waybar config yükleniyor..."
    
    # Ana config
    cat > ~/.config/waybar/config.jsonc << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 28,
    "spacing": 4,
    
    "font-family": "Terminus, FontAwesome, JoyPixels, Noto Color Emoji, monospace",
    "font-size": 14,

    "modules-left": [
        "hyprland/workspaces"
    ],
    "modules-center": [
        "clock"
    ],
    "modules-right": [
        "cpu",
        "memory",
        "temperature", 
        "battery",
        "network",
        "pulseaudio",
        "tray"
    ],

    // ====================== WORKSPACES ======================
    "hyprland/workspaces": {
        "disable-scroll": false,
        "on-scroll-up": "hyprctl dispatch workspace e-1",
        "on-scroll-down": "hyprctl dispatch workspace e+1",
        "all-outputs": true,
        "active-only": false,
        "sort-by-number": true,
        "format": "{icon}",
        "on-click": "activate",
        "persistent-workspaces": {
            "*": [1, 2, 3, 4, 5]
        },
        "format-icons": {
            "1": "🖥️ 1",
            "2": "📁 2", 
            "3": "🌐 3",
            "4": "📝 4",
            "5": "🎵 5",
            "6": "🎮 6",
            "7": "📷 7",
            "8": "🔧 8",
            "9": "📚 9",
            "10": "⭐ 10",
            "focused": "🚀 {name}",
            "default": "○ {name}"
        }
    },

    // ====================== SES MODÜLÜ ======================
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "🔇 Muted",
        "format-icons": {
            "headphone": "🎧",
            "hands-free": "📱", 
            "headset": "🎮",
            "phone": "📞",
            "portable": "🔋",
            "car": "🚗",
            "default": ["🔈", "🔉", "🔊"]
        },
        "on-click": "pavucontrol",
        "scroll-step": 5,
        "tooltip-format": "{desc} • {volume}%"
    },

    // ====================== SAAT ======================
    "clock": {
        "format": "🕒 {:%H:%M}",
        "tooltip-format": "{:%Y-%m-%d %A}"
    },

    // ====================== CPU ======================
    "cpu": {
        "format": "🖥️ {usage}%",
        "tooltip": false
    },

    // ====================== BELLEK ======================
    "memory": {
        "format": "💾 {percentage}%",
        "tooltip": false
    },

    // ====================== SICAKLIK ======================
    "temperature": {
        "format": "🌡️ {temperatureC}°C",
        "critical-threshold": 80,
        "tooltip": false
    },

    // ====================== BATARYA ======================
    "battery": {
        "bat": "BAT0",
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "⚡ {capacity}%",
        "format-plugged": "🔌 {capacity}%",
        "format-icons": ["🪫", "🔋", "🔋", "🔋", "🔋", "🔋", "🔋", "🔋", "🔋", "🔋", "🔋"],
        "tooltip": false,
        "on-scroll-up": "brightnessctl set 5%+",
        "on-scroll-down": "brightnessctl set 5%-"
    },

    // ====================== AĞ ======================
    "network": {
        "format-wifi": "📶 {essid} ({signalStrength}%)",
        "format-ethernet": "🔌 Ethernet",
        "format-disconnected": "❌ Disconnected",
        "tooltip": false
    },

    // ====================== TRAY ======================
    "tray": {
        "spacing": 8,
        "icon-size": 16
    }
}
EOF

    # Waybar CSS
    cat > ~/.config/waybar/style.css << 'EOF'
/* ====================== KOMPAK + TERMINUS ====================== */
* {
    font-family: Terminus, FontAwesome, JoyPixels, Noto Color Emoji, monospace;
    font-size: 14px;
    color: #cdd6f4;
    padding: 0 4px;
    margin: 0 1px;
    border-radius: 4px;
}

window#waybar {
    background: rgba(30, 30, 46, 0.8);
    border-bottom: 1px solid #89b4fa;
}

/* ====================== WORKSPACES ====================== */
#workspaces button {
    padding: 0 10px;
    margin: 0 3px;
    min-width: 24px;
    background: rgba(40, 40, 60, 0.7);
    color: #94e2d5;
    border-radius: 6px;
    font-weight: bold;
    transition: all 0.2s ease;
}

#workspaces button.active {
    background: linear-gradient(45deg, #89b4fa, #cba6f7);
    color: #1e1e2e;
    font-weight: bold;
    border: 2px solid #f5c2e7;
    box-shadow: 0 0 8px rgba(203, 166, 247, 0.5);
}

#workspaces button.visible {
    background: #74c7ec;
    color: #1e1e2e;
    border: 1px solid #89b4fa;
}

#workspaces button:hover {
    background: #878787;
    color: #1e1e2e;
}

#workspaces button.active:hover {
    background: linear-gradient(45deg, #f5c2e7, #cba6f7);
    border-color: #f38ba8;
}

#workspaces button.urgent {
    background: #f38ba8;
    color: #1e1e2e;
    font-weight: bold;
    border: 2px solid #eba0ac;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.7; }
    100% { opacity: 1; }
}

/* ====================== SES MODÜLÜ – PULSEAUDIO ====================== */
#pulseaudio {
    background: rgba(40, 40, 60, 0.7);
    color: #cdd6f4;
    padding: 0 8px;
    margin: 0 2px;
    border-radius: 4px;
    min-width: 50px;
}

#pulseaudio.muted {
    color: #f38ba8;
    text-decoration: line-through;
}

/* ====================== DİĞER MODÜLLER ====================== */
#clock, #cpu, #memory, #temperature, #battery, #network, #tray {
    background: rgba(40, 40, 60, 0.7);
    color: #cdd6f4;
    padding: 0 8px;
    margin: 0 2px;
    border-radius: 4px;
    min-width: 50px;
}

/* ====================== BATARYA UYARILARI ====================== */
#battery.warning {
    color: #f9e2af;
}

#battery.critical {
    color: #f38ba8;
    animation: blink 1s linear infinite;
}

@keyframes blink {
    50% { opacity: 0.5; }
}

/* ====================== SICAKLIK UYARILARI ====================== */
#temperature.critical {
    color: #f38ba8;
    animation: blink 1s linear infinite;
}

/* ====================== TRAY ====================== */
#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background: #f38ba8;
}
EOF

    # Volume script
    cat > ~/.config/waybar/scripts/volume.sh << 'EOF'
#!/bin/bash

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

if [[ "$VOLUME" == *"MUTED"* ]]; then
    echo '{"text": "MUTED", "class": "muted"}'
else
    PERCENT=$(echo "$VOLUME" | awk '{printf "%.0f", $2 * 100}')
    if (( PERCENT == 0 )); then
        ICON="Low"
    elif (( PERCENT < 50 )); then
        ICON="Half"
    else
        ICON="Full"
    fi
    echo "{\"text\": \"$ICON $PERCENT%\", \"percentage\": $PERCENT}"
fi
EOF

    chmod +x ~/.config/waybar/scripts/volume.sh
}

# Kitty config yükle
setup_kitty() {
    log "Kitty config yükleniyor..."
    
    cat > ~/.config/kitty/kitty.conf << 'EOF'
font_family Terminus
font_size 18
background #1e1e2e
foreground #cdd6f4
cursor #f5e0dc
color0 #45475a
color1 #f38ba8
color2 #a6e3a1
color3 #f9e2af
color4 #89b4fa
color5 #f5c2e7
color6 #94e2d5
color7 #bac2de
EOF
}

# Wofi config yükle
setup_wofi() {
    log "Wofi config yükleniyor..."
    
    cat > ~/.config/wofi/style.css << 'EOF'
window { margin: 0px; border: 2px solid #bd93f9; background-color: rgba(40,42,54,0.95); border-radius: 12px; font-family: "Terminus", monospace; font-size: 14px; }
#input { margin: 10px; padding: 12px; border: none; color: #f8f8f2; background-color: #44475a; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.5); }
#input:focus { outline: none; border: 2px solid #bd93f9; }
#inner-box { margin: 10px; }
#entry { padding: 10px; margin: 2px 8px; border-radius: 8px; color: #f8f8f2; background-color: #44475a; }
#entry:selected { background-color: #6272a4; font-weight: bold; }
#text { margin: 5px; color: #f8f8f2; }
#img { margin-right: 10px; }
* { transition: all 0.2s ease; }
EOF
}

# Servisleri başlat
start_services() {
    log "Servisler başlatılıyor..."
    
    # Polkit agent (gerekli yetkilendirmeler için)
    if command -v /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &> /dev/null; then
        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    fi
}

# Kurulumu tamamla
complete_setup() {
    echo -e "${GREEN}"
    echo "================================================"
    echo "   KURULUM TAMAMLANDI! 🎉"
    echo "   FEVKALADENİN FEVKİNDE HYPRLAND HAZIR!"
    echo "================================================"
    echo -e "${NC}"
    
    echo -e "${YELLOW}Sonraki adımlar:${NC}"
    echo "1. Oturumu kapatıp tekrar giriş yapın"
    echo "2. Veya: hyprctl reload && pkill waybar && waybar"
    echo ""
    echo -e "${BLUE}Özellikler:${NC}"
    echo "✅ Workspace'ler: Emoji + rakamlarla okunaklı"
    echo "✅ Battery: Fare tekerleği ile parlaklık kontrolü"
    echo "✅ Ses: Tekerlekle ses ayarı"
    echo "✅ Tüm modüller: İkonlarıyla çalışıyor"
    echo "✅ Catppuccin teması: Şık görünüm"
    echo ""
    echo -e "${GREEN}Hayırlı olsun üstad! 🚀${NC}"
}

# Ana kurulum fonksiyonu
main() {
    log "Kurulum başlatılıyor..."
    
    # Backup al
    backup_config "$HOME/.config/hypr"
    backup_config "$HOME/.config/waybar"
    backup_config "$HOME/.config/kitty"
    backup_config "$HOME/.config/wofi"
    
    # Paketleri yükle
    install_packages
    
    # Dizinleri oluştur
    create_directories
    
    # Config'leri yükle
    setup_hyprland
    setup_waybar
    setup_kitty
    setup_wofi
    
    # Servisleri başlat
    start_services
    
    # Tamamlandı
    complete_setup
}

# Scripti çalıştır
main "$@"
