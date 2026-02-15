#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Loglama ve hata takibi
"""

import os
import sys
import logging
from datetime import datetime
from pathlib import Path

class Logger:
    """Uygulama loglama sınıfı"""
    
    LOG_LEVELS = {
        'debug': logging.DEBUG,
        'info': logging.INFO,
        'warning': logging.WARNING,
        'error': logging.ERROR
    }
    
    def __init__(self, name='mp3_editor', level='info'):
        self.log_dir = Path.home() / '.config/lf/scripts/mp3_editor/logs'
        self.log_dir.mkdir(parents=True, exist_ok=True)
        
        # Log dosyası adı (günlük)
        today = datetime.now().strftime('%Y-%m-%d')
        log_file = self.log_dir / f'mp3_editor_{today}.log'
        
        # Logger yapılandırması
        self.logger = logging.getLogger(name)
        self.logger.setLevel(self.LOG_LEVELS.get(level, logging.INFO))
        
        # Dosya handler
        file_handler = logging.FileHandler(log_file, encoding='utf-8')
        file_handler.setLevel(self.LOG_LEVELS.get(level, logging.INFO))
        
        # Format
        formatter = logging.Formatter(
            '%(asctime)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        file_handler.setFormatter(formatter)
        
        self.logger.addHandler(file_handler)
        
        # Konsol handler (sadece error ve warning için)
        console_handler = logging.StreamHandler(sys.stderr)
        console_handler.setLevel(logging.WARNING)
        console_handler.setFormatter(formatter)
        self.logger.addHandler(console_handler)
        
    def debug(self, message):
        """Debug seviyesi log"""
        self.logger.debug(message)
        
    def info(self, message):
        """Info seviyesi log"""
        self.logger.info(message)
        
    def warning(self, message):
        """Warning seviyesi log"""
        self.logger.warning(message)
        
    def error(self, message):
        """Error seviyesi log"""
        self.logger.error(message)
        
    def operation(self, action: str, files: list, result: str):
        """Özel operasyon logu"""
        self.info(f"OPERATION: {action} - {len(files)} files - {result}")
        
    def get_logs(self, days: int = 7) -> list:
        """Son X günün loglarını getir"""
        logs = []
        for log_file in sorted(self.log_dir.glob('*.log'), reverse=True):
            # Tarih kontrolü
            try:
                date_str = log_file.stem.split('_')[-1]
                log_date = datetime.strptime(date_str, '%Y-%m-%d')
                if (datetime.now() - log_date).days <= days:
                    with open(log_file, 'r', encoding='utf-8') as f:
                        logs.extend(f.readlines())
            except:
                continue
        return logs[-100:]  # Son 100 satır


# Test kodu
if __name__ == "__main__":
    logger = Logger()
    logger.info("Uygulama başladı")
    logger.warning("Test uyarısı")
    logger.error("Test hatası")
    
    print("Loglar kaydedildi:", logger.log_dir)
