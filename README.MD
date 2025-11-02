# Hyprland Full Setup – 2025

> **Kompak, koyu, Terminus fontlu, tekerlekli, ikonlu, %100 çalışır Hyprland kurulumu**  
> **Tek bir `.sh` scriptiyle sıfırdan kur!**

![Hyprland Screenshot](https://github.com/FatihEsen/hyprland-full-setup/blob/main/screenshots/hyprland-full.png)  

---

## Özellikler

| Uygulama | Özellik |
|--------|--------|
| **Hyprland** | Koyu tema, blur, animasyon, 1-10 workspace |
| **Waybar** | Kompak, Terminus font, tekerlek ile workspace, boş workspace gizli |
| **Kitty** | Terminus 18, koyu tema (Catppuccin Mocha) |
| **Wofi** | Dracula tema, blur, ikonlu, Terminus font |
| **Neovim** | `vim` → `nvim` alias, koyu tema |
| **Ses** | Tekerlek + ikon + %, sessize al |
| **Medya Tuşları** | Ses, parlaklık, ekran görüntüsü |
| **Otomatik Koyu Tema** | GTK/Qt, Firefox, sistem genelinde |

---

## Kurulum (1 Komut)

```bash
# 1. Scripti indir
curl -LO https://raw.githubusercontent.com/fatihesen/hyprland-full-setup/main/hyprland-full-setup.sh

# 2. Çalıştır
chmod +x hyprland-full-setup.sh
./hyprland-full-setup.sh

    Not: sudo şifreni soracak (paket kurulumları için).
    Kurulum bittikten sonra oturumu kapat/aç veya hyprctl reload.

Gereksinimler

    Arch Linux (veya Arch tabanlı dağıtım)
    İnternet bağlantısı
    pacman (varsayılan)

Ne Yapar?

    Gerekli paketleri kurar (hyprland, waybar, kitty, wofi, neovim, pipewire, vs.)
    Tüm konfigürasyon dosyalarını yazar:
        ~/.config/hypr/hyprland.conf
        ~/.config/waybar/config.jsonc + style.css
        ~/.config/kitty/kitty.conf
        ~/.config/wofi/config + style.css
        ~/.config/waybar/scripts/volume.sh
    vim → nvim alias ekler
    Waybar ve Hyprland’i yeniden başlatır

Kısayollar
Tuş	İşlem
SUPER + Return	Kitty (zsh)
SUPER + R	Wofi (uygulama başlatıcı)
SUPER + Q	Aktif pencereyi kapat
SUPER + E	Thunar
SUPER + B	Firefox
SUPER + N	Neovim
SUPER + 1-0	Workspace 1-10
SUPER + Shift + 1-0	Pencereyi taşı
SUPER + Fare Tekerleği	Workspace değiştir
Fare Tekerleği (ses bloğu)	Ses artır/azalt
Print	Ekran görüntüsü (panoya)
Shift + Print	Bölge seç → panoya
Ekran Görüntüsü

![Hyprland Wofi Screenshot](https://github.com/FatihEsen/hyprland-full-setup/blob/main/screenshots/wofi1.png)  

bash

# Ekran görüntüsü al
grim - | wl-copy

Katkı Yap

    Forkla
    Değişiklik yap
    Pull Request gönder

Lisans

MIT License – İstediğin gibi kullan, paylaş, değiştir.
Teşekkür

    Hyprland
    Waybar
    Wofi
    Catppuccin
    @fatihesen – Bu repo’nun yaratıcısı

    "Hyprland kurmak 5 dakika, keyfini çıkarmak ömür boyu."
    – fatihesen
