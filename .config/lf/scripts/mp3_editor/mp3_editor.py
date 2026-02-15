#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
LF MP3 Tag Editor - Terminal içinden MP3 etiket düzenleme aracı
Version: 0.2 (Dinamik Terminal Boyutu)
"""

import os
import sys
import argparse
import json
from pathlib import Path
from typing import List, Dict, Optional

# Proje modülleri
from core.tag_handler import TagHandler
from core.file_ops import FileOperations
from tui.menu import Menu
from utils.logger import Logger

class MP3Editor:
    """Ana uygulama sınıfı"""
    
    VERSION = "0.2.0"
    
    def __init__(self):
        self.tag_handler = TagHandler()
        self.file_ops = FileOperations()
        self.logger = Logger()
        self.files: List[str] = []
        self.mode: str = ""
        self.narrow_mode = False  # Dar ekran modu
        self.terminal_cols = 80   # Varsayılan
        
    def parse_arguments(self):
        """Komut satırı argümanlarını parse et"""
        parser = argparse.ArgumentParser(
            description='LF MP3 Tag Editor - MP3 etiket düzenleyici',
            formatter_class=argparse.RawDescriptionHelpFormatter,
            epilog="""
Örnek kullanım:
  python3 mp3_editor.py --mode=selected file1.mp3 file2.mp3
  python3 mp3_editor.py --mode=folder
  python3 mp3_editor.py --mode=sorter *.mp3
  python3 mp3_editor.py --mode=sorter --files="*.mp3"
  python3 mp3_editor.py --mode=selected --no-size-check *.mp3  # Boyut kontrolünü atla
            """
        )
        
        parser.add_argument(
            '--mode', 
            '-m',
            required=True,
            choices=['selected', 'folder', 'sorter'],
            help='Çalışma modu: selected (seçili), folder (klasör), sorter (sıralayıcı)'
        )
        
        parser.add_argument(
            'files',
            nargs='*',
            help='İşlenecek dosyalar (boşlukla ayrılmış)'
        )
        
        parser.add_argument(
            '--files',
            dest='files_arg',
            help='Tırnak içinde dosya listesi (örn: "*.mp3")'
        )
        
        parser.add_argument(
            '--version',
            action='version',
            version=f'MP3 Editor v{self.VERSION}'
        )
        
        parser.add_argument(
            '--debug',
            action='store_true',
            help='Hata ayıklama modu'
        )
        
        parser.add_argument(
            '--no-size-check',
            action='store_true',
            help='Terminal boyutu kontrolünü atla'
        )
        
        parser.add_argument(
            '--min-cols',
            type=int,
            default=40,
            help='Minimum terminal genişliği (varsayılan: 40)'
        )
        
        parser.add_argument(
            '--config',
            default='~/.config/lf/scripts/mp3_editor/config.json',
            help='Yapılandırma dosyası yolu'
        )
        
        self.args = parser.parse_args()
        self.mode = self.args.mode
        
    def check_terminal_size(self) -> bool:
        """
        Terminal boyutunu akıllıca kontrol et
        Returns:
            bool: Devam edilebilir mi?
        """
        # Boyut kontrolü atlanmışsa direkt True dön
        if hasattr(self, 'args') and self.args.no_size_check:
            print("ℹ️  Terminal boyutu kontrolü atlandı")
            return True
            
        try:
            # Terminal boyutunu al
            terminal_size = os.get_terminal_size()
            self.terminal_cols = terminal_size.columns
            self.terminal_rows = terminal_size.lines
            
            # Minimum boyut
            min_cols = self.args.min_cols if hasattr(self, 'args') else 40
            
            # Boyut durumunu değerlendir
            if self.terminal_cols < min_cols:
                print(f"\n❌ Terminal ÇOK DAR: {self.terminal_cols} sütun")
                print(f"   Minimum gereken: {min_cols} sütun")
                print(f"\n   Çözümler:")
                print(f"   1. Terminal penceresini büyütün")
                print(f"   2. --no-size-check ile çalıştırın")
                print(f"   3. --min-cols ile limiti düşürün (örn: --min-cols=30)")
                print(f"\n   Öneri: python3 mp3_editor.py --mode={self.mode} --no-size-check\n")
                return False
                
            elif self.terminal_cols < 60:
                # Dar ekran modu
                self.narrow_mode = True
                print(f"\n⚠️  Terminal DAR: {self.terminal_cols} sütun")
                print("   Dar ekran modu aktif - bazı özellikler sadeleştirildi")
                print(f"   Öneri: Terminali büyütün (önerilen: 80+ sütun)\n")
                
            elif self.terminal_cols < 80:
                # Orta ekran modu
                print(f"\n📏 Terminal genişliği: {self.terminal_cols} sütun")
                print("   Normal mod - tam deneyim için 80+ sütun önerilir\n")
                
            else:
                # Geniş ekran modu
                print(f"\n📏 Terminal genişliği: {self.terminal_cols} sütun")
                print("   Geniş ekran modu - tüm özellikler aktif\n")
            
            return True
            
        except Exception as e:
            # Terminal boyutu alınamazsa (pipe, script vb.)
            if self.args.debug:
                print(f"⚠️  Terminal boyutu alınamadı: {e}")
            print("ℹ️  Terminal boyutu kontrol edilemedi, normal modda devam")
            self.narrow_mode = False
            return True
    
    def get_adaptive_width(self, base_width: int) -> int:
        """
        Terminal boyutuna göre adaptif genişlik hesapla
        
        Args:
            base_width: İstenen genişlik
            
        Returns:
            int: Adapte edilmiş genişlik
        """
        if self.narrow_mode:
            # Dar ekranda her şeyi küçült
            return min(base_width, self.terminal_cols - 10)
        else:
            # Normal ekranda istenen boyutu kullan
            return min(base_width, self.terminal_cols - 5)
    
    def collect_files(self) -> List[str]:
        """İşlenecek MP3 dosyalarını topla"""
        files = []
        
        # Mod'a göre dosya toplama
        if self.mode == 'selected':
            # Seçili dosyalar (komut satırından gelen)
            files = [f for f in self.args.files if f.lower().endswith('.mp3')]
            
        elif self.mode == 'folder':
            # Bulunulan klasördeki tüm MP3'ler
            current_dir = os.getcwd()
            files = [os.path.join(current_dir, f) for f in os.listdir(current_dir) 
                    if f.lower().endswith('.mp3')]
            
        elif self.mode == 'sorter':
            # Sıralayıcı için dosyalar
            if self.args.files_arg:
                # Wildcard desteği
                import glob
                files = glob.glob(self.args.files_arg)
            else:
                files = [f for f in self.args.files if f.lower().endswith('.mp3')]
        
        # Dosyaları sırala (düzenli görünüm için)
        files.sort()
        
        return files
    
    def check_environment(self) -> bool:
        """Çalışma ortamını kontrol et"""
        checks = []
        
        # 1. Python versiyonu
        py_ok = sys.version_info >= (3, 6)
        checks.append(("Python 3.6+", py_ok))
        
        # 2. Mutagen kurulu mu?
        try:
            import mutagen
            mutagen_ok = True
        except ImportError:
            mutagen_ok = False
        checks.append(("mutagen kütüphanesi", mutagen_ok))
        
        # 3. Terminal boyutu (akıllı kontrol)
        term_ok = self.check_terminal_size()
        checks.append(("Terminal boyutu", term_ok))
        
        # 4. lf içinde mi?
        lf_ok = 'LF_LEVEL' in os.environ
        if not lf_ok:
            print("ℹ️  lf dışında çalışıyor (bazı özellikler sınırlı olabilir)")
        
        # Hata kontrolü
        failed = [name for name, ok in checks if not ok]
        if failed:
            print("\n❌ Ortam kontrolü başarısız:")
            for name in failed:
                print(f"   • {name}")
            return False
            
        print("✅ Ortam kontrolü başarılı")
        return True
    
    def show_welcome(self):
        """Karşılama mesajı (terminal boyutuna duyarlı)"""
        if self.narrow_mode:
            # Dar ekran için sade mesaj
            print(f"""
