#!/usr/bin/env bash

# TODO: implement usage with vicinae
# TODO: implement use of notification daemon

WALLPAPER_DIR="$HOME/Immagini/Wallpapers"
WALLPAPER_SLEEP_TIME=$((60*5))
TIMER_FILE="/tmp/wallpaper_timer"
TIMER_STOP="/tmp/wallpaper_stop"

TIMER_FILE_LOCK="/tmp/wallpaper_timer.lock"
WALLPAPER_CURRENT="/tmp/wallpaper_current"

next(){
  CURRENT_WALL=$(swww query | awk '{ print $8 }' | xargs basename)
  WALLPAPER=$(find "$WALLPAPER_DIR" -type d -name ".git" -prune -o -type f ! -name "$CURRENT_WALL" -print | shuf -n 1)
  # if [[ ${WALLPAPER##*.} == "gif" ]]; then
  #   swww img --fill-color=161616 "$WALLPAPER"
  # else
  #   swww img --resize=fit --fill-color=161616 "$WALLPAPER"
  # fi

  swww img --fill-color=161616 "$WALLPAPER"

  cp "$WALLPAPER" "$WALLPAPER_CURRENT"

  # BUG:Timer will continue. No write detected
  # while true; do
  #   {
  #     flock -n 200 && break
  #     echo "writing to timer file"
  #     echo -n "$WALLPAPER_SLEEP_TIME" | tee "$TIMER_FILE"
  #   } 200>"$TIMER_FILE_LOCK"
  # done
}

stop(){
  if [[ ! -e $TIMER_STOP ]]; then
    touch "$TIMER_STOP"
  fi
}

resume(){
  if [[ -e $TIMER_STOP ]]; then
    rm "$TIMER_STOP"
  fi
}

get_time(){
  echo $(cat "$TIMER_FILE")
}

loop(){
  # Infinite loop
  while true; do
    next

    # Inizialize timer
    echo -n "$WALLPAPER_SLEEP_TIME" > "$TIMER_FILE"
    while true; do
      timer=$(cat "$TIMER_FILE")
      if [[ -e $TIMER_STOP ]]; then
        echo "Timer is stopped"
        continue
      fi

      if [[ $timer -gt 0 ]]; then
        timer=$(($timer - 1))
        echo -n "$timer" > "$TIMER_FILE"
        sleep 1
      else
        break
      fi
    done
  done
}

main(){
  case $1 in
    "next") next
      ;;
    "time") get_time
      ;;
    "stop") stop
      ;;
    "resume") resume
      ;;
    "")
      if ! pgrep -f "${0}" | grep -v "${$}" 1>/dev/null; then
        if [[  -e $TIMER_FILE ]]; then
          rm "$TIMER_FILE"
        fi
        if [[  -e $TIMER_STOP ]]; then
          rm "$TIMER_STOP"
        fi
        touch "$TIMER_FILE"
        touch "$TIMER_STOP"
        trap "rm -f $TIMER_FILE" EXIT
        trap "rm -f $TIMER_STOP" EXIT
        loop &
      else
        echo "Already in execution"
        exit 1
      fi
      ;;
    *) exit 1
      ;;
  esac
}

main "$@"
