#!/usr/bin/env bash

ssid=$(LC_ALL=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 == "yes" { print $2 }')

if [[ -n "$ssid" ]]; then
  echo "󰖩  $ssid"
else
  echo "󰖪  Offline"
fi
