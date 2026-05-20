#!/bin/bash

set -euo pipefail

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

# Copy default config only if user config doesn't exist

if [ ! -f ~/.config/niri/config.kdl ]; then
cp /usr/share/niri/config.kdl ~/.config/niri/config.kdl
fi

# Disable startup hotkey popup

sed -i 's|// skip-at-startup|skip-at-startup|' 
~/.config/niri/config.kdl

# Start mako automatically if not already present

grep -q 'spawn-at-startup "mako"' ~/.config/niri/config.kdl || 
sed -i '/spawn-at-startup "waybar"/a spawn-at-startup "mako"' 
~/.config/niri/config.kdl

# Add custom screenshot bind if not already present

grep -q 'Screenshot Saved' ~/.config/niri/config.kdl || cat >> ~/.config/niri/config.kdl <<'EOF'

```
Ctrl+Shift+C {
    spawn-sh "
    mkdir -p ~/Pictures/Screenshots &&
    FILE=~/Pictures/Screenshots/\$(date +'%Y-%m-%d_%H-%M-%S').png &&
    grim -g \"\$(slurp)\" \"\$FILE\" &&
    notify-send 'Screenshot Saved' \"\$FILE\"
    "
}
```

EOF

echo "Niri setup complete."
