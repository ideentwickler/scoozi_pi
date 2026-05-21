#!/bin/bash
# =============================================================================
# Scoozi Pi – Komplett-Setup
# =============================================================================
# Richtet einen frisch geflashten Raspberry Pi vollstaendig ein:
#   1. System-Paketquellen aktualisieren (curl sicherstellen)
#   2. Tailscale installieren und mit dem Tailnet verbinden (inkl. Tailscale SSH)
#   3. Kiosk-Modus installieren (ruft install.sh auf)
#
# Aufruf (eine der Varianten):
#   ./setup.sh                        -> fragt den Auth-Key interaktiv ab
#   ./setup.sh --authkey tskey-xxxx   -> Auth-Key als Argument
#   TS_AUTHKEY=tskey-xxxx ./setup.sh  -> Auth-Key als Umgebungsvariable
#   echo tskey-xxxx > tailscale-authkey && ./setup.sh  -> Auth-Key aus Datei
#
# Auth-Key erzeugen: https://login.tailscale.com/admin/settings/keys
# (Die Datei tailscale-authkey ist via .gitignore vom Repo ausgeschlossen.)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "======================================="
echo "  Scoozi Pi – Komplett-Setup"
echo "======================================="
echo ""

# --- Auth-Key ermitteln ------------------------------------------------------
AUTHKEY="${TS_AUTHKEY:-}"

while [ $# -gt 0 ]; do
    case "$1" in
        --authkey)   AUTHKEY="${2:-}"; shift 2 ;;
        --authkey=*) AUTHKEY="${1#*=}"; shift ;;
        *)           echo "[setup] Unbekanntes Argument: $1"; shift ;;
    esac
done

if [ -z "$AUTHKEY" ] && [ -f "$SCRIPT_DIR/tailscale-authkey" ]; then
    AUTHKEY="$(tr -d '[:space:]' < "$SCRIPT_DIR/tailscale-authkey")"
    echo "[setup] Auth-Key aus Datei 'tailscale-authkey' gelesen."
fi

if [ -z "$AUTHKEY" ]; then
    echo "Tailscale Auth-Key wird benoetigt."
    echo "Erzeugen unter: https://login.tailscale.com/admin/settings/keys"
    echo ""
    read -rsp "Auth-Key (tskey-...): " AUTHKEY
    echo ""
fi

if [ -z "$AUTHKEY" ]; then
    echo "[setup] FEHLER: Kein Tailscale Auth-Key angegeben. Abbruch."
    exit 1
fi

# --- Primaeres WLAN konfigurieren --------------------------------------------
# Legt das Ladenlokal-WLAN mit hoher Prioritaet an. Ein vorhandener
# iPhone-Hotspot bleibt als Fallback erhalten. Das WLAN wird NICHT sofort
# aktiviert (das wuerde eine SSH-Sitzung ueber den Hotspot trennen) – es greift
# spaetestens nach dem abschliessenden Reboot.
if command -v nmcli &>/dev/null; then
    echo "[setup] Konfiguriere primaeres WLAN: $WIFI_SSID"
    if nmcli -t -f NAME connection show | grep -qx "$WIFI_SSID"; then
        sudo nmcli connection modify "$WIFI_SSID" \
            wifi-sec.key-mgmt wpa-psk \
            wifi-sec.psk "$WIFI_PSK" \
            connection.autoconnect yes \
            connection.autoconnect-priority 100
    else
        sudo nmcli connection add type wifi con-name "$WIFI_SSID" \
            ssid "$WIFI_SSID" \
            wifi-sec.key-mgmt wpa-psk \
            wifi-sec.psk "$WIFI_PSK" \
            connection.autoconnect yes \
            connection.autoconnect-priority 100
    fi
else
    echo "[setup] WARNUNG: nmcli nicht gefunden – WLAN nicht konfiguriert."
fi

# --- System vorbereiten ------------------------------------------------------
echo "[setup] Aktualisiere Paketquellen..."
sudo apt-get update -qq

if ! command -v curl &>/dev/null; then
    echo "[setup] Installiere curl..."
    sudo apt-get install -y curl
fi

# --- Tailscale installieren --------------------------------------------------
if command -v tailscale &>/dev/null; then
    echo "[setup] Tailscale ist bereits installiert."
else
    echo "[setup] Installiere Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
fi

# --- Mit dem Tailnet verbinden -----------------------------------------------
echo "[setup] Verbinde mit dem Tailnet (Tailscale SSH aktiv)..."
TS_UP_ARGS=(--authkey="$AUTHKEY" --ssh)
if [ -n "${TS_HOSTNAME:-}" ]; then
    TS_UP_ARGS+=(--hostname="$TS_HOSTNAME")
fi
sudo tailscale up "${TS_UP_ARGS[@]}"

echo "[setup] Tailscale verbunden. Adresse(n):"
tailscale ip 2>/dev/null || true
echo ""

# --- Kiosk-Modus installieren ------------------------------------------------
echo "[setup] Starte Kiosk-Installation..."
bash "$SCRIPT_DIR/install.sh"

echo ""
echo "======================================="
echo "  Setup abgeschlossen!"
echo "  Neustart mit: sudo reboot"
echo "======================================="
