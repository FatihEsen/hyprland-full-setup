sudo pacman -Syu --noconfirm --needed \
    hyprland waybar kitty wofi neovim \
    pipewire pipewire-pulse wireplumber \
    dunst hyprpaper wl-clipboard cliphist \
    thunar firefox papirus-icon-theme \
    terminus-font xdg-desktop-portal-hyprland \
    qt5ct qt6ct brightnessctl grim slurp \
    wofi papirus-icon-theme

# --- 2. DİZİNLER ---
mkdir -p ~/.config/{hypr,waybar,kitty,wofi,nvim,hyprpaper}

# --- 3. HYPR LAND CONF ---
cat > ~/.config/hypr/hyprland.conf << 'EOF'
# ================================================
# HYPR LAND - TAM ÇALIŞIR KONFİG (2025)
# ================================================

$mainMod = SUPER

monitor=,preferred,auto,1

input {
    kb_layout = tr
    follow_mouse = 1
    touchpad { natural_scroll = yes }
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
    blur { enabled = true; size = 8; passes = 2; noise = 0.1; contrast = 1.2 }
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

exec-once = waybar &
exec-once = dunst &
exec-once = hyprpaper &
exec-once = wl-paste --watch cliphist store

bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

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

bind = $mainMod, Return, exec, kitty zsh
bind = $mainMod, Q, killactive
bind = $mainMod, E, exec, thunar
bind = $mainMod, B, exec, firefox
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, N, exec, kitty -e nvim

bind = $mainMod, V, togglefloating
bind = $mainMod, F, fullscreen, 0
bind = $mainMod SHIFT, F, fullscreen, 1
bind = $mainMod, P, pseudo

bind = $mainMod, left,  movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up,    movefocus, u
bind = $mainMod, down,  movefocus, d
bind = $mainMod SHIFT, left,  movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up,    movewindow, u
bind = $mainMod SHIFT, down,  movewindow, d

bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
bind = , Print, exec, grim - | wl-copy && notify-send "Ekran görüntüsü panoya kopyalandı"
bind = SHIFT, Print, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Bölge panoya kopyalandı"

windowrulev2 = float, class:^(thunar)$
windowrulev2 = fullscreen, class:^(firefox)$, title:^()$

env = GTK_THEME,Adwaita:dark
env = QT_STYLE_OVERRIDE,Adwaita-Dark
exec-once = gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
exec-once = gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
EOF

# --- 4. WAYBAR CONFIG ---
cat > ~/.config/waybar/config.jsonc << 'EOF'
{
    "layer": "top", "position": "top", "height": 30, "spacing": 4,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-right": ["cpu", "memory", "temperature", "battery", "network", "custom/volume", "clock", "tray"],

    "hyprland/workspaces": {
        "format": "{name}",
        "format-icons": { "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", "10": "10" },
        "on-click": "hyprctl dispatch workspace {name}",
        "on-scroll-up": "hyprctl dispatch workspace prev",
        "on-scroll-down": "hyprctl dispatch workspace next",
        "all-outputs": true, "show-special": false, "sort-by-name": true, "hide-empty": true
    },

    "hyprland/window": { "max-length": 50, "separate-outputs": true },
    "clock": { "format": "{:%H:%M  %d/%m/%Y}", "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>", "interval": 60 },
    "cpu": { "format": "CPU {usage}%", "interval": 2 },
    "memory": { "format": "RAM {}%", "interval": 5 },
    "temperature": { "hwmon-path": "/sys/class/hwmon/hwmon*/temp1_input", "critical-threshold": 80, "format": "{temperatureC}°C", "interval": 5 },
    "battery": { "bat": "BAT0", "states": { "warning": 30, "critical": 15 }, "format": "{capacity}% {icon}", "format-charging": "{capacity}% Charging", "format-icons": ["Low", "Half", "Full"] },
    "network": { "interface": "wlan0", "format-wifi": "WiFi {essid} ({signalStrength}%)", "format-disconnected": "Disconnected", "interval": 5 },
    "tray": { "icon-size": 18, "spacing": 10 },

    "custom/volume": {
        "format": "{text}", "format-muted": "MUTED",
        "exec": "~/.config/waybar/scripts/volume.sh", "return-type": "json", "interval": 1,
        "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "on-click-right": "pavucontrol &",
        "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
        "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    }
}
EOF

# --- 5. WAYBAR STYLE (Terminus + Kompak) ---
cat > ~/.config/waybar/style.css << 'EOF'
* { font-family: Terminus, monospace; font-size: 14px; color: #cdd6f4; padding: 0 4px; margin: 0 1px; border-radius: 4px; }
window#waybar { background: rgba(30,30,46,0.8); border-bottom: 1px solid #89b4fa; }
#workspaces button { padding: 0 6px; margin: 0 1px; min-width: 20px; background: rgba(40,40,60,0.7); color: #94e2d5; border-radius: 4px; }
#workspaces button.focused { background: #89b4fa; color: #1e1e2e; font-weight: bold; }
#clock, #cpu, #memory, #temperature, #battery, #network, #custom-volume, #tray { background: rgba(40,40,60,0.7); color: #cdd6f4; padding: 0 8px; margin: 0 2px; border-radius: 4px; min-width: 50px; }
#custom-volume.muted { color: #f38ba8; }
EOF

# --- 6. VOLUME SCRIPT ---
mkdir -p ~/.config/waybar/scripts
cat > ~/.config/waybar/scripts/volume.sh << 'EOF'
#!/bin/bash
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
if [[ "$VOLUME" == *"MUTED"* ]]; then
    echo '{"text": "MUTED", "class": "muted"}'
else
    PERCENT=$(echo "$VOLUME" | awk '{printf "%.0f", $2 * 100}')
    if (( PERCENT == 0 )); then ICON="Low"; CLASS="low"
    elif (( PERCENT < 50 )); then ICON="Half"; CLASS="half"
    else ICON="Full"; CLASS="full"; fi
    echo "{\"text\": \"$ICON $PERCENT%\", \"class\": \"$CLASS\"}"
fi
EOF
chmod +x ~/.config/waybar/scripts/volume.sh

# --- 7. KITTY ---
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

# --- 8. WOFI ---
mkdir -p ~/.config/wofi
cat > ~/.config/wofi/config << 'EOF'
width=500
height=400
location=center
prompt=Search
allow_images=true
image_size=32
font=Terminus 14
allow_markup=true
term=kitty
EOF

cat > ~/.config/wofi/style.css << 'EOF'
window { margin: 0px; border: 2px solid #bd93f9; background-color: rgba(40,42,54,0.95); border-radius: 12px; font-family: "Terminus", monospace; font-size: 14px; }
#input { margin: 10px; padding: 12px; border: none; color: #f8f8f2; background-color: #44475a; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.5); }
#input:focus { outline: none; border: 2px solid #bd93f9; }
#entry { padding: 10px; margin: 2px 8px; border-radius: 8px; color: #f8f8f2; background-color: #44475a; }
#entry:selected { background-color: #6272a4; font-weight: bold; }
#text { margin: 5px; color: #f8f8f2; }
#img { margin-right: 10px; }
* { transition: all 0.2s ease; }
EOF

# --- 9. NEOVIM ALIAS ---
echo "alias vim='nvim'" >> ~/.bashrc
echo "alias vim='nvim'" >> ~/.zshrc

# --- 10. YENİDEN BAŞLAT ---
echo "Tüm konfigürasyonlar yüklendi!"
echo "Waybar ve Hyprland yeniden başlatılıyor..."
pkill waybar || true
waybar &
hyprctl reload

echo "KURULUM TAMAM! SUPER + R ile Wofi, SUPER + Return ile Kitty aç."
echo "Script bitti. Keyfini çıkar kral!"
