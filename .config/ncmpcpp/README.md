# NCMPCPP - Gruvbox Premium Edition

## 🎨 Özellikler
- ✅ Tam Gruvbox renk teması (turuncu/sarı/kırmızı tonları)
- ✅ Gelişmiş Vim-tarzı tuş atamaları
- ✅ Spectrum görselleştirici (stereo)
- ✅ Albüm kapağı desteği (Kitty protokolü)
- ✅ Modern alternatif UI
- ✅ Özelleştirilmiş oynatma çubuğu

## 🚀 Kullanım

### Normal Başlatma
```bash
ncmpcpp
```

### Albüm Kapağı ile Başlatma
```bash
ncmpcpp-cover
```

## ⌨️ Önemli Tuş Atamaları

### Navigasyon (Vim Tarzı)
- `j/k` - Aşağı/Yukarı
- `h/l` - Sol/Sağ sütun
- `Ctrl+d/u` - Sayfa aşağı/yukarı
- `g/G` - Başa/Sona git

### Oynatma
- `Space` - Duraklat/Devam
- `>/<` - Sonraki/Önceki şarkı
- `=/−` - Ses arttır/azalt
- `r` - Tekrar modu
- `z` - Rastgele mod

### Ekranlar
- `1` - Playlist
- `2` - Tarayıcı
- `3` - Arama
- `4` - Kütüphane
- `5` - Playlist Editör
- `6` - Tag Editör
- `7` - Çıkışlar
- `8` - Görselleştirici
- `9` - Saat

### Görselleştirici
- `v` - Görselleştiriciyi göster
- `V` - Görselleştirici tipini değiştir

### Diğer
- `/` - Ara
- `u` - Veritabanını güncelle
- `q` - Çık
- `F1` - Yardım

## 📁 Dosya Yapısı
```
~/.config/ncmpcpp/
├── config          # Ana konfigürasyon (Gruvbox renkleri)
├── bindings        # Tuş atamaları
├── cover.sh        # Albüm kapağı gösterici
└── config.bak      # Yedek

~/.local/bin/
└── ncmpcpp-cover   # Kapak gösterimli başlatıcı
```

## 🎵 Albüm Kapağı
Albüm kapakları şu sırayla aranır:
1. `cover.jpg/png`
2. `folder.jpg/png`
3. `front.jpg/png`
4. `album.jpg/png`
5. Dosyaya gömülü kapak (ffmpeg ile çıkarılır)

Kapaklar `~/.cache/ncmpcpp/covers/` dizininde önbelleğe alınır.

## 🔧 MPD Bağlantısı
- Host: localhost
- Port: 6600
- FIFO: ~/.config/mpd/mpd.fifo
- Müzik Dizini: ~/Müzik

## 💡 İpuçları
- İlk başlatmada `u` tuşuna basarak müzik veritabanını güncelle
- Görselleştirici için MPD'nin FIFO çıkışı aktif olmalı
- Albüm kapakları için Kitty terminal gerekli
- Lyrics için `~/.lyrics` dizinine şarkı sözlerini koy

## 🎨 Renk Paleti (Gruvbox)
- Sarı/Turuncu: Ana vurgu rengi
- Kırmızı: Aktif öğeler
- Yeşil: Ses seviyesi
- Mavi: Zaman bilgisi
- Magenta/Cyan: İkincil bilgiler
