
![Hyprland Screenshot](https://github.com/FatihEsen/hyprland-full-setup/blob/main/screenshots/hyprland-full.png)  


Hyprland Setup - Fevkaladenin Fevkinde! 🚀

![Hyprland Screenshot](https://github.com/FatihEsen/hyprland-full-setup/blob/main/screenshots/hyprland-full.png)  

📋 İçindekiler

    Özellikler

    Hızlı Kurulum

    Tuş Atamaları

    Workspace Yapısı

    Ekran Görüntüleri

    Sık Kullanılan Komutlar

✨ Özellikler
🎨 Görsel & Tema

    Catppuccin Macchiato renk teması

    Terminus font ailesi

    Emoji & İkon desteği (FontAwesome, JoyPixels, Noto Emoji)

    Blur efektleri ve yuvarlak köşeler

    Animasyonlu workspace geçişleri

🛠️ Fonksiyonellik

    Fare tekerleği ile parlaklık kontrolü (Battery modülü üzerinde)

    Fare tekerleği ile ses kontrolü

    Workspace scroll ile hızlı geçiş

    Emoji ile workspace'ler - görsel ve okunaklı

    Parlaklık kontrolü - hem tuş hem fare

    Ekran görüntüsü - tam ekran ve bölge seçimi

📦 Entegre Uygulamalar

    Waybar - özelleştirilmiş status bar

    Kitty - terminal emülatörü

    Wofi - uygulama başlatıcı

    Thunar - dosya yöneticisi

    Firefox - web tarayıcı

    Neovim - metin editörü

🚀 Hızlı Kurulum
Ön Koşullar

    Arch Linux veya EndeavourOS

    Hyprland (Wayland compositor)

Otomatik Kurulum
bash

# Scripti indir ve çalıştır
curl -LO https://raw.githubusercontent.com/FatihEsen/hyprland-full-setup/refs/heads/main/hyprland-full-setup.sh
chmod +x hyprland-setup.sh
./hyprland-setup.sh

Manuel Kurulum
bash

# Gerekli paketleri yükle
sudo pacman -S --needed hyprland waybar dunst kitty thunar firefox wofi neovim \
    brightnessctl grim slurp wl-clipboard cliphist pavucontrol \
    ttf-terminus-nerd ttf-font-awesome ttf-joypixels noto-fonts-emoji

# Config dosyalarını kopyala
cp -r hypr/ ~/.config/
cp -r waybar/ ~/.config/
cp -r kitty/ ~/.config/
cp -r wofi/ ~/.config/

# Waybar script'ini çalıştırılabilir yap
chmod +x ~/.config/waybar/scripts/volume.sh

⌨️ Tuş Atamaları
Temel Tuş Kombinasyonları
Tuş	Aksiyon	Açıklama
SUPER + Enter	Kitty terminal	Terminal aç
SUPER + Q	Pencere kapat	Aktif pencereyi kapat
SUPER + E	Thunar	Dosya yöneticisi
SUPER + B	Firefox	Web tarayıcı
SUPER + R	Wofi	Uygulama başlatıcı
SUPER + N	Neovim	Metin editörü
Pencere Yönetimi
Tuş	Aksiyon	Açıklama
SUPER + V	Pencere yüzdürme	Pencereyi yüzdür/durdur
SUPER + F	Tam ekran	Pencere tam ekran
SUPER + Shift + F	Gerçek tam ekran	Gerçek tam ekran modu
SUPER + P	Pseduo	Pseduo tam ekran
Workspace Yönetimi
Tuş	Aksiyon	Açıklama
SUPER + 1-0	Workspace geçiş	1-10 workspace'ler
SUPER + Shift + 1-0	Pencere taşı	Pencereyi workspace'e taşı
Fare Tekerleği (Waybar)	Workspace geçiş	Waybar üzerinde scroll
Pencere Odak & Taşıma
Tuş	Aksiyon	Açıklama
SUPER + ←→↑↓	Odak değiştir	Pencere odaklama
SUPER + Shift + ←→↑↓	Pencere taşı	Pencereyi taşı
SUPER + Mouse	Sürükle & Boyutlandır	Fare ile pencere kontrolü
Medya & Sistem Kontrolleri
Tuş	Aksiyon	Açıklama
Volume Up/Down	Ses ayarı	Ses seviyesi %5
Volume Mute	Sessiz	Sesi aç/kapat
Brightness Up/Down	Parlaklık	Ekran parlaklığı %5
Print Screen	Ekran görüntüsü	Tam ekran görüntü
Shift + Print	Bölge ekran görüntüsü	Seçilen bölge görüntüsü
Fare Kontrolleri
Element	Aksiyon	Açıklama
Battery Modülü	Tekerlek	Parlaklık kontrolü
Ses Modülü	Tekerlek	Ses seviyesi kontrolü
Workspace'ler	Tekerlek	Workspace geçişi
🗂️ Workspace Yapısı
Workspace	Emoji	Amaç
1	🖥️	Masaüstü & Ana çalışma
2	📁	Dosya yönetimi & Dosyalar
3	🌐	Web tarama & İnternet
4	📝	Notlar & Dokümantasyon
5	🎵	Müzik & Ses uygulamaları
6	🎮	Oyun & Eğlence
7	📷	Medya & Görüntü işleme
8	🔧	Araçlar & Sistem
9	📚	Belgeler & Kitaplar
10	⭐	Önemli & Sık kullanılan

Aktif Workspace: 🚀 roket emojisi ile vurgulanır
🖼️ Ekran Görüntüleri
text

[Waybar] - Catppuccin temalı, emoji workspace'li
[Workspace'ler] - Renkli gradient vurgulu
[Terminal] - Kitty ile Catppuccin teması
[Uygulama Başlatıcı] - Wofi ile koyu tema

🔧 Sık Kullanılan Komutlar
Hyprland Kontrolleri
bash

# Config reload
hyprctl reload

# Mevcut workspace
hyprctl activeworkspace

# Tüm workspace'ler
hyprctl workspaces

# Pencere listesi
hyprctl clients

Sistem Kontrolleri
bash

# Ses kontrolü
wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Parlaklık kontrolü
brightnessctl set 5%+

# Ekran görüntüsü
grim - | wl-copy
grim -g "$(slurp)" - | wl-copy

Waybar Kontrolleri
bash

# Waybar'ı yeniden başlat
pkill waybar && waybar

# Waybar log'larını görüntüle
waybar -l debug

🐛 Sorun Giderme
Font Problemleri
bash

# Font'ları kontrol et
fc-list | grep -i "terminus\|fontawesome\|joypixels"

# Font cache'i yenile
fc-cache -fv

Waybar Çalışmıyorsa
bash

# Config syntax kontrolü
waybar -c ~/.config/waybar/config.jsonc

# Log'ları incele
journalctl -u waybar -f

Hyprland Problemleri
bash

# Hyprland log'ları
journalctl -u hyprland -f

# Config test
hyprctl keyword monitor ",preferred,auto,1"

🤝 Katkıda Bulunma

Bu setup'ı geliştirmek için:

    Fork yapın

    Feature branch oluşturun (git checkout -b feature/amazing-feature)

    Commit yapın (git commit -m 'Add amazing feature')

    Push yapın (git push origin feature/amazing-feature)

    Pull Request oluşturun

📜 Lisans

Bu proje MIT lisansı altında lisanslanmıştır - detaylar için LICENSE dosyasına bakın.
👨‍💻 Geliştirici

Fatih - Fevkaladenin Fevkinde Setup 🚀
