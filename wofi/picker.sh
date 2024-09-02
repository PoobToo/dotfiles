#!/bin/bash

main() {
  # List files in the wallpaper directory and send them to wofi
  SELECTED=$(ls ~/Wallpapers/*.{png,jpg,jpeg,gif,webp} 2>/dev/null | xargs -n 1 basename | wofi --show dmenu -n --prompt "Select a wallpaper:" -W 300 -H 300)

  # Check if a selection was made
  if [ -n "$SELECTED" ]; then
    # Set the selected wallpaper and update theme
    sh ~/.config/wallpaper.sh ~/Wallpapers/"$SELECTED"
  fi
}

#kill wofi if after script to stop it from reappearing
if pidof wofi >/dev/null; then
  killall wofi
  exit 0
else
  main
fi
