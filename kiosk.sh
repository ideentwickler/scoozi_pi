#!/bin/bash
# =============================================================================
# Raspberry Pi Kiosk – Browser Startscript
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Google Slides URL in Präsentations-URL umwandeln
# /edit?... oder /pub?... wird zu /pub?start=true&loop=true&delayms=5000
PUB_URL=$(echo "$SLIDE_URL" | sed 's|/edit.*|/pub?start=true\&loop=true\&delayms=5000|' | sed 's|/pub.*|/pub?start=true\&loop=true\&delayms=5000|')

# Warten bis Netzwerk verfügbar ist
echo "[kiosk] Warte auf Netzwerkverbindung..."
while ! ping -c 1 -W 2 google.com &>/dev/null; do
    sleep 2
done
echo "[kiosk] Netzwerk verfügbar."

# Bildschirmschoner / Energiesparmodus deaktivieren
xset s off
xset -dpms
xset s noblank

# Mauszeiger verstecken
if [ "$HIDE_CURSOR" = true ]; then
    if command -v unclutter &>/dev/null; then
        unclutter -idle 0.1 -root &
    fi
fi

# Alte Chromium-Crashflags entfernen
CHROMIUM_DIR="$HOME/.config/chromium"
if [ -d "$CHROMIUM_DIR/Default" ]; then
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$CHROMIUM_DIR/Default/Preferences" 2>/dev/null
    sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$CHROMIUM_DIR/Default/Preferences" 2>/dev/null
fi

echo "[kiosk] Starte Chromium: $PUB_URL"

# Chromium im Kiosk-Modus starten
exec chromium-browser \
    --kiosk \
    --noerrdialogs \
    --disable-infobars \
    --disable-session-crashed-bubble \
    --disable-restore-session-state \
    --incognito \
    --start-fullscreen \
    --check-for-update-interval=31536000 \
    --disable-component-update \
    "$PUB_URL"
