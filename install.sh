#!/bin/bash
set -e
echo "Aktualisiere Paketquellen..."
sudo apt update
sudo apt install -y curl gnupg apt-transport-https lsb-release
# Netbird installieren, falls noch nicht vorhanden
if ! command -v netbird >/dev/null 2>&1; then
  echo "Installiere Netbird..."
  curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh
else
  echo "Netbird ist bereits installiert."
fi
# Caddy installieren, falls noch nicht vorhanden oder laufend
if ! command -v caddy >/dev/null 2>&1 && ! pgrep -x caddy >/dev/null 2>&1; then
  echo "Füge das Caddy-Repository hinzu und installiere Caddy..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/caddy-stable-archive-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian all main' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
  sudo apt update
  sudo apt install -y caddy
else
  echo "Caddy ist bereits installiert oder läuft."
fi
# Beispiel-Caddyfile kopieren
if [ -f ./Caddyfile.example ]; then
  echo "Kopiere Caddyfile.example nach /etc/caddy/Caddyfile..."
  sudo cp ./Caddyfile.example /etc/caddy/Caddyfile
  sudo systemctl reload caddy || true
fi
echo "Installation abgeschlossen."
echo ""
echo "Bitte richte anschließend einen ZITADEL-OIDC-Client ein und passe die Netbird-Konfiguration an."
