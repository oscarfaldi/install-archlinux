#!/bin/bash

# Pastikan script langsung berhenti jika ada command yang fail
set -euo pipefail

# Variable untuk workspace build AUR
BUILD_DIR="$HOME/downloads"

# --- 1. BOOTSTRAP: TOOLS ---
# base-devel (alat rakit), git (buat narik paru)
sudo pacman -Syu --needed --noconfirm base-devel git

# --- 2. AUR HELPER: PARU ---
# Pindah ke directory fisik untuk menghindari limitasi space/stabilitas tmpfs (RAM)
if ! command -v paru &> /dev/null; then
    echo "Installing Paru in ${BUILD_DIR}..."
    
    # Make sure directory ada sebelum cd agar script gak skip/error
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Bersihkan sisa clone lama jika ada konflik sebelumnya
    rm -rf paru
    
    git clone https://aur.archlinux.org/paru.git
    cd paru
    
    # Makepkg dijalankan, set -e akan menangkap jika kompilasi gagal di sini
    makepkg -si --noconfirm
    
    # Clean up setelah berhasil compile
    cd ..
    rm -rf paru
    cd ~
else
    echo "Paru sudah terinstall, skipping..."
fi

# --- 3. GRAPHICS & CORE ---
# Nvidia driver & XDG Portal (biar browser bisa buka file/folder)
sudo pacman -S --noconfirm \
    niri \
    xwayland-satellite \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-gnome \
    xdg-utils

# --- 4. NETWORK & ACCESS ---
# NetworkManager, Bluetooth, NFS (buat NAS), & Polkit (Pop-up Password)
sudo pacman -S --noconfirm \
    networkmanager \
    bluez \
    bluez-utils \
    nfs-utils \
    gvfs-nfs \
    gvfs \
    polkit-kde-agent

# --- 5. AUDIO & MEDIA ENGINE ---
# Pipewire (Audio), wireplumber (Session manager), ffmpeg (Codecs)
sudo pacman -S --needed --noconfirm \
    pipewire \
    pipewire-pulse \
    wireplumber \
    ffmpeg \
    libwebp \
    libavif

# --- 6. SYSTEM UTILS & FONTS ---
# Kitty (Terminal), JetBrains Mono (Font), btop (Task Manager), hypridle (Timeout)
sudo pacman -S --noconfirm \
    alacritty \
    ttf-jetbrains-mono-nerd \
    greetd \
    greetd-tuigreet \
    fastfetch \
    btop \
    swayidle \
    swaylock \
    wl-clipboard \
    ffmpegthumbnailer \
    tumbler \
    ufw \
    mousepad \
    zoxide \
    eza \
    bat \
    gnome-calculator

# --- 7. APPS (OFFICIAL REPO) ---
# Thunar, Waybar, Mako (Notification), Rofi (Application Launcher Native Wayland)
sudo pacman -S --needed --noconfirm \
    thunar \
    waybar \
    qt5-wayland \
    qt6-wayland \
    okular \
    mpv \
    imv \
    obsidian \
    syncthing \
    grim \
    slurp \
    thunar-archive-plugin \
    thunar-volman \
    libnotify \
    mako \
    fuzzel \
    playerctl \
    file-roller \
    unzip \
    p7zip \
    unrar \
    ripgrep \
    fd \
    fzf \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra

# --- 8. AUR APPS (THE FINAL TOUCH) ---
# Brave, OnlyOffice, Hyprshot, Wallpaper tool, Theme Manager
paru -S --noconfirm \
    brave-bin \
    onlyoffice-bin \
    swww

# --- 9. FINISHING ---
# Aktifkan network services agar langsung jalan
sudo systemctl enable --now NetworkManager

# Aktifkan greeter greetd
sudo systemctl enable greetd

# Aktifin firewall
sudo systemctl enable --now ufw

# Bluetooth
sudo systemctl enable --now bluetooth.service

echo "Rebuild selesai! Sistem lo bener-bener clean & lean sekarang Fal."
