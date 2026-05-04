#!/usr/bin/env bash

text=$(tlpctl get)
tooltip=""
class="normal"

case "$text" in
  "performance") text=" " ;;
  "balanced")    text=" " ;;
  "power-saver") text=" " ;;
esac


jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
  '{text: $text, tooltip: $tooltip, class: $class}'
