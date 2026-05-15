#!/bin/bash

# --- 1. BOOTSTRAP: TOOLS ---
# base-devel (alat rakit), git (buat narik paru)
sudo pacman -Syu --needed --noconfirm base-devel git

# --- 2. AUR HELPER: PARU (DI /TMP) ---
# Menggunakan /tmp agar disk tetap bersih, otomatis hilang saat reboot
if ! command -v paru &> /dev/null; then
    echo "Installing Paru in /tmp..."
    cd /tmp
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin && makepkg -si --noconfirm
    cd .. && rm -rf paru-bin
    cd ~
fi

# --- 3. GRAPHICS & CORE ---
# Nvidia driver & XDG Portal (biar browser bisa buka file/folder)
sudo pacman -S --noconfirm \
    hyprland nvidia-dkms nvidia-utils \
    xdg-desktop-portal-hyprland

# --- 4. NETWORK & ACCESS ---
# NetworkManager, Bluetooth, NFS (buat NAS), & Polkit (Pop-up Password)
sudo pacman -S --noconfirm \
    networkmanager bluez bluez-utils \
    nfs-utils gvfs-nfs gvfs polkit-kde-agent

# --- 5. AUDIO & MEDIA ENGINE ---
# Pipewire (Audio), wireplumber (Session manager), ffmpeg (Codecs)
sudo pacman -S --needed --noconfirm \
    pipewire pipewire-pulse wireplumber \
    ffmpeg libwebp libavif

# --- 6. SYSTEM UTILS & FONTS ---
# Kitty (Terminal), JetBrains Mono (Font), btop (Task Manager), hypridle (Timeout)
sudo pacman -S --noconfirm \
    alacritty ttf-jetbrains-mono-nerd \
    fastfetch btop hypridle

# --- 7. APPS (OFFICIAL REPO) ---
# Thunar, Waybar, Mako (Notification), Rofi (Application Launcher Native Wayland)
sudo pacman -S --needed --noconfirm \
    thunar waybar qt5-wayland qt6-wayland \
    okular mpv imv obsidian syncthing \
    grim slurp thunar-archive-plugin thunar-volman \
    mako rofi

# --- 8. AUR APPS (THE FINAL TOUCH) ---
# Brave, OnlyOffice, Hyprshot, Wallpaper tool, Theme Manager
paru -S --noconfirm \
    brave-bin onlyoffice-bin hyprshot swww

# --- 9. FINISHING ---
# Aktifkan network services agar langsung jalan
sudo systemctl enable --now NetworkManager

# Bluetooth
sudo systemctl enable --now bluetooth.service

# Syncthing (USER SERVICE)
sudo systemctl enable --now syncthing.service

# Keep user service alive after logout
loginctl enable-linger $USER

echo "Rebuild selesai! Sistem lo bener-bener clean & lean sekarang Fal."
