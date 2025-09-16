#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Immagini/Wallpapers"
CURRENT_WALL=$(swww query | awk '{ print $8 }' | xargs basename)
WALLPAPER_SLEEP_TIME=$((60*5))

# Infinite loop
for ((;;)); do
  # Check for current wallpaper
  CURRENT_WALL=$(swww query | awk '{ print $8 }' | xargs basename)
  # Get random wallpaper
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$CURRENT_WALL" | shuf -n 1)
  swww img --resize=fit --fill-color=161616 "${WALLPAPER}"
  sleep $WALLPAPER_SLEEP_TIME
done
