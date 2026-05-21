#!/bin/bash
# =============================================================================
# Raspberry Pi Kiosk – Uninstaller
# =============================================================================

echo "======================================="
echo "  Raspberry Pi Kiosk – Deinstallation"
echo "======================================="
echo ""

# Autostart entfernen
AUTOSTART_FILE="$HOME/.config/autostart/kiosk.desktop"
if [ -f "$AUTOSTART_FILE" ]; then
    rm "$AUTOSTART_FILE"
    echo "[uninstall] Autostart-Eintrag entfernt."
fi

echo ""
echo "======================================="
echo "  Deinstallation abgeschlossen!"
echo "  Neustart mit: sudo reboot"
echo "======================================="
