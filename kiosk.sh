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
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Wayland (labwc): Idle-Management über labwc-Konfiguration
    echo "[kiosk] Wayland erkannt – xset übersprungen."
else
    xset s off
    xset -dpms
    xset s noblank
fi

# Mauszeiger verstecken
if [ "$HIDE_CURSOR" = true ]; then
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        # Wayland: seat-Konfiguration für labwc
        mkdir -p "$HOME/.config/labwc"
        if ! grep -q "hide-cursor-timeout" "$HOME/.config/labwc/rc.xml" 2>/dev/null; then
            echo "[kiosk] Cursor-Hiding für Wayland nicht aktiv – siehe labwc rc.xml"
        fi
    else
        if command -v unclutter &>/dev/null; then
            unclutter -idle 0.1 -root &
        fi
    fi
fi

# Alte Chromium-Crashflags entfernen
CHROMIUM_DIR="$HOME/.config/chromium"
if [ -d "$CHROMIUM_DIR/Default" ]; then
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$CHROMIUM_DIR/Default/Preferences" 2>/dev/null
    sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$CHROMIUM_DIR/Default/Preferences" 2>/dev/null
fi

echo "[kiosk] Starte Chromium: $PUB_URL"

# Chromium-Binary erkennen
if command -v chromium-browser &>/dev/null; then
    CHROMIUM_BIN="chromium-browser"
elif command -v chromium &>/dev/null; then
    CHROMIUM_BIN="chromium"
else
    echo "[kiosk] FEHLER: Kein Chromium gefunden!"
    exit 1
fi

# Wayland-spezifische Flags
WAYLAND_FLAGS=""
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    WAYLAND_FLAGS="--ozone-platform=wayland --enable-features=UseOzonePlatform"
fi

# Chromium im Kiosk-Modus starten
exec "$CHROMIUM_BIN" \
    --kiosk \
    --noerrdialogs \
    --disable-infobars \
    --disable-session-crashed-bubble \
    --disable-restore-session-state \
    --incognito \
    --start-fullscreen \
    --check-for-update-interval=31536000 \
    --disable-component-update \
    --password-store=basic \
    $WAYLAND_FLAGS \
    "$PUB_URL"
