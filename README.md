# Raspberry Pi Kiosk Mode – Google Slides

Zeigt eine Google Slides Präsentation im Vollbild-Kiosk-Modus auf einem Raspberry Pi (64-bit OS).

## Voraussetzungen

- Raspberry Pi mit Raspberry Pi OS (64-bit, Desktop)
- WLAN konfiguriert
- Chromium Browser (vorinstalliert)

## Installation

```bash
git clone https://github.com/DEIN-USERNAME/raspi-kiosk.git
cd raspi-kiosk
chmod +x install.sh
./install.sh
sudo reboot
```

## Konfiguration

Die Präsentations-URL und andere Einstellungen kannst du in `config.sh` anpassen:

| Variable | Beschreibung |
|---|---|
| `SLIDE_URL` | Google Slides URL (wird automatisch auf `/pub` umgeschrieben) |
| `HIDE_CURSOR` | Mauszeiger verstecken (`true`/`false`) |

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
