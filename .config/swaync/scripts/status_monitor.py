#!/usr/bin/env python3
import json
import subprocess
import os

CONFIG_PATH = os.path.expanduser("~/.config/swaync/config.json")

def get_wifi_state():
    try:
        # Check connection state
        res = subprocess.run(["nmcli", "-t", "-f", "DEVICE,TYPE,STATE", "device"], capture_output=True, text=True)
        is_connected = False
        for line in res.stdout.splitlines():
            # Match wlan0:wifi:connected or similar
            parts = line.split(':')
            if len(parts) >= 3 and parts[1] == 'wifi' and parts[2] == 'connected':
                is_connected = True
                break
        
        ssid = ""
        if is_connected:
            # Try to get SSID of active connection
            res_ssid = subprocess.run(["nmcli", "-t", "-f", "ACTIVE,SSID", "dev", "wifi"], capture_output=True, text=True)
            for line in res_ssid.stdout.splitlines():
                if line.startswith("yes:"):
                    ssid = line.split(":")[1]
                    break
            if not ssid:
                # Fallback to general active connection name
                res_con = subprocess.run(["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "con", "show", "--active"], capture_output=True, text=True)
                for line in res_con.stdout.splitlines():
                    p = line.split(':')
                    if len(p) >= 3 and p[1] == '802-11-wireless':
                        ssid = p[0]
                        break
        
        return is_connected, ssid
    except:
        pass
    return False, ""

def get_bluetooth_state():
    try:
        res = subprocess.run(["bluetoothctl", "show"], capture_output=True, text=True)
        powered = "Powered: yes" in res.stdout
        
        res_con = subprocess.run(["bluetoothctl", "info"], capture_output=True, text=True)
        connected = "Name:" in res_con.stdout
        
        return powered, connected
    except:
        pass
    return False, False

def update_config():
    wifi_connected, wifi_ssid = get_wifi_state()
    bt_powered, bt_connected = get_bluetooth_state()

    # WiFi Styles
    if wifi_connected:
        wifi_label = "󰖩"
        wifi_tooltip = f"Bağlı: {wifi_ssid}" if wifi_ssid else "WiFi: Bağlı"
    else:
        wifi_label = "󰖪"
        wifi_tooltip = "WiFi: Bağlantı Yok"

    # Bluetooth Styles
    if bt_connected:
        bt_label = "󰂯"
        bt_tooltip = "Bluetooth: Bağlı"
    elif bt_powered:
        bt_label = "󰂯"
        bt_tooltip = "Bluetooth: Açık"
    else:
        bt_label = "󰂲"
        bt_tooltip = "Bluetooth: Kapalı"

    try:
        with open(CONFIG_PATH, 'r', encoding='utf-8') as f:
            config = json.load(f)

        config['widget-config']['buttons-grid']['buttons-per-row'] = 5
        actions = config['widget-config']['buttons-grid']['actions']
        
        # WiFi (index 0)
        actions[0]['label'] = wifi_label
        actions[0]['tooltip'] = wifi_tooltip
        actions[0]['type'] = "toggle"
        actions[0]['active'] = wifi_connected
        actions[0]['command'] = "bash /home/fatih/.config/swaync/scripts/toggle_wifi.sh"
        
        # Bluetooth
        bt_exists = False
        for i, action in enumerate(actions):
            if "Bluetooth" in action.get('tooltip', ''):
                actions[i]['label'] = bt_label
                actions[i]['tooltip'] = bt_tooltip
                actions[i]['type'] = "toggle"
                actions[i]['active'] = bt_powered
                actions[i]['command'] = "bash /home/fatih/.config/swaync/scripts/toggle_bt.sh"
                bt_exists = True
                break
        
        if not bt_exists:
            actions.insert(1, {
                "label": bt_label,
                "tooltip": bt_tooltip,
                "type": "toggle",
                "active": bt_powered,
                "command": "bash /home/fatih/.config/swaync/scripts/toggle_bt.sh"
            })

        with open(CONFIG_PATH, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
            
        subprocess.run(["swaync-client", "-R"])
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    update_config()
