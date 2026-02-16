#!/bin/bash

# GTK temalarini ve ayarlarini gsettings'e aktarma betigi
# Bu betik Hyprland baslangicinda calistirilmalidir.

config_3="$HOME/.config/gtk-3.0/settings.ini"
config_4="$HOME/.config/gtk-4.0/settings.ini"

if [ -f "$config_3" ]; then
    theme=$(grep "^gtk-theme-name" "$config_3" | cut -d'=' -f2)
    icons=$(grep "^gtk-icon-theme-name" "$config_3" | cut -d'=' -f2)
    cursor=$(grep "^gtk-cursor-theme-name" "$config_3" | cut -d'=' -f2)
    font=$(grep "^gtk-font-name" "$config_3" | cut -d'=' -f2)

    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    gsettings set org.gnome.desktop.interface icon-theme "$icons"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
    gsettings set org.gnome.desktop.interface font-name "$font"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
fi
