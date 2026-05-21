# =============================================================================
# Raspberry Pi Kiosk – Konfiguration
# =============================================================================

# Google Slides URL (Edit- oder Share-URL, wird automatisch konvertiert)
SLIDE_URL="https://docs.google.com/presentation/d/e/2PACX-1vSkuEFjd73CVH1MaXYf2FZx1GVAQUtKHioFOvEbJ_q9SJlhtCwlfvpO5HM_NPe4n8kK1NHVxnCKe5aZ/pub?start=true&loop=false&delayms=3000"

# Mauszeiger verstecken (true/false)
HIDE_CURSOR=true

# -----------------------------------------------------------------------------
# WLAN – primaeres Netzwerk (Ladenlokal)
# -----------------------------------------------------------------------------
# Wird beim Setup mit hoher autoconnect-Prioritaet angelegt, sodass der Pi
# sich bevorzugt hiermit verbindet. Ein vorhandenes Hotspot-Profil bleibt
# als Fallback bestehen.
WIFI_SSID="Scoozi_Devices"
WIFI_PSK="DknzB3640!"

# -----------------------------------------------------------------------------
# Tailscale
# -----------------------------------------------------------------------------
# Hostname, unter dem der Pi im Tailnet erscheint.
# Leer lassen ("") -> Tailscale verwendet den System-Hostnamen.
TS_HOSTNAME="scoozi-raspberry"
