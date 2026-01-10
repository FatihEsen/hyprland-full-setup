# Arch Linux Magic Setup (Dotfiles)

Bu depo, kişiselleştirilmiş bir Arch Linux (Hyprland odaklı) kurulumunu saniyeler içinde tamamlaman için hazırlanmıştır.

## 🚀 Neleri Kurar?

- **Pencere Yöneticisi:** Hyprland
- **Panel:** Waybar
- **Terminal:** Kitty
- **Editor:** Neovim
- **AUR Helper:** yay-bin (Hızlı kurulum için)
- **Dosya Yöneticisi:** Thunar & lf
- **Diğer:** swaync (Bildirim), wofi (Launcher), ncmpcpp (Müzik), cava (Görselleştirici), hypridle/hyprlock (Güvenlik)

## 🛠️ Nasıl Kullanılır?

Yeni kurulmuş bir Arch Linux sisteminde terminali açın ve şu adımları izleyin:

1.  **Klasöre giriş yapın:**
    ```bash
    cd ~/dotfiles
    ```

2.  **Scripti çalıştırılabilir yapın:**
    ```bash
    chmod +x install.sh
    ```

3.  **Setup'ı başlatın:**
    ```bash
    ./install.sh
    ```

4.  **Sistemi yeniden başlatın.**

## 📁 Dosya Yapısı

- `.config/`: Uygulama konfigürasyon dosyaları.
- `.local/bin/`: Özel scriptler ve kilit ekranı sarmalayıcıları.
- `install.sh`: Otomatik kurulum scripti.

## ⚠️ Önemli Notlar

- Script otomatik olarak `sudo` yetkisi isteyecektir.
- Mevcut bir sistemde çalıştırıyorsanız, `.config` klasörünüzdeki dosyaların üzerine yazılacağını unutmayın.
- Kurulumdan sonra kursor temasının ve fontların aktif olması için bir kez oturumu kapatıp açmanız önerilir.
