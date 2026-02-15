#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Terminal menü arayüzü (Terminal boyutuna duyarlı)
"""

import os
import sys
from typing import List

class Colors:
    """Terminal renk kodları"""
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def clear_screen():
    """Terminal ekranını temizle"""
    os.system('clear' if os.name == 'posix' else 'cls')

class Menu:
    """Ana menü sınıfı (Terminal boyutuna duyarlı)"""
    
    def __init__(self, files: List[str], narrow_mode: bool = False, terminal_cols: int = 80):
        self.files = files
        self.running = True
        self.narrow_mode = narrow_mode
        self.terminal_cols = terminal_cols
        
    def print_header(self):
        """Başlık yazdır (terminal boyutuna göre)"""
        if self.narrow_mode:
            # Dar ekran için sade başlık
            print(f"{Colors.BOLD}{Colors.CYAN}")
            print("╔══════════════════════╗")
            print("║   MP3 EDITOR MENÜ   ║")
            print("╚══════════════════════╝")
            print(f"{Colors.END}")
            
            # Dosya listesi (kısaltılmış)
            print(f"{Colors.BLUE}📁 {len(self.files)} dosya{Colors.END}")
            for i, f in enumerate(self.files[:3]):
                print(f"  {i+1}. {os.path.basename(f)[:20]}")
            if len(self.files) > 3:
                print(f"  ... ve {len(self.files)-3} dosya daha")
        else:
            # Normal ekran için detaylı başlık
            print(f"{Colors.BOLD}{Colors.CYAN}")
            print("╔══════════════════════════════════════════════════════╗")
            print("║            MP3 TAG EDITOR - ANA MENÜ                ║")
            print("╚══════════════════════════════════════════════════════╝")
            print(f"{Colors.END}")
            
            print(f"{Colors.BLUE}📁 {len(self.files)} dosya seçildi:{Colors.END}")
            if len(self.files) <= 5:
                for f in self.files:
                    print(f"   • {os.path.basename(f)}")
            else:
                print(f"   • {os.path.basename(self.files[0])}")
                print(f"   • ... ve {len(self.files)-1} dosya daha")
        print()
    
    def print_menu(self):
        """Menü seçeneklerini yazdır (terminal boyutuna göre)"""
        if self.narrow_mode:
            # Dar ekran için kısa menü
            print(f"{Colors.BOLD}İŞLEMLER:{Colors.END}\n")
            
            print(f"  {Colors.GREEN}[1]{Colors.END} Dosya İsmi → Etiket")
            print(f"  {Colors.GREEN}[2]{Colors.END} Etiket → Dosya İsmi")
            print(f"  {Colors.GREEN}[3]{Colors.END} Etiket Düzenle")
            print(f"  {Colors.GREEN}[4]{Colors.END} Toplu Düzenle")
            print(f"  {Colors.GREEN}[5]{Colors.END} Listele")
            print(f"  {Colors.WARNING}[0]{Colors.END} Çıkış")
        else:
            # Normal ekran için detaylı menü
            print(f"{Colors.BOLD}İŞLEMLER:{Colors.END}\n")
            
            print(f"  {Colors.GREEN}[1]{Colors.END} Dosya İsminden Etiket Oluştur")
            print(f"     {Colors.CYAN}ℹ{Colors.END} Dosya adını parçalayıp etiketlere yaz")
            print()
            
            print(f"  {Colors.GREEN}[2]{Colors.END} Etiketlerden Dosya İsmi Oluştur")
            print(f"     {Colors.CYAN}ℹ{Colors.END} Etiketleri kullanarak dosyaları yeniden adlandır")
            print()
            
            print(f"  {Colors.GREEN}[3]{Colors.END} Etiketleri Düzenle (Tek Tek)")
            print(f"     {Colors.CYAN}ℹ{Colors.END} Her dosya için elle etiket girişi")
            print()
            
            print(f"  {Colors.GREEN}[4]{Colors.END} Toplu Etiket Düzenle")
            print(f"     {Colors.CYAN}ℹ{Colors.END} Tüm dosyalara aynı etiketleri yaz")
            print()
            
            print(f"  {Colors.GREEN}[5]{Colors.END} Dosyaları Listele")
            print(f"     {Colors.CYAN}ℹ{Colors.END} Mevcut etiketleri göster")
            print()
            
            print(f"  {Colors.WARNING}[0]{Colors.END} Çıkış")
        print()
    
    def list_files(self):
        """Dosyaları etiketleriyle listele"""
        from core.tag_handler import TagHandler
        
        clear_screen()
        
        if self.narrow_mode:
            print(f"{Colors.BOLD}DOSYALAR:{Colors.END}\n")
        else:
            print(f"{Colors.BOLD}{Colors.CYAN}DOSYA LİSTESİ{Colors.END}\n")
        
        handler = TagHandler()
        for i, file in enumerate(self.files, 1):
            tags = handler.read_tags(file)
            
            if self.narrow_mode:
                # Dar ekran için sade liste
                title = tags.get('title', '?')[:15]
                artist = tags.get('artist', '?')[:10]
                print(f"{i:2}. {title} - {artist}")
            else:
                # Normal ekran için detaylı liste
                print(f"{Colors.BOLD}{i:2}.{Colors.END} {os.path.basename(file)}")
                
                # Etiketleri yazdır
                if tags.get('title') or tags.get('artist'):
                    print(f"     {Colors.GREEN}▶{Colors.END} {tags.get('title', '-')} - {tags.get('artist', '-')}")
                if tags.get('album'):
                    print(f"     {Colors.BLUE}💿{Colors.END} {tags.get('album')}")
                if tags.get('track'):
                    print(f"     {Colors.CYAN}#{Colors.END} {tags.get('track')}")
                print()
        
        input(f"\n{Colors.BOLD}Devam için Enter...{Colors.END}")
    
    def edit_tags(self):
        """Tek tek etiket düzenle"""
        from core.tag_handler import TagHandler
        handler = TagHandler()
        
        for file in self.files:
            clear_screen()
            
            if self.narrow_mode:
                print(f"{Colors.BOLD}Düzenle: {os.path.basename(file)[:30]}{Colors.END}\n")
            else:
                print(f"{Colors.BOLD}Düzenleniyor: {os.path.basename(file)}{Colors.END}\n")
            
            tags = handler.read_tags(file)
            
            if self.narrow_mode:
                # Dar ekran için yan yana gösterim
                print(f"Başlık: {tags['title'] or '-'}")
                print(f"Sanatçı: {tags['artist'] or '-'}")
                print(f"Albüm: {tags['album'] or '-'}")
                print(f"Track: {tags['track'] or '-'}")
            else:
                # Normal ekran için detaylı gösterim
                print(f"  Başlık : {tags['title'] or '-'}")
                print(f"  Sanatçı: {tags['artist'] or '-'}")
                print(f"  Albüm  : {tags['album'] or '-'}")
                print(f"  Track  : {tags['track'] or '-'}")
                print(f"  Yıl    : {tags['year'] or '-'}")
                print(f"  Tür    : {tags['genre'] or '-'}")
            print()
            
            # Yeni değerler al
            new_tags = {}
            new_tags['title'] = input(f"Başlık [{tags['title']}]: ").strip() or tags['title']
            new_tags['artist'] = input(f"Sanatçı [{tags['artist']}]: ").strip() or tags['artist']
            new_tags['album'] = input(f"Albüm [{tags['album']}]: ").strip() or tags['album']
            new_tags['track'] = input(f"Track [{tags['track']}]: ").strip() or tags['track']
            
            if not self.narrow_mode:
                new_tags['year'] = input(f"Yıl [{tags['year']}]: ").strip() or tags['year']
                new_tags['genre'] = input(f"Tür [{tags['genre']}]: ").strip() or tags['genre']
            
            # Kaydet
            if handler.write_tags(file, new_tags):
                print(f"{Colors.GREEN}✓ Kaydedildi{Colors.END}")
            else:
                print(f"{Colors.FAIL}✗ Hata!{Colors.END}")
            
            if len(self.files) > 1 and file != self.files[-1]:
                if input("\nSonraki dosyaya geç? (E/h): ").lower() == 'h':
                    break
        
        input("\nDevam için Enter...")
    
    def handle_choice(self, choice: str):
        """Menü seçimini işle"""
        if choice == '1':
            self.filename_to_tag()
        elif choice == '2':
            self.tag_to_filename()
        elif choice == '3':
            self.edit_tags()
        elif choice == '4':
            self.batch_edit()
        elif choice == '5':
            self.list_files()
        elif choice == '0':
            self.running = False
        else:
            print(f"{Colors.WARNING}Geçersiz seçim!{Colors.END}")
            input("Devam için Enter...")
    
    def filename_to_tag(self):
        """Dosya isminden etiket oluştur"""
        clear_screen()
        print(f"{Colors.BOLD}{Colors.CYAN}DOSYA İSMİNDEN ETİKET OLUŞTUR{Colors.END}\n")
        print(f"{Colors.WARNING}Bu özellik Faz 2'de eklenecek{Colors.END}")
        input("\nDevam için Enter...")
    
    def tag_to_filename(self):
        """Etiketlerden dosya ismi oluştur"""
        clear_screen()
        print(f"{Colors.BOLD}{Colors.CYAN}ETİKETLERDEN DOSYA İSMİ OLUŞTUR{Colors.END}\n")
        print(f"{Colors.WARNING}Bu özellik Faz 2'de eklenecek{Colors.END}")
        input("\nDevam için Enter...")
    
    def batch_edit(self):
        """Toplu etiket düzenle"""
        clear_screen()
        print(f"{Colors.BOLD}{Colors.CYAN}TOPLU ETİKET DÜZENLE{Colors.END}\n")
        print(f"{len(self.files)} dosyaya aynı etiketler yazılacak\n")
        
        from core.tag_handler import TagHandler
        handler = TagHandler()
        
        # Ortak etiketler
        album = input("Albüm (boş bırakırsanız değişmez): ").strip()
        year = input("Yıl (boş bırakırsanız değişmez): ").strip()
        genre = input("Tür (boş bırakırsanız değişmez): ").strip()
        
        if not any([album, year, genre]):
            print(f"\n{Colors.WARNING}Hiçbir değer girilmedi!{Colors.END}")
            input("Devam için Enter...")
            return
        
        # Onay
        print(f"\n{Colors.BOLD}Yapılacak işlem:{Colors.END}")
        if album:
            print(f"  • Albüm -> {album}")
        if year:
            print(f"  • Yıl   -> {year}")
        if genre:
            print(f"  • Tür   -> {genre}")
        
        confirm = input(f"\n{Colors.WARNING}Onaylıyor musunuz? (e/H): {Colors.END}").lower()
        
        if confirm == 'e':
            success = 0
            for file in self.files:
                tags = handler.read_tags(file)
                
                if album:
                    tags['album'] = album
                if year:
                    tags['year'] = year
                if genre:
                    tags['genre'] = genre
                
                if handler.write_tags(file, tags):
                    success += 1
            
            print(f"\n{Colors.GREEN}✓ {success}/{len(self.files)} dosya güncellendi{Colors.END}")
        else:
            print("İşlem iptal edildi")
        
        input("\nDevam için Enter...")
    
    def show_main(self):
        """Ana menüyü göster"""
        while self.running:
            clear_screen()
            self.print_header()
            self.print_menu()
            
            choice = input(f"{Colors.BOLD}Seçiminiz [0-5]: {Colors.END}").strip()
            self.handle_choice(choice)


# Test kodu
if __name__ == "__main__":
    test_files = ["song1.mp3", "song2.mp3", "song3.mp3"]
    menu = Menu(test_files)
    menu.show_main()
