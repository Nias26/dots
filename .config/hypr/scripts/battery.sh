#!/usr/bin/env bash

BAT="/sys/class/power_supply/BAT0"

capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")

if [[ "$status" == "Charging" ]]; then
  icon="󰂄"
else
  icon="󰁹"
fi

echo "$icon  ${capacity}%"
