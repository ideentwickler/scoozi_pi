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

# unclutter installieren (Mauszeiger verstecken)
if [ "$HIDE_CURSOR" = true ]; then
    echo "[install] Installiere unclutter..."
    sudo apt update -qq
    sudo apt install -y unclutter
fi

# kiosk.sh ausführbar machen
chmod +x "$SCRIPT_DIR/kiosk.sh"

# Autostart-Verzeichnis anlegen
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

# Autostart-Eintrag erstellen
cat > "$AUTOSTART_DIR/kiosk.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Kiosk
Comment=Google Slides Kiosk Mode
Exec=$SCRIPT_DIR/kiosk.sh
X-GNOME-Autostart-enabled=true
EOF

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
