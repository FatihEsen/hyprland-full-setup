# 🧊 Arch Linux Magic Setup (Pure Wayland)

Bu depo, modern ve performanslı bir **Arch Linux (Hyprland)** kurulumunu dakikalar içinde tamamlamanız için optimize edilmiştir. Gereksiz bağımlılıklardan arındırılmış, tamamen Wayland tabanlı ve "Catppuccin Mocha" estetiğiyle hazırlanmış bir sistem sunar.

## 🎨 Ekran Görüntüleri

<p align="center">
  <img src="screenshots/1.png" width="45%" alt="Masaüstü Görünümü" />
  <img src="screenshots/2.png" width="45%" alt="Terminal Görünümü" />
</p>

---

## 🚀 Öne Çıkan Özellikler

- **Pencere Yöneticisi:** [Hyprland](https://hyprland.org/) (Hızlı, akıcı ve özelleştirilebilir)
- **Panel & Bildirim:** Waybar & SwayNC (Modern ve minimalist)
- **Terminal:** Kitty (GPU tabanlı performans)
- **Editor:** Neovim (Gelişmiş IDE deneyimi)
- **Dosya Yönetimi:** Thunar & lf (Görsel ve terminal tabanlı)
- **Yazılım Yönetimi:** `yay-bin` (Hızlı AUR erişimi)
- **Saf Wayland:** Xorg sunucusu içermeyen, tamamen modern protokoller üzerine kurulu yapı.

---

## 🛠️ Hızlı Kurulum

Yeni kurulmuş bir Arch Linux sisteminde şu adımları izleyin:

1.  **Depoyu Klonlayın & Klasöre Girin:**
    ```bash
    git clone https://github.com/Fatih-fzh/hyprland-full-setup.git ~/hyprland-full-setup
    cd ~/hyprland-full-setup
    ```

2.  **Kurulumu Başlatın:**
    ```bash
    chmod +x install.sh
    ./install.sh
    ```

3.  **Sistemi Yeniden Başlatın.**

---

## ⌨️ Temel Kısayollar

`SUPER` tuşu genellikle **Windows** tuşudur.

| Kısayol | İşlem |
| :--- | :--- |
| `SUPER + Enter` | Kitty Terminal |
| `SUPER + Q` | Uygulamayı Kapat |
| `SUPER + D` | Uygulama Menüsü (Wofi) |
| `SUPER + E` | Dosya Yöneticisi |
| `SUPER + L` | Ekranı Kilitle |
| `SUPER + B` | Tarayıcı (Firefox) |
| `SUPER + H` | Pano Geçmişi |
| `SUPER + ESC` | Güç Menüsü |

---

## 📁 Dosya Yapısı

- `.config/`: Uygulama konfigürasyonları.
- `.local/bin/`: Özel scriptler (Scratchpad, kilit ekranı vb.)
- `pkglist.txt`: Resmi depo paketleri.
- `aurpkglist.txt`: AUR paketleri.
- `install.sh`: Otomatik kurulum scripti.
- `backup.sh`: Güncel ayarlarınızı depoya yedekleme scripti.

---

## ⚠️ Önemli Notlar

- Mevcut bir sistemde kurulum yapıyorsanız `.config` klasörünüzün üzerine yazılacaktır.
- Kurulum bittikten sonra tam uyum için oturumu bir kez kapatıp açmanız önerilir.

---
<p align="center">Made with ❤️ for Arch Linux users.</p>
