#!/bin/bash

set -e

echo "Starting Hyprland dotfiles installation..."

# =========================
# Install packages
# =========================
echo "Installing packages..."
sudo pacman -S --needed - < pkglist.txt

# =========================
# Install yay if missing
# =========================
if ! command -v yay &> /dev/null
then
    echo "Installing yay..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd ..
fi

# =========================
# Install AUR packages
# =========================
echo "Installing AUR packages..."
yay -S --needed - < aur.txt

# =========================
# Copy configs
# =========================
echo "Copying configs..."
mkdir -p ~/.config
cp -r .config/* ~/.config/

# =========================
# Themes & icons
# =========================
echo "Copying themes and icons..."
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/themes

cp -r icons/* ~/.local/share/icons/ 2>/dev/null || true
cp -r system-themes/* ~/.local/share/themes/ 2>/dev/null || true

# =========================
# Fonts
# =========================
echo "Copying fonts..."
mkdir -p ~/.local/share/fonts

cp -r fonts/* ~/.local/share/fonts/ 2>/dev/null || true
fc-cache -fv

# =========================
# Done
# =========================
echo "Setup complete!"
echo "Reboot or relogin to apply everything."