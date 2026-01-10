#!/usr/bin/env python3
import json
import subprocess
import os

def get_weather():
    try:
        # Fetch weather from wttr.in
        result = subprocess.run(['curl', '-s', 'https://wttr.in/Altinordu?format=%c%t+%C'], capture_output=True, text=True, timeout=15)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
    except Exception:
        pass
    return "⛅️ Hava Durumu Alınamadı"

def update_config(weather_text):
    config_path = os.path.expanduser('~/.config/swaync/config.json')
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        if 'widget-config' in config and 'label#weather' in config['widget-config']:
            config['widget-config']['label#weather']['text'] = weather_text
            
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            
            # Reload SwayNC
            subprocess.run(['swaync-client', '-R'], capture_output=True)
    except Exception as e:
        print(f"Hata: {e}")

if __name__ == "__main__":
    weather = get_weather()
    print(weather)
    update_config(weather)
    # Ayrıca ağ durumlarını da güncelle
    script_dir = os.path.dirname(os.path.realpath(__file__))
    subprocess.run(["python3", os.path.join(script_dir, "status_monitor.py")])
