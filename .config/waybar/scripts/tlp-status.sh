#!/usr/bin/env bash

text=$(tlpctl get)
color=""
tooltip=""

case "$text" in
  "performance") text="<span color='#be95ff'> </span>" ;;
  "balanced")    text="<span color='#33b1ff'> </span>" ;;
  "power-saver") text="<span color='#42be65'> </span>" ;;
esac


jq -nc --arg text "$text" --arg tooltip "$tooltip" \
  '{text: $text, tooltip: $tooltip}'
