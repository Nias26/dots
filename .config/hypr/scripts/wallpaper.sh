#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Immagini/Wallpapers"
CURRENT_WALL=$(swww query | awk '{ print $8 }' | xargs basename)
WALLPAPER_SLEEP_TIME=$((60*5))

# Infinite loop
for ((;;)); do
  # Check for current wallpaper
  CURRENT_WALL=$(swww query | awk '{ print $8 }' | xargs basename)
  # Get random wallpaper
  WALLPAPER=$(find "$WALLPAPER_DIR" -type d -name ".git" -prune -o -type f ! -name "$CURRENT_WALL" -print | shuf -n 1)
  # echo $WALLPAPER
  if [[ $(echo ${WALLPAPER} | sed -e 's/.*\.//') == "gif" ]] then
    swww img --fill-color=161616 "${WALLPAPER}"
  else
    swww img --resize=fit --fill-color=161616 "${WALLPAPER}"
  fi
  sleep $WALLPAPER_SLEEP_TIME
done
