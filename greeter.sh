#!/bin/bash

set -euo pipefail

sudo pacman -S --needed --noconfirm greetd tuigreet

sudo mkdir -p /etc/greetd

sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd niri-session"
user = "greeter"
EOF

sudo systemctl disable sddm 2>/dev/null || true
sudo systemctl enable greetd

echo "greetd + tuigreet installed."
