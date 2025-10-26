# Netbird‑Caddy‑Stack  

Dieses Repository stellt ein Skript und Beispielkonfigurationen bereit, um Netbird (WireGuard-basiertes Mesh‑VPN) und den Webserver Caddy auf einem Debian 13 „Trixie“-VPS zu installieren und mit der ZITADEL Cloud zu verwenden. Ziel ist es, eine automatisierte Installation zu ermöglichen und ZITADEL als Identity Provider zu nutzen, ohne ZITADEL lokal zu hosten.  

## Voraussetzungen  
- Ein VPS mit Debian 13 „Trixie“ und Root-Zugriff.  
- Ein Konto bei [Zitadel Cloud](https://zitadel.com) sowie ein OIDC‑Client (Client ID und Secret) in einem Projekt.  
- Ein DNS-Eintrag, der auf die IP deines Servers zeigt, wenn TLS-Zertifikate per Let's Encrypt ausgestellt werden sollen.  

## Installation  
Führe das Skript `install.sh` mit Root-Rechten aus, um Netbird und Caddy zu installieren:  

```bash  
curl -fsSL https://raw.githubusercontent.com/zigytb007/netbird-caddy-stack/main/install.sh | sudo bash  
```  

Das Skript erledigt folgende Schritte:  
- Aktualisiert die Paketlisten und installiert grundlegende Abhängigkeiten.  
- Installiert Netbird über die offizielle Installationsroutine.  
- Richtet das offizielle Caddy-Repository ein und installiert Caddy.  
- Kopiert `Caddyfile.example` nach `/etc/caddy/Caddyfile`, wenn die Datei vorhanden ist, und startet Caddy neu.  
- Erstellt eine Beispielkonfiguration für Netbird und gibt Hinweise für die weitere Einrichtung mit ZITADEL aus.  

## ZITADEL‑Integration  
1. Melde dich bei der ZITADEL Cloud an und erstelle in deinem Projekt einen OIDC‑Client.  
2. Notiere dir die **Issuer‑URL**, **Client ID** und **Client Secret**.  
3. Verbinde den Netbird‑Controller mit ZITADEL, indem du entweder die Netbird‑Weboberfläche verwendest oder auf dem Server den OIDC‑Login durchführst:  

```bash  
sudo netbird login --oidc-domain <deine-zitadel-domain>  
```  

4. Trage die OIDC‑Werte in die Netbird‑Konfigurationsdatei (`/etc/netbird/netbird.conf`) ein, falls erforderlich.  

## Beispiel‑Caddyfile  
Die Datei `Caddyfile.example` zeigt, wie Caddy als Reverse‑Proxy für den Netbird‑Controller verwendet werden kann. Passe die Domain und ggf. die Ports an deine Umgebung an:  

```
# Beispiel: Reverse‑Proxy für Netbird Management
your-domain.example {
    reverse_proxy 127.0.0.1:33073
    # TLS-Zertifikate werden automatisch über Let's Encrypt verwaltet
}
```  

Kopiere die angepasste Datei nach `/etc/caddy/Caddyfile` und starte Caddy neu:  

```bash  
sudo cp Caddyfile.example /etc/caddy/Caddyfile  
sudo systemctl reload caddy  
```  

## Verwendung  
Nach der Installation:  
- Erstelle über die Netbird‑Weboberfläche ein neues Netzwerk und notiere dir den **Setup‑Key**.  
- Installiere den Netbird‑Client auf den Endgeräten und verbinde sie mithilfe des Setup‑Keys mit deinem Netzwerk.  
- Verwende die Netbird‑UI oder die CLI, um Peers zu verwalten und Zugriffsregeln zu definieren.  

## Ein‑Kommando‑Deployment  
Die komplette Installation lässt sich mit einem einzigen Befehl ausführen:  

```bash  
bash <(curl -fsSL https://raw.githubusercontent.com/zigytb007/netbird-caddy-stack/main/install.sh)  
```  

Dieses Repository steht für Verbesserungsvorschläge offen. Erstelle gern ein Issue oder einen Pull Request, falls du Ideen oder Probleme hast.
