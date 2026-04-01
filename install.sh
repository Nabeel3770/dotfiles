#!/bin/bash

set -e

cd "$(dirname "$0")"

echo "==============================="
echo " Hyprland Dotfiles Installer"
echo "==============================="

# ---------- CHECK ----------

if ! command -v pacman &> /dev/null; then
echo "This script is for Arch-based systems only."
exit 1
fi

# ---------- UPDATE SYSTEM ----------

echo "Updating system..."
sudo pacman -Syu --noconfirm

# ---------- BASE DEPS ----------

echo "Installing base dependencies..."
sudo pacman -S --needed --noconfirm base-devel git

# ---------- INSTALL YAY ----------

if ! command -v yay &> /dev/null; then
echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd -
rm -rf /tmp/yay
fi

# ---------- INSTALL PACKAGES ----------

install_pkg_file () {
FILE=$1
if [ -f "$FILE" ]; then
echo "Installing packages from $FILE..."
sudo pacman -S --needed --noconfirm - < "$FILE" || true
fi
}

install_aur_file () {
FILE=$1
if [ -f "$FILE" ]; then
echo "Installing AUR packages from $FILE..."
yay -S --needed --noconfirm - < "$FILE" || true
fi
}

echo "Installing core packages..."
install_pkg_file packages/core.txt

echo "Installing Hyprland packages..."
install_pkg_file packages/hypr.txt

echo "Installing UI packages..."
install_pkg_file packages/ui.txt

echo "Installing utility packages..."
install_pkg_file packages/utils.txt

echo "Installing AUR packages..."
install_aur_file packages/aur.txt

# ---------- COPY CONFIGS ----------

echo "Copying configs..."

mkdir -p ~/.config

for dir in config/*; do
name=$(basename "$dir")
echo "Installing config: $name"

```
rm -rf "$HOME/.config/$name"
cp -r "$dir" "$HOME/.config/"
```

done

# ---------- THEMES ----------

echo "Installing themes and icons..."

mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/themes

cp -r icons/* ~/.local/share/icons/ 2>/dev/null || true
cp -r system-themes/* ~/.local/share/themes/ 2>/dev/null || true

# ---------- FONTS ----------

echo "Installing fonts..."

mkdir -p ~/.local/share/fonts
cp -r fonts/* ~/.local/share/fonts/ 2>/dev/null || true
fc-cache -fv

# ---------- ENABLE SERVICES ----------

echo "Enabling services..."

sudo systemctl enable NetworkManager || true

# ---------- VM FIX ----------

if grep -qi "vmware" /proc/cpuinfo; then
echo "VM detected: applying Hyprland fixes..."
mkdir -p ~/.config/hypr
echo "env = WLR_NO_HARDWARE_CURSORS,1" >> ~/.config/hypr/hyprland.conf
echo "env = WLR_RENDERER_ALLOW_SOFTWARE,1" >> ~/.config/hypr/hyprland.conf
fi

# ---------- DONE ----------

echo "==============================="
echo " Setup Complete!"
echo " Reboot or relogin."
echo "==============================="
