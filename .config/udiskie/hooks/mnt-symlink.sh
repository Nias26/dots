#!/bin/sh

ACTION="$1"
MOUNTPOINT="$3"
USERNAME="$(whoami)"
TARGET_DIR="$HOME/mnt"

[[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"

NAME="$(basename "$MOUNTPOINT")"
LINK="$TARGET_DIR/$NAME"

case "$ACTION" in
  mount)
    if [[ ! -e "$LINK" ]]; then
      ln -s "$MOUNTPOINT" "$LINK"
    fi
    ;;
  unmount)
    if [[ -L "$LINK" ]] && [[ "$(readlink -f "$LINK")" == "$(readlink -f "$MOUNTPOINT")" ]]; then
      rm "$LINK"
    fi
    ;;
esac
