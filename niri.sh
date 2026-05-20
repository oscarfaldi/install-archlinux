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

cat > ~/.config/niri/config.kdl << 'EOF'
binds {
    Mod+T { spawn "alacritty"; }
    Mod+D { spawn "fuzzel"; }
    Mod+Shift+E { quit; }
}

spawn-at-startup "waybar"
spawn-at-startup "mako"
EOF

echo "Niri setup complete."
