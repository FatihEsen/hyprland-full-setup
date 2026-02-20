# .local/bin Skriptleri

Bu dizin, sistemdeki çeşitli özel işlevleri ve araçları barındıran kullanıcı betiklerini içerir.

## Betik Listesi ve Açıklamalar

| Betik | Açıklama | Tetikleyici / Kısayol |
| :--- | :--- | :--- |
| `antigravity` | Antigravity editörünü başlatan ana betik. | `antigravity [dosya]` |
| `get-music-info.sh` | Mevcut çalan müziğin bilgilerini getirir. | Waybar veya terminal üzerinden. |
| `hyprgrass-pinch-handler` | Parmak kıstırma ile kenarlık boyutunu ayarlar. | Dokunmatik ekran: 3/4 Parmak kıstırma. |
| `hyprgrass-swipe-handler` | Kaydırma ile çalışma alanları arası geçiş yapar. | Dokunmatik ekran: 3 Parmak kaydırma. |
| `hyprlock-wrapper` | Akıllı ekran kilitleyici (parlaklık & müzik yönetimi). | `SUPER + L` veya Boşta kalma (Idle). |
| `ncmpcpp-cover` | Albüm kapaklı müzik çalar. | `ncmpcpp-cover` |
| `nctaged` | `nctaged` Python uygulaması sarıcısı. | `nctaged` |
| `qodercli` | Qoder CLI aracı. | `qodercli` |
| `scratchpad` | Özel hızlı erişim terminali. | `SUPER + U` |
| `set-gtk-theme.sh` | GTK temalarını sisteme uygular. | Sistem açılışında otomatik. |
| `sysclean` | Arch Linux sistem temizlik betiği. | `sysclean` (sudo yetkisi ister). |
| `toggle-lock-music` | Kilit ekranında müzik devamlılık ayarı. | `SUPER + M` |

## Kullanım
Bu dizin `$PATH` değişkeninizde tanımlı olmalıdır. Böylece terminal üzerinden doğrudan komut ismiyle çalıştırılabilirler.
