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
- `config.sh` – Konfiguration (Slide-URL, Cursor-Hiding)
- `kiosk.sh` – Browser-Startscript (Netzwerk-Check, Chromium Kiosk-Modus)
- `install.sh` – Installer (Autostart, HDMI-Blanking)
- `uninstall.sh` – Deinstallation
- Autostart via `~/.config/labwc/autostart` (Wayland)
