# 🧊 Arch Linux Magic Setup (Pure Wayland)

Bu depo, modern ve performanslı bir **Arch Linux (Hyprland)** kurulumunu dakikalar içinde tamamlamanız için optimize edilmiştir. Gereksiz bağımlılıklardan arındırılmış, tamamen Wayland tabanlı ve dinamik tema desteğiyle hazırlanmış bir sistem sunar.

## 🎨 Ekran Görüntüleri

<p align="center">
  <img src="screenshots/1.png" width="45%" alt="Masaüstü 1" />
  <img src="screenshots/2.png" width="45%" alt="Masaüstü 2" />
</p>
<p align="center">
  <img src="screenshots/3.png" width="45%" alt="Uygulamalar" />
  <img src="screenshots/4.png" width="45%" alt="Terminal" />
</p>

---

## 🚀 Öne Çıkan Özellikler

- **Pencere Yöneticisi:** [Hyprland](https://hyprland.org/) (Hızlı, akıcı ve özelleştirilebilir)
- **Panel & Bildirim:** Waybar & SwayNC (Modern ve minimalist)
- **Dinamik Tema Sistemi:** Birkaç saniye içinde Catppuccin ve Gruvbox temaları arasında geçiş yapabilen akıllı altyapı.
- **Akıllı Müzik Yönetimi:** Kilit ekranında (hyprlock) medya bilgisi ve kilitliyken medya kontrolü.
- **Terminal:** Kitty (GPU tabanlı performans)
- **Editor:** Neovim (Gelişmiş IDE deneyimi)
- **Yazılım Yönetimi:** `yay-bin` (Hızlı AUR erişimi)
- **Saf Wayland:** Xorg sunucusu içermeyen, tamamen modern protokoller üzerine kurulu yapı.

---

## 🛠️ Hızlı Kurulum

Yeni kurulmuş bir Arch Linux sisteminde şu adımları izleyin:

1.  **Depoyu Klonlayın & Klasöre Girin:**
    ```bash
    git clone https://github.com/FatihEsen/hyprland-full-setup.git ~/hyprland-full-setup
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
| `SUPER + ALT + T` | Tema Değiştirici (Catppuccin <-> Gruvbox) |
| `SUPER + M` | Müzik Kilit Modu (Pause/Play on Lock) |
| `SUPER + H` | Pano Geçmişi |
| `SUPER + ESC` | Güç Menüsü |
| `Medya Tuşları` | Kilitliyken de müzik kontrolü |

---

## 📁 Dosya Yapısı

- `.config/`: Uygulama konfigürasyonları (Hyprland, Waybar, Fastfetch vb.)
- `.local/bin/`: Özel scriptler (Tema değiştirici, Müzik kontrolü, Scratchpad vb.)
- `pkglist.txt`: Temel sistem paketleri (pavucontrol, polkit-agent, wl-clipboard vb.)
- `aurpkglist.txt`: AUR paketleri ve temalar.
- `install.sh`: Otomatik kurulum scripti.
- `backup.sh`: Güncel ayarlarınızı (spesifik paketleri filtreleyerek) yedekleme scripti.

---

## ⚠️ Önemli Notlar

- **Generic Yapı:** `inkscape`, `firefox` gibi spesifik kullanıcı tercihine bağlı paketler repo listesinden hariç tutulmuştur.
- **Yedekleme:** Mevcut bir sistemde kurulum yapıyorsanız `.config` klasörünüzün üzerine yazılacaktır.
- **Stabilite:** Kurulum bittikten sonra tam uyum için oturumu bir kez kapatıp açmanız önerilir.

---
<p align="center">Made with ❤️ for Arch Linux users.</p>
