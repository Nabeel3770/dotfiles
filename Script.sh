#!/bin/bash

set -e

echo "Converting dotfiles to GNU Stow structure..."

if [ ! -d "config" ]; then
echo "No config folder found. Run this from your dotfiles root."
exit 1
fi

echo "Creating backup..."
cp -r config config_backup

for dir in config/*; do
name=$(basename "$dir")

echo "Processing $name..."

mkdir -p "$name/.config"
mv "$dir" "$name/.config/"

done

rm -rf config

echo "Done! Converted to stow structure."
