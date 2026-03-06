#!/usr/bin/env zsh

# ex - archive extractor
# usage: ex [-d] <file>

ex() {
  emulate -L zsh
  setopt localoptions err_return

  local -a dflag
  zparseopts -D -E d=dflag

  local file="$1"
  [[ -z "$file" ]] && { echo "usage: ex [-d] <archive>"; return 1 }
  [[ ! -f "$file" ]] && { echo "'$file' is not a valid file"; return 1 }

  local base="${file:t}"
  base="${base%.tar.*}"
  base="${base%.*}"

  local dest="."
  if (( ${#dflag} )); then
    dest="$base"
    mkdir -p "$dest"
  fi

  case "$file" in
    (*.tar.bz2|*.tbz2) tar xjf "$file" -C "$dest" ;;
    (*.tar.gz|*.tgz)   tar xzf "$file" -C "$dest" ;;
    (*.tar.xz)         tar xJf "$file" -C "$dest" ;;
    (*.tar)            tar xf "$file" -C "$dest" ;;
    (*.rar)            unrar x "$file" "$dest/" ;;
    (*.7z|*.zip)       7z x "$file" -o"$dest" ;;
    (*.bz2)            bunzip2 -c "$file" > "$dest/$base" ;;
    (*.gz)             gunzip -c "$file" > "$dest/$base" ;;
    (*.Z)              uncompress -c "$file" > "$dest/$base" ;;
    (*.zst)            zstd -d -c "$file" > "$dest/$base" ;;
    (*)                echo "'$file' cannot be extracted via ex()" ; return 1 ;;
  esac
}
