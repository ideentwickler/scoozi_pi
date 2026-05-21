# Scoozi Pi – Kiosk Mode

## Repository
- GitHub: https://github.com/ideentwickler/scoozi_pi
- Branch: main

## Deployment Workflow
- Änderungen lokal committen & nach GitHub pushen
- Auf dem Raspberry Pi via `git pull` aktualisieren
- **NICHT** direkt per `scp` auf den Pi kopieren

## Raspberry Pi Zugang
- SSH: `ssh scoozi@scoozi-raspberry` (Key-Auth, kein Passwort)
- OS: Raspberry Pi OS 64-bit (Debian, aarch64)
- Desktop: labwc (Wayland), NICHT X11/GNOME
- Chromium Binary: `chromium` (nicht `chromium-browser`)
- Repo auf Pi: `~/scoozi_pi`

## Architektur
- `config.sh` – Konfiguration (Slide-URL, Cursor-Hiding, WLAN, Tailscale-Hostname)
- `setup.sh` – Bootstrap nach Neu-Flash: WLAN anlegen, Tailscale installieren + verbinden, dann `install.sh`
- `kiosk.sh` – Browser-Startscript (Netzwerk-Check, Chromium Kiosk-Modus)
- `install.sh` – Installer (Autostart, Desktop-Autologin, HDMI-Blanking)
- `uninstall.sh` – Deinstallation
- Autostart via `~/.config/labwc/autostart` (Wayland)

## Tailscale
- Verbindung via Auth-Key (Tailscale Admin Console → Settings → Keys)
- `setup.sh` ruft `tailscale up --authkey=... --ssh --hostname=...`
- Auth-Key NICHT committen – Datei `tailscale-authkey` ist in `.gitignore`

## Hinweis zu Session-Erkennung
- Wird ein Script per SSH ausgeführt, ist `XDG_SESSION_TYPE` leer.
- `install.sh`/`kiosk.sh` erkennen labwc dann über `/etc/xdg/labwc` bzw. das `labwc`-Binary
  und behandeln den Pi korrekt als Wayland.
