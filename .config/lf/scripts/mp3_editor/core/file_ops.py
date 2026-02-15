#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Dosya işlemleri ve yeniden adlandırma
"""

import os
import re
import shutil
from pathlib import Path
from typing import List, Dict, Tuple

class FileOperations:
    """Dosya sistemi işlemleri"""
    
    # Geçersiz karakterler (Windows/Linux)
    INVALID_CHARS = r'[\\/*?:"<>|]'
    
    def __init__(self):
        self.backup_dir = Path.home() / '.config/lf/scripts/mp3_editor/backups'
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        
    def sanitize_filename(self, filename: str) -> str:
        """
        Dosya adından geçersiz karakterleri temizle
        
        Args:
            filename: Temizlenecek dosya adı
            
        Returns:
            str: Temizlenmiş dosya adı
        """
        # Geçersiz karakterleri alt çizgi ile değiştir
        clean = re.sub(self.INVALID_CHARS, '_', filename)
        
        # Birden fazla alt çizgiyi tek alt çizgi yap
        clean = re.sub(r'_+', '_', clean)
        
        # Baştaki ve sondaki boşlukları ve noktaları temizle
        clean = clean.strip('. ')
        
        return clean
    
    def generate_filename(self, tags: Dict[str, str], template: str) -> str:
        """
        Etiketlerden dosya adı oluştur
        
        Args:
            tags: Etiket sözlüğü
            template: Şablon (örn: "%track%. %title% - %artist%")
            
        Returns:
            str: Oluşturulan dosya adı
        """
        filename = template
        
        # Değişkenleri değerlerle değiştir
        for key, value in tags.items():
            placeholder = f"%{key}%"
            if placeholder in filename:
                # Boş değerleri "Unknown" ile değiştir
                if not value:
                    value = "Unknown"
                filename = filename.replace(placeholder, value.strip())
        
        # Track numarasını iki haneli yap
        if '%track%' in template and tags.get('track'):
            track_num = tags['track'].strip()
            if track_num.isdigit():
                track_padded = track_num.zfill(2)
                filename = filename.replace(track_num, track_padded)
        
        # Geçersiz karakterleri temizle
        filename = self.sanitize_filename(filename)
        
        # .mp3 uzantısı ekle (yoksa)
        if not filename.lower().endswith('.mp3'):
            filename += '.mp3'
            
        return filename
    
    def rename_file(self, old_path: str, new_name: str, backup: bool = True) -> Tuple[bool, str]:
        """
        Dosyayı yeniden adlandır
        
        Args:
            old_path: Eski dosya yolu
            new_name: Yeni dosya adı (sadece isim, yol değil)
            backup: Yedekleme yapılsın mı?
            
        Returns:
            Tuple[bool, str]: (Başarılı mı?, Yeni yol veya hata mesajı)
        """
        try:
            old_path = Path(old_path)
            
            # Yeni tam yol
            new_path = old_path.parent / new_name
            
            # Aynı isimse işlem yapma
            if old_path.name == new_name:
                return True, str(old_path)
            
            # Hedef dosya zaten var mı?
            if new_path.exists() and backup:
                # Yedekle
                backup_path = self.backup_dir / f"{new_path.stem}_{new_path.suffix}.backup"
                shutil.copy2(str(new_path), str(backup_path))
                print(f"💾 Yedek oluşturuldu: {backup_path.name}")
            
            # Yeniden adlandır
            old_path.rename(new_path)
            
            return True, str(new_path)
            
        except Exception as e:
            return False, str(e)
    
    def bulk_rename(self, files: List[str], template: str, tags_list: List[Dict]) -> List[Tuple[str, str, bool]]:
        """
        Toplu yeniden adlandırma
        
        Args:
            files: Dosya yolları listesi
            template: İsim şablonu
            tags_list: Her dosya için etiketler
            
        Returns:
            List[Tuple]: (Eski isim, Yeni isim, Başarılı mı?)
        """
        results = []
        
        for file_path, tags in zip(files, tags_list):
            old_name = os.path.basename(file_path)
            new_name = self.generate_filename(tags, template)
            
            success, result = self.rename_file(file_path, new_name)
            
            if success:
                results.append((old_name, new_name, True))
            else:
                results.append((old_name, old_name, False))
                print(f"❌ Hata: {file_path} -> {result}")
        
        return results
    
    def extract_info_from_filename(self, filename: str, pattern: str) -> Dict[str, str]:
        """
        Dosya adından pattern'e göre bilgi çıkar
        
        Args:
            filename: Dosya adı (uzantısız)
            pattern: Regex pattern (örn: r"^(?P<track>\d+)\. (?P<title>.+) - (?P<artist>.+)$")
            
        Returns:
            Dict: Çıkarılan bilgiler
        """
        result = {}
        
        try:
            match = re.match(pattern, filename)
            if match:
                result = match.groupdict()
        except:
            pass
            
        return result
    
    def preview_rename(self, files: List[str], template: str, tags_list: List[Dict]) -> List[Tuple[str, str]]:
        """
        Yeniden adlandırmayı önizle (uygulamadan)
        
        Returns:
            List[Tuple]: (Eski isim, Yeni isim)
        """
        preview = []
        
        for file_path, tags in zip(files, tags_list):
            old_name = os.path.basename(file_path)
            new_name = self.generate_filename(tags, template)
            
            if old_name != new_name:
                preview.append((old_name, new_name))
        
        return preview
    
    def create_backup(self, file_path: str) -> bool:
        """Dosyanın yedeğini al"""
        try:
            src = Path(file_path)
            dst = self.backup_dir / f"{src.name}.{src.stat().st_mtime}.backup"
            shutil.copy2(str(src), str(dst))
            return True
        except:
            return False
    
    def restore_from_backup(self, backup_file: str, target_path: str) -> bool:
        """Yedekten geri yükle"""
        try:
            shutil.copy2(backup_file, target_path)
            return True
        except:
            return False


# Test kodu
if __name__ == "__main__":
    fo = FileOperations()
    
    # Test dosya adı temizleme
    test_names = [
        "01 - Song? Title:.mp3",
        "Artist|Name - Song*Name.mp3",
        "  Geçersiz   .mp3  "
    ]
    
    for name in test_names:
        clean = fo.sanitize_filename(name)
        print(f"{name} -> {clean}")
    
    # Test dosya adı oluşturma
    tags = {
        'track': '1',
        'title': 'Battery',
        'artist': 'Metallica'
    }
    
    template = "%track%. %title% - %artist%"
    new_name = fo.generate_filename(tags, template)
    print(f"\nŞablon: {template}")
    print(f"Oluşan: {new_name}")
