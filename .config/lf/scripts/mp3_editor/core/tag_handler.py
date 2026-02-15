#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MP3 etiket okuma/yazma işlemleri (Mutagen ile)
"""

import os
from typing import Dict, Optional, Any
from mutagen import File
from mutagen.id3 import ID3, TIT2, TPE1, TALB, TRCK, TYER, TCON, COMM, error as ID3Error
from mutagen.mp3 import MP3

class TagHandler:
    """ID3 etiketleri ile ilgili tüm işlemler"""
    
    # Etiket eşleştirme tablosu
    TAG_MAP = {
        'title': 'TIT2',
        'artist': 'TPE1',
        'album': 'TALB',
        'track': 'TRCK',
        'year': 'TYER',
        'genre': 'TCON',
        'comment': 'COMM'
    }
    
    def __init__(self):
        self.stats = {
            'read': 0,
            'written': 0,
            'errors': 0
        }
    
    def read_tags(self, filepath: str) -> Dict[str, str]:
        """
        MP3 dosyasından tüm etiketleri oku
        
        Args:
            filepath: MP3 dosya yolu
            
        Returns:
            Dict: Etiket sözlüğü (boş etiketler için boş string)
        """
        tags = {
            'title': '',
            'artist': '',
            'album': '',
            'track': '',
            'year': '',
            'genre': '',
            'comment': '',
            'length': '0'  # Süre (saniye)
        }
        
        try:
            # Dosya var mı?
            if not os.path.exists(filepath):
                raise FileNotFoundError(f"Dosya bulunamadı: {filepath}")
            
            # MP3 süresini al
            audio = MP3(filepath)
            if audio.info:
                length = int(audio.info.length)
                tags['length'] = str(length)
            
            # ID3 etiketlerini oku
            try:
                id3 = ID3(filepath)
                
                # Her etiketi eşleştir
                for tag_name, frame_id in self.TAG_MAP.items():
                    if frame_id in id3:
                        frame = id3[frame_id]
                        
                        # COMM özel (COMMENT)
                        if frame_id == 'COMM' and hasattr(frame, 'text'):
                            tags[tag_name] = str(frame.text[0]) if frame.text else ''
                        # Diğer frame'ler
                        elif hasattr(frame, 'text'):
                            tags[tag_name] = str(frame.text[0]) if frame.text else ''
                        elif hasattr(frame, 'desc'):
                            tags[tag_name] = frame.desc
                            
                # Track numarasını temizle (varsa "1/10" formatından "1" al)
                if tags['track'] and '/' in tags['track']:
                    tags['track'] = tags['track'].split('/')[0]
                    
            except ID3Error:
                # ID3 yoksa veya bozuksa, yeni oluştur
                pass
            
            self.stats['read'] += 1
                
        except Exception as e:
            self.stats['errors'] += 1
            print(f"⚠️  Hata ({os.path.basename(filepath)}): {e}")
            
        return tags
    
    def write_tags(self, filepath: str, tags: Dict[str, str]) -> bool:
        """
        MP3 dosyasına etiket yaz
        
        Args:
            filepath: MP3 dosya yolu
            tags: Yazılacak etiketler
            
        Returns:
            bool: Başarılı mı?
        """
        try:
            # Mevcut etiketleri al veya yeni oluştur
            try:
                audio = ID3(filepath)
            except ID3Error:
                audio = ID3()
            
            # Her etiketi yaz
            for tag_name, value in tags.items():
                if tag_name not in self.TAG_MAP:
                    continue
                    
                if not value:  # Boş değerleri atla
                    continue
                    
                frame_id = self.TAG_MAP[tag_name]
                
                # Frame tipine göre yaz
                if frame_id == 'COMM':
                    audio[frame_id] = COMM(encoding=3, lang='eng', desc='comment', text=[value])
                else:
                    # Diğer tüm frame'ler için
                    frame_class = {
                        'TIT2': TIT2,
                        'TPE1': TPE1,
                        'TALB': TALB,
                        'TRCK': TRCK,
                        'TYER': TYER,
                        'TCON': TCON
                    }.get(frame_id)
                    
                    if frame_class:
                        audio[frame_id] = frame_class(encoding=3, text=[value])
            
            # Değişiklikleri kaydet
            audio.save(filepath)
            self.stats['written'] += 1
            return True
            
        except Exception as e:
            self.stats['errors'] += 1
            print(f"⚠️  Yazma hatası ({os.path.basename(filepath)}): {e}")
            return False
    
    def get_all_tags(self, filepath: str) -> Dict[str, Any]:
        """Tüm etiketleri ve metadata'yı döndür"""
        tags = self.read_tags(filepath)
        
        # Ek bilgiler
        try:
            audio = MP3(filepath)
            if audio.info:
                tags['bitrate'] = audio.info.bitrate // 1000
                tags['sample_rate'] = audio.info.sample_rate
        except:
            pass
            
        return tags
    
    def print_tags(self, filepath: str):
        """Etiketleri güzel yazdır"""
        tags = self.get_all_tags(filepath)
        print(f"\n📄 {os.path.basename(filepath)}")
        print(f"  Başlık : {tags['title'] or '-'}")
        print(f"  Sanatçı: {tags['artist'] or '-'}")
        print(f"  Albüm  : {tags['album'] or '-'}")
        print(f"  Track  : {tags['track'] or '-'}")
        print(f"  Yıl    : {tags['year'] or '-'}")
        print(f"  Tür    : {tags['genre'] or '-'}")
        
        if tags.get('length'):
            minutes = int(tags['length']) // 60
            seconds = int(tags['length']) % 60
            print(f"  Süre   : {minutes}:{seconds:02d}")
    
    def get_stats(self) -> Dict[str, int]:
        """İstatistikleri döndür"""
        return self.stats.copy()


# Test kodu
if __name__ == "__main__":
    handler = TagHandler()
    
    # Test dosyası
    test_file = "test.mp3"
    if os.path.exists(test_file):
        tags = handler.read_tags(test_file)
        print("Okunan etiketler:", tags)
        
        # Etiket yaz
        handler.write_tags(test_file, {'title': 'Test Şarkı', 'artist': 'Test Sanatçı'})
        handler.print_tags(test_file)
