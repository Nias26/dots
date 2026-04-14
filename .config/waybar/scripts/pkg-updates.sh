#!/usr/bin/env bash

# TODO: Fix sudo password
text="$USER"
tooltip=""
class="normal"

#updates=$(yay -Sy && yay -Qu 2>/dev/null | wc -l)
updates=0
kernel=$(uname -a)
packages="󰏗 ${updates} pending updates..."
user=$(lslogins $USER | sed '/^$/q')

if [ "$updates" -gt 0 ]; then
  tooltip="<span foreground='#33B1FF'>${kernel}</span>"$'\n'"<span foreground='#FF7EB6'>${packages}</span>"$'\n'"<span foreground='#42BE65'>${user}</span>"
else
  tooltip="<span foreground='#33B1FF'>${kernel}</span>"$'\n'"<span foreground='#42BE65'>${user}</span>"
fi
jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
  '{text: $text, tooltip: $tooltip, class: $class}'
