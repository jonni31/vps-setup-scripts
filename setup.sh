#!/bin/bash
set -euo pipefail
echo "=== VPS Setup ==="
[[ $EUID -ne 0 ]] && echo "Run as root" && exit 1
apt update && apt upgrade -y
apt install -y curl wget git htop tmux ufw fail2ban jq

# Docker
if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker && systemctl start docker
fi

# Firewall
ufw default deny incoming && ufw default allow outgoing
ufw allow ssh && ufw allow 80/tcp && ufw allow 443/tcp
ufw --force enable

# Fail2ban
systemctl enable fail2ban && systemctl restart fail2ban

# Swap
if ! swapon --show | grep -q swapfile; then
    fallocate -l 2G /swapfile && chmod 600 /swapfile
    mkswap /swapfile && swapon /swapfile
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi
echo "[+] Done"
