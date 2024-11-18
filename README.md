# WireGuard Auto Connect

## English Version

This script enables you to **automatically activate or deactivate WireGuard** based on the network your device is connected to. It checks the currently connected **SSID** or **MAC address** and ensures that WireGuard is only active when you are not at home. Otherwise, it is automatically deactivated when you are in your home network.

### Prerequisites

Before using the script, make sure the following packages are installed:

- `wireguard-tools` (for WireGuard)
- `iw` (for retrieving the SSID)
- `arp` (for retrieving the MAC address of the router)
- `grep`, `awk`, `xargs` (for network analysis)

#### Installation

1. Install the necessary packages, if not already done:

   ```bash
   sudo apt update
   sudo apt install wireguard-tools iw net-tools iproute2
   ```

2. Download the script:

   ```bash
   wget https://raw.githubusercontent.com/JanisPlayer/WireGuard-Auto-Connect/refs/heads/main/wg_auto_connect.sh
   sudo chmod 700 ./wg_auto_connect.sh
   sudo chown -R root:root ./wg_auto_connect.sh
   ```

### Configuration

Edit the script `wg_auto_connect.sh` and adjust the following configuration variables:

- **HOME_SSID**: The SSID of your home network. You can separate multiple SSIDs with a `|` character.
- **HOME_MAC**: The MAC address of your router. You can also separate multiple MAC addresses with a `|` character.
- **WG_INTERFACE**: The name of your WireGuard interface (usually `wg0`).
- **NETWORK_PREFIXES**: Here you can specify the prefixes of your network interfaces (e.g., `enp`, `wlp`, `eth`, `wlan`).

Example:

```bash
HOME_SSID="YourHomeSSID|AnotherSSID"
HOME_MAC="XX:XX:XX:XX:XX:XX|AnotherMac"
WG_INTERFACE="wg0"
NETWORK_PREFIXES="enp|eth|wlp|wlan"
```

### Finding Necessary Information:

To find the MAC address of your router, run:

```bash
ip route | grep default | awk '{print $3}' | xargs -I {} arp -n {} | awk '/ether/ {print $3}'
```

To find the SSID, run:

```bash
iwgetid -r
```

You can find the `WG_INTERFACE` in your `/etc/wireguard` configuration. The name of the configuration must be specified there.  
If this file does not exist, add your configuration file to the directory.

3. Move the script to a directory:

   ```bash
   sudo mv ./wg_auto_connect.sh /root/wg_auto_connect.sh
   ```

### Usage

1. **Run the script to test**:

   After adjusting the configuration, you can run the script directly to test it:

   ```bash
   /root/wg_auto_connect.sh
   ```

   It will automatically check if you are connected to your home network and enable or disable WireGuard based on the network environment.

2. **Automate with Cron**:

   You can run the script regularly using Cron. Add it to your Crontab:

   ```bash
   sudo crontab -e
   ```

   Example: Run every minute:

   ```bash
   * * * * * /root/wg_auto_connect.sh
   ```

   Alternative way to add via a temporary file:

   ```bash
   crontab -u root -l > /tmp/tmp_crontab && echo "* * * * * /root/wg_auto_connect.sh" >> /tmp/tmp_crontab
   crontab -u root /tmp/tmp_crontab && rm /tmp/tmp_crontab
   ```

### Script Explanation

1. **Network Check**: It checks which network you are connected to, either through SSID (WiFi) or the MAC address of the router (Ethernet).
2. **WireGuard Status**: If you are connected to your home network (based on SSID or MAC address), WireGuard is disabled. Otherwise, WireGuard is enabled.
3. **Regular Expressions**: You can specify multiple SSIDs and MAC addresses, separated by the pipe character `|`, to support multiple networks.

### Issues

- In the GUI, the adapter may be duplicated during start and stop operations until the computer is restarted.

---

## Deutsche Version

Dieses Skript ermöglicht es dir, **WireGuard** automatisch zu aktivieren oder zu deaktivieren, basierend auf dem Netzwerk, mit dem dein Gerät verbunden ist. Es prüft die aktuell verbundene **SSID** oder **MAC-Adresse** und stellt sicher, dass WireGuard nur dann aktiv ist, wenn du dich nicht im heimischen Netzwerk befindest. Andernfalls wird es automatisch deaktiviert, wenn du zu Hause bist.

### Voraussetzungen

Bevor du das Skript verwendest, stelle sicher, dass du folgende Programme installiert hast:

