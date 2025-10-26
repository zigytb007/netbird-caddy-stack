#!/bin/bash
# Automatisches Installationsskript für Netbird, Caddy und ZITADEL Cloud-Integration
# Dieses Skript ist für Debian 13 (Trixie) getestet.
set -e

echo "Aktualisiere Paketquellen..."
sudo apt update

# Notwendige Abhängigkeiten installieren
sudo apt install -y curl gnupg apt-transport-https lsb-release

# Netbird installieren, falls noch nicht vorhanden
if ! command -v netbird >/dev/null 2>&1; then
  echo "Installiere Netbird..."
  curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh
else
  echo "Netbird ist bereits installiert."
fi

# Caddy installieren, falls noch nicht vorhanden
if ! command -v caddy >/dev/null 2>&1; then
  echo "Füge das Caddy-Repository hinzu und installiere Caddy..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/caddy-stable-archive-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian all main" | sudo tee /etc/apt/sources.list.d/caddy-stable.list
  sudo apt update
  sudo apt install -y caddy
else
  echo "Caddy ist bereits installiert."
fi

# Beispiel-Caddyfile kopieren, falls vorhanden
if [ -f ./Caddyfile.example ]; then
  echo "Kopiere Caddyfile.example nach /etc/caddy/Caddyfile..."
  sudo cp ./Caddyfile.example /etc/caddy/Caddyfile
  sudo systemctl reload caddy
fi

echo "Installation abgeschlossen."
echo ""
echo "Bitte richte anschließend einen ZITADEL-OIDC-Client über das ZITADEL Cloud-Dashboard ein"
echo "und passe die Netbird-Konfiguration entsprechend an (z. B. netbird setup --oidc-domain <dein-zitadel-domain>)."
echo ""
echo "Weitere Informationen zur Installation findest du in den offiziellen Dokumentationen:"
echo "Netbird-Installation: https://docs.netbird.io/installation/quickstart-linux"
echo "Caddy-Installation:   https://caddyserver.com/docs/install"
echo "Self-hosted Zitadel (optional): https://docs.zitadel.com/docs/self-hosting/quickstart"
