#!/usr/bin/env bash

packages=$(yay -Qu)
updates=$(wc -l <<< $packages)

text=""
tooltip=""
class="normal"

if [ $updates -gt 0 ]; then
  text="󰏗 $updates"
  # tooltip="$packages"
  if [ $updates -gt 60 ]; then
    class="lots-of-packages"
  fi
else
  text="$USER"
fi
tooltip="$(uname -a && echo '---------' && lslogins $USER | sed '/^$/q')"

jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
  '{text: $text, tooltip: $tooltip, class: $class}'
