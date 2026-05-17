# 🚀 Hyprland Full Setup - Premium Dotfiles

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blueviolet?style=for-the-badge&logo=arch-linux)
![Distro](https://img.shields.io/badge/Distro-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux)
![Shell](https://img.shields.io/badge/Shell-Zsh-F15A24?style=for-the-badge&logo=zsh)

Bu depo, modern, estetik ve performans odaklı bir **Arch Linux (Hyprland)** deneyimi sunmak için titizlikle hazırlanmış konfigürasyon dosyalarını içerir. Sadece görsellik değil, işlevsellik ve enerji yönetimi de ön planda tutulmuştur.

---

## ✨ Öne Çıkan Özellikler

- **🎨 Dinamik Estetik:** Catppuccin Mocha tabanlı, göz yormayan ve modern bir arayüz.
- **🔋 Akıllı Güç Yönetimi:** 
  - 2.5 dk: Ekran karartma (%10 parlaklık).
  - 5.0 dk: Otomatik kilitleme (`hyprlock`).
  - 5.5 dk: Monitör uyku modu (DPMS off).
  - 30 dk: Sistemi askıya alma (Suspend).
- **🔒 Gelişmiş Kilit Ekranı:** `hyprlock-wrapper` ile akıllı parlaklık yönetimi ve medya kontrolleri. Kilit açıldığında parlaklık otomatik olarak eski haline döner.
- **🎵 Medya Entegrasyonu:** `SUPER+M` ile kilit ekranında müzik çalmaya devam etme veya otomatik durdurma modu.
- **⚡ Yüksek Performans:** VFR (Variable Frame Rate) etkin, düşük gecikmeli ve akıcı animasyonlar.
- **🛠️ Hazır Araçlar:** 
  - Emoji seçici, Pano geçmişi (Cliphist), Scratchpad (Yüzer notlar/terminal).
  - Resim içinde Resim (PiP) modu için özel `SUPER+Y` kısayolu.

---

## ⌨️ Temel Kısayollar

| Kısayol | İşlem |
| :--- | :--- |
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + Q` | Uygulamayı Kapat |
| `SUPER + D` | Uygulama Menüsü (Wofi) |
| `SUPER + E` | Dosya Yöneticisi (Thunar) |
| `SUPER + X` | Ekranı Kilitle |
| `SUPER + M` | Müzik Kilit Modu (Aç/Kapat) |
| `SUPER + Y` | PiP Modu (Sabitle & Boyutlandır) |
| `SUPER + H` | Pano Geçmişi (Cliphist) |
| `SUPER + U` | Scratchpad / Hızlı Notlar |
| `SUPER + B` | Web Tarayıcı (Firefox) |
| `SUPER + ALT + R` | Waybar'ı Yenile |
| `Print` | Ekran Görüntüsü (Tam Ekran) |
| `SHIFT + Print` | Ekran Görüntüsü (Alan Seçimi) |

---

## 🚀 Kurulum

Bu kurulum süreci **interaktiftir**; her adımda onayınız istenir. Script sırasıyla şunları yapar:
1. Temel araçları kontrol eder ve gerekirse `yay` (AUR yardımcısı) kurar.
2. Resmi ve AUR paketlerini yükler.
3. Oh-My-Zsh kurulumunu yapar.
4. Yapılandırma dosyalarını (`~/.config`, `~/.local/bin`, `.zshrc`) yerleştirir.
5. Gerekli sistem servislerini ve grup yetkilerini ayarlar.

> **Uyarı:** Kurulum scripti mevcut konfigürasyonlarınızın üzerine yazabilir. Yedek almanız önerilir.

```bash
git clone https://github.com/fatih/hyprland-full-setup.git
cd hyprland-full-setup
chmod +x install.sh
./install.sh
```

### Gereksinimler
Sistemin tam işlevsel çalışması için şu paketlerin yüklü olması önerilir:
`hyprland`, `hyprlock`, `hypridle`, `waybar`, `swaync`, `wofi`, `kitty`, `thunar`, `brightnessctl`, `playerctl`, `grim`, `slurp`, `wl-clipboard`.

---

## 📸 Ekran Görüntüleri
*Ekran görüntüleri `screenshots/` dizini altında bulunmaktadır.*

---

**Crafted with ❤️ by Fatih**
