#!/usr/bin/env bash

user="$USER"
text="$user"
host=$(hostname)
kernel=$(uname -r)
fetch=$(fastfetch --logo none)
tooltip="<span foreground='#33B1FF'>${user}@${host} on ${kernel}</span>"$'\n'"<span foreground='#42BE65'>${fetch}</span>"

jq -nc --arg text "$text" --arg tooltip "$tooltip" \
  '{text: $text, tooltip: $tooltip}'
