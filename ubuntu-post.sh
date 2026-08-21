#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Updating package lists..."
apt update

echo "Upgrading installed packages..."
DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "Installing base packages..."
apt install -y \
    qemu-guest-agent \
    whois \
    curl \
    ca-certificates

echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "Enabling QEMU Guest Agent..."
systemctl enable --now qemu-guest-agent

echo "Removing unused packages..."
apt autoremove -y

echo
echo "Installation complete."
echo
echo "QEMU Guest Agent:"
systemctl --no-pager --full status qemu-guest-agent || true

echo
echo "Tailscale:"
tailscale version || true

echo
echo "Run the following to connect this VM to Tailscale:"
echo "sudo tailscale up"