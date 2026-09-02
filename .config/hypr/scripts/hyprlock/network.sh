#!/usr/bin/env bash

ssid=$(LC_ALL=C nmcli dev status | awk 'NR == 2 {print $4}')

if [[ -n "$ssid" ]]; then
  echo "󰖩  $ssid"
else
  echo "󰖪  Offline"
fi
