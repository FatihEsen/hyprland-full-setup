#!/usr/bin/env python3
import json
import subprocess
import os
import re

CONFIG_PATH = os.path.expanduser("~/.config/swaync/config.json")


def get_wifi_state():
    try:
        res = subprocess.run(
            ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE", "device"],
            capture_output=True, text=True
        )
        is_connected = False
        for line in res.stdout.splitlines():
            parts = line.split(":")
            if len(parts) >= 3 and parts[1] == "wifi" and parts[2] == "connected":
                is_connected = True
                break

        ssid = ""
        signal = 0
        if is_connected:
            # --escape no: nmcli'nin kolon kaçış karakterini devre dışı bırakır
            res_wifi = subprocess.run(
                ["nmcli", "--escape", "no", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"],
                capture_output=True, text=True
            )
            for line in res_wifi.stdout.splitlines():
                if line.startswith("yes:") or line.startswith("evet:"):
                    # Format: yes:SSID:sinyal or evet:SSID:sinyal
                    # SSID içinde : olmaz (--escape no ile), güvenle split edebiliriz
                    parts = line.split(":")
                    ssid = parts[1] if len(parts) > 1 else ""
                    try:
                        signal = int(parts[2]) if len(parts) > 2 else 0
                    except ValueError:
                        signal = 0
                    break

        return is_connected, ssid, signal
    except Exception:
        pass
    return False, "", 0


def wifi_signal_icon(signal):
    if signal >= 80:
        return "󰤨"   # tam dolu
    elif signal >= 60:
        return "󰤥"
    elif signal >= 40:
        return "󰤢"
    elif signal >= 20:
        return "󰤟"
    else:
        return "󰤯"   # çok zayıf


def get_bluetooth_state():
    try:
        res = subprocess.run(["bluetoothctl", "show"], capture_output=True, text=True)
        powered = "Powered: yes" in res.stdout

        connected_device = ""
        if powered:
            # Bağlı cihazları bul
            res_devices = subprocess.run(
                ["bluetoothctl", "devices", "Connected"],
                capture_output=True, text=True
            )
            devices = res_devices.stdout.strip().splitlines()
            if devices:
                # İlk cihazın adını al
                first = devices[0]
                # Format: "Device XX:XX:XX:XX:XX:XX DeviceName"
                match = re.match(r"Device\s+[\w:]+\s+(.+)", first)
                if match:
                    connected_device = match.group(1).strip()

        return powered, connected_device
    except Exception:
        pass
    return False, ""


def get_volume():
    try:
        res = subprocess.run(
            ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
            capture_output=True, text=True
        )
        # Output: "Volume: 0.50" or "Volume: 0.50 [MUTED]"
        line = res.stdout.strip()
        muted = "[MUTED]" in line
        match = re.search(r"Volume:\s*([\d.]+)", line)
        volume = 0
        if match:
            volume = round(float(match.group(1)) * 100)
        return volume, muted
    except Exception:
        pass
    return 0, False


def volume_icon(volume, muted):
    if muted or volume == 0:
        return "󰝟"
    elif volume < 33:
        return "󰕿"
    elif volume < 66:
        return "󰖀"
    else:
        return "󰕾"


def get_brightness():
    try:
        res = subprocess.run(
            ["brightnessctl", "get"],
            capture_output=True, text=True
        )
        current = int(res.stdout.strip())
        res_max = subprocess.run(
            ["brightnessctl", "max"],
            capture_output=True, text=True
        )
        maximum = int(res_max.stdout.strip())
        if maximum > 0:
            pct = round(current * 100 / maximum)
            return pct
    except Exception:
        pass
    return 0


def update_config():
    wifi_connected, wifi_ssid, wifi_signal = get_wifi_state()
    bt_powered, bt_device = get_bluetooth_state()
    volume, muted = get_volume()
    brightness = get_brightness()

    # --- WiFi ---
    if wifi_connected:
        wifi_label = wifi_signal_icon(wifi_signal)
        signal_bar = f" {wifi_signal}%"
        wifi_tooltip = f"󰖩 WiFi: {wifi_ssid}\n📶 Sinyal: {signal_bar}"
    else:
        wifi_label = "󰖪"
        wifi_tooltip = "󰖪 WiFi: Bağlantı Yok"

    # --- Bluetooth ---
    if bt_device:
        bt_label = "󰂱"          # bağlı ikon
        bt_tooltip = f"󰂯 Bluetooth: Açık\n󰂱 Cihaz: {bt_device}"
    elif bt_powered:
        bt_label = "󰂯"
        bt_tooltip = "󰂯 Bluetooth: Açık\n(Bağlı cihaz yok)"
    else:
        bt_label = "󰂲"
        bt_tooltip = "󰂲 Bluetooth: Kapalı"

    # --- Ses ---
    vol_label = volume_icon(volume, muted)
    if muted:
        vol_tooltip = f"{vol_label} Ses: Sessiz\n🔊 Seviye: {volume}%"
    else:
        vol_tooltip = f"{vol_label} Ses Seviyesi: {volume}%"

    # --- Parlaklık ---
    bright_tooltip = f"󰃠 Parlaklık: {brightness}%"

    try:
        with open(CONFIG_PATH, "r", encoding="utf-8") as f:
            config = json.load(f)

        actions = config["widget-config"]["buttons-grid"]["actions"]

        # Tüm aksiyonları etiket/tooltip ile eşleştir ve güncelle
        for action in actions:
            label = action.get("label", "")
            tooltip = action.get("tooltip", "")

            # WiFi butonu
            if action.get("command", "").endswith("toggle_wifi.sh"):
                action["label"] = wifi_label
                action["tooltip"] = wifi_tooltip
                action["active"] = wifi_connected

            # Bluetooth butonu
            elif action.get("command", "").endswith("toggle_bt.sh"):
                action["label"] = bt_label
                action["tooltip"] = bt_tooltip
                action["active"] = bt_powered

            # Ses butonu
            elif "pavucontrol" in action.get("command", ""):
                action["label"] = vol_label
                action["tooltip"] = vol_tooltip

            # Parlaklık (backlight) — eğer brightnessctl komutu varsa
            elif "brightnessctl" in action.get("command", "") or "Parlak" in tooltip:
                action["tooltip"] = bright_tooltip

        with open(CONFIG_PATH, "w", encoding="utf-8") as f:
            json.dump(config, f, indent=2, ensure_ascii=False)

        subprocess.run(["swaync-client", "-R"], capture_output=True)
    except Exception as e:
        print(f"Hata: {e}")


if __name__ == "__main__":
    update_config()
