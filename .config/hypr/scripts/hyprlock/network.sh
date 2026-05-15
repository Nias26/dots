#!/usr/bin/env bash

ssid=$(iwgetid -r)

if [[ -n "$ssid" ]]; then
  echo "󰖩  $ssid"
else
  echo "󰖪  Offline"
fi
