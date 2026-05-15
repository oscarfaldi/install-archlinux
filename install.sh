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
    hyprland nvidia nvidia-utils \
    xdg-desktop-portal-hyprland

# --- 4. NETWORK & ACCESS ---
# NetworkManager, Bluetooth, NFS (buat NAS), & Polkit (Pop-up Password)
sudo pacman -S --noconfirm \
    networkmanager nmtui bluez bluez-utils \
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
    brave-bin onlyoffice-bin hyprshot swww \

# --- 9. FINISHING ---
# Aktifkan services agar langsung jalan
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now syncthing@$USER.service

# --- 10. SYSTEMD SYSTEM AUTOMATIC LOGIN (BYPASS PASSWORD AT BOOT) ---
echo "Configuring systemd getty for automatic passwordless login..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
cat << EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf [Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin oscarfaldi --noclear %I \$TERM
EOF

# --- 11. BASH PROFILE AUTO-START DESKTOP ---
echo "Configuring ~/.bash_profile to trigger Hyprland automatically..."
cat << 'EOF' > ~/.bash_profile
# Jika sistem mendeteksi user berhasil masuk ke TTY1, langsung eksekusi Hyprland
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec Hyprland
fi
EOF

echo "Rebuild selesai! Sistem lo bener-bener clean & lean sekarang."
