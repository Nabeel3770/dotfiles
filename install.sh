#!/bin/bash

echo ":package: Installing packages..."

sudo pacman -S --needed - < pkglist.txt

if ! command -v yay &> /dev/null
then
echo "Installing yay..."
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd ..
fi

yay -S --needed - < aur.txt

echo ":file_folder: Copying configs..."

cp -r hypr ~/.config/
cp -r waybar ~/.config/
cp -r rofi ~/.config/
cp -r wlogout ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/
cp -r Kvantum ~/.config/
cp -r swaync ~/.config/

echo ":art: Copying themes & icons..."

cp -r icons ~/.icons
cp -r system-themes ~/.themes

echo ":abc: Copying fonts..."

cp -r fonts ~/.local/share/ 2>/dev/null

echo ":white_check_mark: Setup complete!"