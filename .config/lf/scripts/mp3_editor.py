#!/usr/bin/env python3
import sys
import os
import curses
import argparse
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TRCK, TPE1, TIT2, TALB, TDRC, error

class Song:
    """Şarkı verilerini tutar."""
    def __init__(self, filepath):
        self.filepath = filepath
        self.filename = os.path.basename(filepath)
        self.tags = self._read_tags()

    def _read_tags(self):
        try:
            audio = MP3(self.filepath, ID3=ID3)
            track_raw = str(audio.get("TRCK", ""))
            track_num = track_raw.split('/')[0] if track_raw else ""
            
            return {
                "track": track_num,
                "title": str(audio.get("TIT2", "")),
                "artist": str(audio.get("TPE1", "")),
                "album": str(audio.get("TALB", "")),
                "year": str(audio.get("TDRC", ""))[:4]
            }
        except Exception:
            return {"track": "", "title": "OKUNAMADI", "artist": "", "album": "", "year": ""}

    def save_track_number(self, new_track_num):
        try:
            audio = MP3(self.filepath, ID3=ID3)
            audio.tags.add(TRCK(encoding=3, text=str(new_track_num)))
            audio.save()
            return True
        except Exception:
            return False

class InteractiveSorter:
    def __init__(self, songs):
        self.songs = songs
        self.current_row = 0
        self.current_col = 0
        self.columns = ["track", "artist", "title", "album"]
        self.col_headers = ["Trk", "Artist", "Title", "Album"]
        self.col_widths = [6, 20, 30, 20]
        
    def run(self, stdscr):
        # Curses Ayarları
        self.stdscr = stdscr
        curses.curs_set(0) # İmleci gizle
        stdscr.keypad(True) # Özel tuşları aktif et
        
        # Renkleri başlat (Güvenli mod)
        if curses.has_colors():
            curses.start_color()
            curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_CYAN) # Seçili satır rengi
        
        self.main_loop()

    def main_loop(self):
        while True:
            self.draw_screen()
            key = self.stdscr.getch()
            
            # --- Navigasyon ---
            if key == ord('j') or key == curses.KEY_DOWN:
                if self.current_row < len(self.songs) - 1: self.current_row += 1
            elif key == ord('k') or key == curses.KEY_UP:
                if self.current_row > 0: self.current_row -= 1
            
            # --- Sütun Değiştirme (h/l) ---
            elif key == ord('h') or key == curses.KEY_LEFT:
                if self.current_col > 0: self.current_col -= 1
            elif key == ord('l') or key == curses.KEY_RIGHT:
                if self.current_col < len(self.columns) - 1: self.current_col += 1
            
            # --- Taşıma (m: yukarı, n: aşağı) ---
            elif key == ord('m'): # Yukarı taşı
                if self.current_row > 0:
                    self.swap(self.current_row, self.current_row - 1)
                    self.current_row -= 1
            elif key == ord('n'): # Aşağı taşı
                if self.current_row < len(self.songs) - 1:
                    self.swap(self.current_row, self.current_row + 1)
                    self.current_row += 1
            
            # --- Sıralama (s) ---
            elif key == ord('s'):
                self.sort_by_column()
            
            # --- Kaydet ve Çık (Enter) ---
            elif key == curses.KEY_ENTER or key == 10: # 10 = Enter
                self.save_changes()
                break
            
            # --- İptal (q) ---
            elif key == ord('q'):
                break

    def swap(self, idx1, idx2):
        self.songs[idx1], self.songs[idx2] = self.songs[idx2], self.songs[idx1]

    def sort_by_column(self):
        col_key = self.columns[self.current_col]
        self.songs.sort(key=lambda s: s.tags.get(col_key, "") or "zzz")
        self.current_row = 0

    def save_changes(self):
        self.stdscr.clear()
        self.stdscr.addstr(0, 0, "Kayıt yapılıyor...", curses.A_BOLD)
        self.stdscr.refresh()
        
        for i, song in enumerate(self.songs):
            new_track = i + 1
            msg = f"[{i+1}/{len(self.songs)}] {song.filename}"
            try:
                song.save_track_number(new_track)
                self.stdscr.addstr(i+2, 0, msg + " -> OK", curses.A_NORMAL)
            except:
                self.stdscr.addstr(i+2, 0, msg + " -> HATA", curses.A_BOLD)
            
            if i > 20: break # Ekran taşıyacağı için altını kesiyoruz
            
        self.stdscr.addstr(23, 0, "Tamamlandı. Çıkmak için bir tuşa basın.")
        self.stdscr.getch()

    def draw_screen(self):
        self.stdscr.clear()
        h, w = self.stdscr.getmaxyx()
        
        # Başlık
        header_text = "SIRALAMA (m:Yukarı, n:Aşağı, h/l:Sütun, s:Sırala, Ent:Kaydet)"
        self.stdscr.addstr(0, 0, header_text.center(w), curses.A_REVERSE)
        
        # Sütun Başlıkları
        x_offset = 5
        for idx, header in enumerate(self.col_headers):
            style = curses.A_UNDERLINE | curses.A_BOLD
            if idx == self.current_col:
                style |= curses.A_REVERSE # Aktif sütun başlığı ters renk
            
            self.stdscr.addstr(2, x_offset, header.ljust(self.col_widths[idx]), style)
            x_offset += self.col_widths[idx]

        # Şarkı Listesi
        for i, song in enumerate(self.songs):
            if i >= h - 4: break
            
            row_style = curses.A_REVERSE if i == self.current_row else curses.A_NORMAL
            
            self.stdscr.addstr(i + 3, 0, f"{i+1:02}:", row_style)
            
            x_offset = 5
            values = [
                song.tags['track'],
                song.tags['artist'][:self.col_widths[0]-1],
                song.tags['title'][:self.col_widths[1]-1],
                song.tags['album'][:self.col_widths[2]-1]
            ]
            
            for c_idx, val in enumerate(values):
                # Hücre stili
                if i == self.current_row and c_idx == self.current_col:
                    # Aktif hücre (imleç)
                    style = curses.color_pair(1) if curses.has_colors() else curses.A_UNDERLINE
                else:
                    style = row_style
                
                try:
                    self.stdscr.addstr(i + 3, x_offset, val.ljust(self.col_widths[c_idx]), style)
                except curses.error:
                    pass # Ekran boyutu yetmezse hata vermesin
                x_offset += self.col_widths[c_idx]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("files", nargs="*", help="Seçili dosyalar")
    args = parser.parse_args()

    # MP3 kontrolü
    mp3_files = [f for f in args.files if f.lower().endswith(".mp3")]
    if not mp3_files:
        # Hata mesajını lf içinde görmek için basit bir input bekleyebiliriz
        print("MP3 dosyası seçili değil!")
        return

    songs = [Song(f) for f in mp3_files]
    app = InteractiveSorter(songs)
    curses.wrapper(app.run)

if __name__ == "__main__":
    main()
