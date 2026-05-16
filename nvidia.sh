#!/bin/bash

set -euo pipefail

sudo pacman -Syu --needed --noconfirm \
    nvidia-open \
    nvidia-utils \
    lib32-nvidia-utils \
    egl-wayland \
    xorg-xwayland

echo "options nvidia_drm modeset=1" | \
sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1 /' \
    /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

if ! grep -q "nvidia_drm" /etc/mkinitcpio.conf; then
    sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' \
    /etc/mkinitcpio.conf
fi

sudo mkinitcpio -P

echo "NVIDIA setup complete. Reboot required."
