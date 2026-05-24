#!/bin/bash

set -euo pipefail

sudo pacman -S --needed --noconfirm \
    ly

# Disable other display/login managers
sudo systemctl disable greetd.service 2>/dev/null || true
sudo systemctl disable sddm.service 2>/dev/null || true

# Prevent tty1 conflict
sudo systemctl disable getty@tty1.service 2>/dev/null || true

# Enable Ly on tty1
sudo systemctl enable ly@tty1.service

echo "Ly installed and enabled on tty1."
