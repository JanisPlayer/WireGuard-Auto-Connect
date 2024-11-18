#!/bin/bash

# Konfigurationsvariablen (mehrere SSIDs und MAC-Adressen durch | getrennt)
HOME_SSID="DeineSSID|AndereSSIDt"
HOME_MAC="XX:XX:XX:XX:XX:XX|AndereMac"
WG_INTERFACE="wg0"
NETWORK_PREFIXES="enp|eth|wlp|wlan"  # Präfixe für die Netzwerkschnittstellen

# Aktuelle SSID abrufen
CURRENT_SSID=$(iwgetid -r 2>/dev/null)

# Aktuelle MAC-Adresse des Routers abrufen (Standard-Gateway)
CURRENT_MAC=$(ip route | grep default | awk '{print $3}' | xargs -I {} arp -n {} | awk '/ether/ {print $3}')

# Status von WireGuard prüfen
WG_ACTIVE=$(wg show $WG_INTERFACE 2>/dev/null | grep -c "interface: $WG_INTERFACE")

# Prüfen, ob mindestens eine Netzwerkschnittstelle mit den gewünschten Präfixen aktiv ist
NETWORK_ACTIVE=$(ip link show | grep -E "state UP" | grep -E "$NETWORK_PREFIXES" | wc -l)

# Hauptlogik zur (De-)Aktivierung
if [ "$NETWORK_ACTIVE" -eq 0 ]; then
    echo "Kein aktives Netzwerk vorhanden. WireGuard wird nicht aktiviert."
    if [ "$WG_ACTIVE" -eq 1 ]; then
        echo "WireGuard wird deaktiviert, da keine Netzwerkverbindung besteht."
        wg-quick down $WG_INTERFACE
    fi
else
    # Überprüfen, ob die aktuelle SSID oder MAC mit einer der erlaubten übereinstimmt
    if echo "$CURRENT_SSID" | grep -Eq "$HOME_SSID" || echo "$CURRENT_MAC" | grep -Eq "$HOME_MAC"; then
        if [ "$WG_ACTIVE" -eq 1 ]; then
            echo "WireGuard ist aktiv und im Heimnetzwerk (basierend auf SSID oder MAC) - Deaktivierung."
            wg-quick down $WG_INTERFACE
        else
            echo "WireGuard bereits deaktiviert oder nicht aktiv."
        fi
    else
        if [ "$WG_ACTIVE" -eq 0 ]; then
            echo "Nicht im Heimnetzwerk - WireGuard wird aktiviert."
            wg-quick up $WG_INTERFACE
        else
            echo "WireGuard bereits aktiviert."
        fi
    fi
fi
