#!/bin/bash
# =============================================================================
# Raspberry Pi Kiosk – Installer
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "======================================="
echo "  Raspberry Pi Kiosk – Installation"
echo "======================================="
echo ""

# Session-Typ erkennen
SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"
echo "[install] Session-Typ: $SESSION_TYPE"

# unclutter installieren (nur für X11 – unter Wayland nicht nötig)
if [ "$HIDE_CURSOR" = true ] && [ "$SESSION_TYPE" != "wayland" ]; then
    echo "[install] Installiere unclutter..."
    sudo apt update -qq
    sudo apt install -y unclutter
fi

# kiosk.sh ausführbar machen
chmod +x "$SCRIPT_DIR/kiosk.sh"

# Autostart konfigurieren
if [ "$SESSION_TYPE" = "wayland" ]; then
    # labwc: Autostart über labwc-eigene Konfiguration
    LABWC_DIR="$HOME/.config/labwc"
    mkdir -p "$LABWC_DIR"

    AUTOSTART_FILE="$LABWC_DIR/autostart"
    KIOSK_LINE="$SCRIPT_DIR/kiosk.sh &"
    SYSTEM_AUTOSTART="/etc/xdg/labwc/autostart"

    if [ -f "$AUTOSTART_FILE" ] && grep -q "kiosk.sh" "$AUTOSTART_FILE"; then
        echo "[install] labwc autostart bereits konfiguriert."
    else
        echo "[install] Erstelle labwc autostart mit Kiosk-Eintrag..."
        # System-Autostart als Basis kopieren, dann Kiosk hinzufügen
        if [ -f "$SYSTEM_AUTOSTART" ]; then
            cp "$SYSTEM_AUTOSTART" "$AUTOSTART_FILE"
        fi
        echo "" >> "$AUTOSTART_FILE"
        echo "# Kiosk Mode" >> "$AUTOSTART_FILE"
        echo "$KIOSK_LINE" >> "$AUTOSTART_FILE"
    fi
    chmod +x "$AUTOSTART_FILE"
else
    # X11/GNOME: XDG Autostart
    AUTOSTART_DIR="$HOME/.config/autostart"
    mkdir -p "$AUTOSTART_DIR"

    cat > "$AUTOSTART_DIR/kiosk.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Kiosk
Comment=Google Slides Kiosk Mode
Exec=$SCRIPT_DIR/kiosk.sh
X-GNOME-Autostart-enabled=true
EOF
fi

# Bildschirm-Abschaltung deaktivieren (config.txt)
CONFIG_FILE="/boot/firmware/config.txt"
if [ -f "$CONFIG_FILE" ]; then
    if ! grep -q "hdmi_blanking=0" "$CONFIG_FILE"; then
        echo "[install] Deaktiviere HDMI-Blanking..."
        echo "" | sudo tee -a "$CONFIG_FILE" > /dev/null
        echo "# Kiosk: Bildschirm nicht abschalten" | sudo tee -a "$CONFIG_FILE" > /dev/null
        echo "hdmi_blanking=0" | sudo tee -a "$CONFIG_FILE" > /dev/null
    fi
fi

echo ""
echo "======================================="
echo "  Installation abgeschlossen!"
echo "  Neustart mit: sudo reboot"
echo "======================================="
