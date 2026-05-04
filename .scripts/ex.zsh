#!/usr/bin/env zsh

emulate -L zsh

_ex_usage() {
  echo "ex - archive extractor                "
  echo "Usage:                                "
  echo "  ex [-dh] <file>                     "
  echo "                                      "
  echo "Options:                              "
  echo "  -d, --dir       Extract to directory"
  echo "  -h, --help      Show help usage     "
  echo "                                      "
}

ex() {
  setopt localoptions err_return

  local -a dflag hflag
  zparseopts -D -E -- \
    d=dflag -dir=dflag \
    h=hflag -help=hflag

  if (( ${#hflag} )); then
    _ex_usage
    return 0
  fi

  local file="$1"
  if [[ -z "$file" ]]; then
    echo "error: missing archive"
    return 1
  fi
  if [[ ! -f "$file" ]]; then
    echo "error: '$file' is not a valid file"
    return 1
  fi

  local base="${file:t}"
  base="${base%.tar.*}"
  base="${base%.*}"

  local dest="."
  if (( ${#dflag} )); then
    dest="$base"
    mkdir -p "$dest"
  fi

  case "$file" in
    (*.tar.bz2|*.tbz2) tar xjvf "$file" -C "$dest" ;;
    (*.tar.gz|*.tgz)   tar xzvf "$file" -C "$dest" ;;
    (*.tar.xz)         tar xJvf "$file" -C "$dest" ;;
    (*.tar)            tar xvf "$file" -C "$dest" ;;
    (*.rar)            unrar x "$file" "$dest/" ;;
    (*.7z|*.zip)       7z x "$file" -o"$dest" ;;
    (*.bz2)            bunzip2 -c "$file" > "$dest/$base" ;;
    (*.gz)             gunzip -c "$file" > "$dest/$base" ;;
    (*.Z)              uncompress -c "$file" > "$dest/$base" ;;
    (*.zst)            zstd -d -c "$file" > "$dest/$base" ;;
    (*)                echo "error: '$file' cannot be extracted via ex()" ; return 1 ;;
  esac
}
