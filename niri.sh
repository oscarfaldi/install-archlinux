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

mkdir -p ~/.config/niri
mkdir -p ~/Pictures/Screenshots

echo "Niri setup complete."
