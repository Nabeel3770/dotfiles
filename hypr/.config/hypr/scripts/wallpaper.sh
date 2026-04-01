#!/bin/bash
WALLDIR="$HOME/dotfiles/assets/wallpaper"

# Pick random wallpaper
IMG=$(find "$WALLDIR" -type f | shuf -n 1)

# Apply with smooth transition
POSX=$(awk -v min=0 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
POSY=$(awk -v min=0 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')

swww img "$IMG" \
  --transition-type grow \
  --transition-pos $POSX,$POSY \
  --transition-fps 144 \
  --transition-duration 1.4 \
  --transition-bezier 0.25,0.1,0.25,1
