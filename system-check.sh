#!/bin/bash
set -e
echo "===== HOST INFORMATION ====="
hostnamectl
echo -e "\n===== OS RELEASE ====="
(lsb_release -a 2>/dev/null || cat /etc/os-release) || true
echo -e "\n===== KERNEL ====="
uname -a
echo -e "\n===== RUNNING SERVICES ====="
systemctl list-units --type=service --state=running | head -n 40
echo -e "\n===== NETWORK PORTS ====="
ss -tuln | grep -E "80|443|33073|51820" || echo "Keine relevanten Ports gefunden"
echo -e "\n===== INSTALLED PACKAGES ====="
dpkg --get-selections | grep -E "netbird|caddy|nginx|postgres|mysql|docker" || echo "Keine dieser Pakete gefunden"
echo -e "\n===== RESOURCE USAGE ====="
df -h
free -m
