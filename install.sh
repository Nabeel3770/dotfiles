#!/bin/bash

set -e

echo "Starting dotfiles installation..."

# -----------------------------
# Check for Arch-based system
# -----------------------------
if ! command -v pacman &> /dev/null; then
    echo "This script supports Arch-based systems only."
    exit 1
fi

# -----------------------------
# Update system
# -----------------------------
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# -----------------------------
# Install base dependencies
# -----------------------------
echo "Installing base dependencies..."
sudo pacman -S --needed --noconfirm git base-devel stow

# -----------------------------
# Install core packages
# -----------------------------
if [ -f packages/core.txt ]; then
    echo "Installing core packages..."
    sudo pacman -S --needed --noconfirm - < packages/core.txt
fi

# -----------------------------
# Install UI packages
# -----------------------------
if [ -f packages/ui.txt ]; then
    echo "Installing UI packages..."
    sudo pacman -S --needed --noconfirm - < packages/ui.txt
fi

# -----------------------------
# Install Hyprland packages
# -----------------------------
if [ -f packages/hypr.txt ]; then
    echo "Installing Hyprland packages..."
    sudo pacman -S --needed --noconfirm - < packages/hypr.txt
fi

# -----------------------------
# Install yay (AUR helper)
# -----------------------------
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# -----------------------------
# Install AUR packages
# -----------------------------
if [ -f packages/aur.txt ]; then
    echo "Installing AUR packages..."
    yay -S --needed --noconfirm - < packages/aur.txt
fi

# -----------------------------
# Backup existing configs
# -----------------------------
echo "Backing up existing configuration..."
mkdir -p ~/.config_backup
cp -r ~/.config/* ~/.config_backup/ 2>/dev/null || true

# -----------------------------
# Remove conflicting configs
# -----------------------------
echo "Removing existing configuration directories..."
rm -rf ~/.config/hypr \
       ~/.config/waybar \
       ~/.config/kitty \
       ~/.config/rofi \
       ~/.config/swaync \
       ~/.config/wlogout \
       ~/.config/fish \
       ~/.config/cava \
       ~/.config/fastfetch \
       ~/.config/Kvantum \
       ~/.config/gtk-3.0 \
       ~/.config/gtk-4.0

# -----------------------------
# Apply dotfiles using stow
# -----------------------------
echo "Applying dotfiles using GNU Stow..."

stow hypr
stow waybar
stow kitty
stow rofi
stow swaync
stow wlogout
stow fish
stow cava
stow fastfetch
stow Kvantum
stow gtk-3.0
stow gtk-4.0

# -----------------------------
# Install fonts
# -----------------------------
if [ -d fonts ]; then
    echo "Installing fonts..."
    mkdir -p ~/.local/share/fonts
    cp -r fonts/* ~/.local/share/fonts/
    fc-cache -fv
fi

# -----------------------------
# Install icons and themes
# -----------------------------
if [ -d assets/icons ]; then
    echo "Installing icons..."
    mkdir -p ~/.local/share/icons
    cp -r assets/icons/* ~/.local/share/icons/
fi

if [ -d assets/themes ]; then
    echo "Installing themes..."
    mkdir -p ~/.local/share/themes
    cp -r assets/themes/* ~/.local/share/themes/
fi

# -----------------------------
# Completion
# -----------------------------
echo "Installation complete."
echo "Log out or reboot to apply changes."