╔════════════════════════╗
║  MP3 EDITOR v{self.VERSION}   ║
║  {self.mode.upper()} MOD      ║
║  {len(self.files)} dosya       ║
╚════════════════════════╝
            """)
        else:
            # Normal ekran için detaylı mesaj
            print(f"""
╔══════════════════════════════════════════════════════════╗
║     🎵 LF MP3 TAG EDITOR v{self.VERSION} 🎵                    ║
║     Terminal içinden MP3 etiket düzenleme aracı          ║
╠══════════════════════════════════════════════════════════╣
║  Mod: {self.mode.upper():<30}                      ║
║  Dosya: {len(self.files):<3}                         {self._get_mode_icon()}        ║
║  Terminal: {self.terminal_cols} sütun {'(Dar mod)' if self.narrow_mode else '(Normal)'}          ║
╚══════════════════════════════════════════════════════════╝
            """)
    
    def _get_mode_icon(self) -> str:
        """Moda göre ikon döndür"""
        icons = {
            'selected': '🔍',
            'folder': '📁',
            'sorter': '🔢'
        }
        return icons.get(self.mode, '🎵')
    
    def run(self):
        """Ana çalıştırma döngüsü"""
        try:
            # 1. Argümanları parse et
            self.parse_arguments()
            
            # 2. Ortam kontrolü
            if not self.check_environment():
                sys.exit(1)
            
            # 3. Dosyaları topla
            self.files = self.collect_files()
            
            if not self.files:
                print("❌ İşlenecek MP3 dosyası bulunamadı!")
                sys.exit(1)
            
            # 4. Karşılama mesajı
            self.show_welcome()
            
            # 5. Mode göre işlem yap
            if self.mode == 'selected':
                self.handle_selected_mode()
            elif self.mode == 'folder':
                self.handle_folder_mode()
            elif self.mode == 'sorter':
                self.handle_sorter_mode()
                
        except KeyboardInterrupt:
            print("\n\n⚠️  Kullanıcı tarafından iptal edildi")
            sys.exit(0)
        except Exception as e:
            print(f"\n❌ Beklenmeyen hata: {e}")
            if hasattr(self, 'args') and self.args.debug:
                import traceback
                traceback.print_exc()
            sys.exit(1)
    
    def handle_selected_mode(self):
        """Seçili dosya modu"""
        # Terminal boyutuna göre menü oluştur
        menu = Menu(self.files, narrow_mode=self.narrow_mode, terminal_cols=self.terminal_cols)
        menu.show_main()
    
    def handle_folder_mode(self):
        """Klasör modu"""
        print(f"📁 Klasör modunda {len(self.files)} dosya işlenecek")
        menu = Menu(self.files, narrow_mode=self.narrow_mode, terminal_cols=self.terminal_cols)
        menu.show_main()
    
    def handle_sorter_mode(self):
        """Sıralayıcı modu"""
        print(f"🔢 Sıralayıcı modunda {len(self.files)} dosya")
        # Sıralayıcı burada olacak (Faz 3)
        pass


def main():
    """Ana giriş noktası"""
    editor = MP3Editor()
    editor.run()


if __name__ == "__main__":
    main()
