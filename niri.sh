#!/bin/bash

set -euo pipefail

# Install paket-paket yang dibutuhkan
sudo pacman -S --needed --noconfirm \
    niri \
    xwayland-satellite \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-gnome \
    xdg-utils \
    waybar \
    mako \
    fuzzel \
    swaylock \
    swayidle \
    grim \
    slurp \
    libnotify \
    playerctl \
    qt5-wayland \
    qt6-wayland

mkdir -p ~/.config/niri
mkdir -p ~/Pictures/Screenshots

# Copy default config hanya jika user config belum ada
if [ ! -f ~/.config/niri/config.kdl ]; then
    cp /etc/niri/config.kdl ~/.config/niri/config.kdl
fi

# Disable startup hotkey popup (Disambung dengan \ karena lanjut ke baris bawah)
sed -i 's|// skip-at-startup|skip-at-startup|' \
    ~/.config/niri/config.kdl

# Start mako automatically jika belum terdaftar
grep -q 'spawn-at-startup "mako"' ~/.config/niri/config.kdl || \
    sed -i '/spawn-at-startup "waybar"/a spawn-at-startup "mako"' \
    ~/.config/niri/config.kdl

echo "Niri setup complete."