- `wireguard-tools` (für WireGuard)
- `iw` (für das Abrufen der SSID)
- `arp` (für das Abrufen der MAC-Adresse des Routers)
- `grep`, `awk`, `xargs` (für die Netzwerkanalyse)

#### Installation

1. Installiere die benötigten Programme, falls noch nicht geschehen:

   ```bash
   sudo apt update
   sudo apt install wireguard-tools iw net-tools iproute2
   ```

2. Lade das Skript herunter:

   ```bash
   wget https://raw.githubusercontent.com/JanisPlayer/WireGuard-Auto-Connect/refs/heads/main/wg_auto_connect.sh
   sudo chmod 700 ./wg_auto_connect.sh
   sudo chown -R root:root ./wg_auto_connect.sh
   ```

### Konfiguration

Bearbeite das Skript `wg_auto_connect.sh` und passe folgende Konfigurationsvariablen an:

- **HOME_SSID**: Die SSID deines Heimnetzwerks. Du kannst mehrere SSIDs durch ein `|`-Symbol trennen.
- **HOME_MAC**: Die MAC-Adresse deines Routers. Auch hier kannst du mehrere MAC-Adressen durch ein `|`-Symbol trennen.
- **WG_INTERFACE**: Der Name deines WireGuard-Interfaces (meistens `wg0`).
- **NETWORK_PREFIXES**: Hier kannst du die Präfixe deiner Netzwerkinterfaces angeben (z. B. `enp`, `wlp`, `eth`, `wlan`).

Beispiel:

```bash
HOME_SSID="DeineHeimSSID|AndereSSID"
HOME_MAC="XX:XX:XX:XX:XX:XX|AndereMac"
WG_INTERFACE="wg0"
NETWORK_PREFIXES="enp|eth|wlp|wlan"
```

### Nötige Informationen herausfinden:

Um die MAC-Adresse deines Routers herauszufinden, gib Folgendes ein:

```bash
ip route | grep default | awk '{print $3}' | xargs -I {} arp -n {} | awk '/ether/ {print $3}'
```

Die SSID kannst du mit folgendem Befehl herausfinden:

```bash
iwgetid -r
```

Das `WG_INTERFACE` findest du in deiner `/etc/wireguard`-Konfiguration. Der Name der Konfiguration muss dort angegeben werden.  
Falls diese Datei nicht existiert, füge deine Konfigurationsdatei dem Verzeichnis hinzu.

3. Verschiebe das Skript in ein Verzeichnis:

   ```bash
   sudo mv ./wg_auto_connect.sh /root/wg_auto_connect.sh
   ```

### Verwendung

1. **Das Skript ausführen zum Testen**:

   Nachdem du die Konfiguration angepasst hast, kannst du das Skript direkt ausführen, um es zu testen:

   ```bash
   /root/wg_auto_connect.sh
   ```

   Es wird automatisch überprüfen, ob du mit deinem Heimnetzwerk verbunden bist und WireGuard ein- oder ausschalten, je nach der Netzwerkumgebung.

2. **Automatisierung mit Cron**:

   Du kannst das Skript regelmäßig ausführen lassen. Füge es dazu deiner Crontab hinzu:

   ```bash
   sudo crontab -e
   ```

   Beispiel: Jede Minute ausführen:

   ```bash
   * * * * * /root/wg_auto_connect.sh
   ```

   Alternativ:

   ```bash
   crontab -u root -l > /tmp/tmp_crontab && echo "* * * * * /root/wg_auto_connect.sh" >> /tmp/tmp_crontab
   crontab -u root /tmp/tmp_crontab && rm /tmp/tmp_crontab
   ```

### Erklärung des Skripts

1. **Netzwerkprüfung**: Es prüft, mit welchem Netzwerk du verbunden bist – entweder durch die SSID (WiFi) oder die MAC-Adresse des Routers (Ethernet).
2. **WireGuard-Status**: Wenn du mit dem Heimnetzwerk verbunden bist (basierend auf SSID oder MAC-Adresse), wird WireGuard deaktiviert. Andernfalls wird WireGuard aktiviert.
3. **Reguläre Ausdrücke**: Du kannst mehrere SSIDs und MAC-Adressen angeben, getrennt durch das Pipe-Zeichen `|`, um mehrere Netzwerke zu unterstützen.

### Probleme

- In der GUI dupliziert sich der Adapter beim Starten und Stoppen, bis der Computer neu gestartet wird.
