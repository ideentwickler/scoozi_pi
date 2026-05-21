# Raspberry Pi Kiosk Mode – Google Slides

Zeigt eine Google Slides Präsentation im Vollbild-Kiosk-Modus auf einem Raspberry Pi (64-bit OS) und bindet den Pi via Tailscale ins Tailnet ein.

## Voraussetzungen

- Raspberry Pi mit Raspberry Pi OS (64-bit, Desktop, labwc/Wayland)
- WLAN bereits in Raspberry Pi Imager konfiguriert
- SSH aktiviert (in Raspberry Pi Imager)
- Chromium Browser (vorinstalliert)
- Ein Tailscale Auth-Key (siehe unten)

## Einrichtung nach Neu-Flash

Nach dem Flashen der SD-Karte und der ersten Verbindung per SSH (`ssh scoozi@scoozi-raspberry`):

```bash
git clone https://github.com/ideentwickler/scoozi_pi.git
cd scoozi_pi
chmod +x setup.sh
./setup.sh
sudo reboot
```

`setup.sh` erledigt alles in einem Rutsch:

1. Paketquellen aktualisieren
2. **Tailscale** installieren und mit dem Tailnet verbinden (Tailscale SSH aktiv)
3. **Kiosk-Modus** installieren (Autostart, Desktop-Autologin, HDMI-Blanking aus)

Nach dem Reboot bootet der Pi automatisch in den Desktop und startet Chromium im Kiosk-Modus.

## Tailscale Auth-Key

Der Auth-Key verbindet den Pi ohne Browser-Login mit deinem Tailnet.

1. Key erzeugen: <https://login.tailscale.com/admin/settings/keys> → *Generate auth key*
2. An `setup.sh` übergeben – eine der Varianten:

   ```bash
   ./setup.sh                          # fragt den Key interaktiv ab
   ./setup.sh --authkey tskey-xxxx     # Key als Argument
   TS_AUTHKEY=tskey-xxxx ./setup.sh    # Key als Umgebungsvariable
   echo tskey-xxxx > tailscale-authkey && ./setup.sh   # Key aus Datei
   ```

Die Datei `tailscale-authkey` ist via `.gitignore` vom Repo ausgeschlossen und wird nie committet.

## Konfiguration

Einstellungen in `config.sh`:

| Variable | Beschreibung |
|---|---|
| `SLIDE_URL` | Google Slides URL (wird automatisch auf `/pub` umgeschrieben) |
| `HIDE_CURSOR` | Mauszeiger verstecken (`true`/`false`) |
| `TS_HOSTNAME` | Hostname des Pi im Tailnet (leer = System-Hostname) |

## Nur Kiosk installieren (ohne Tailscale)

```bash
chmod +x install.sh
./install.sh
sudo reboot
```

## Deinstallation

```bash
chmod +x uninstall.sh
./uninstall.sh
sudo reboot
```

## Tastenkürzel

| Taste | Aktion |
|---|---|
| `Alt + F4` | Chromium schließen |
| `Ctrl + Alt + F1` | Terminal öffnen |
| `Ctrl + Alt + F7` | Zurück zum Desktop |

## Lizenz

MIT
