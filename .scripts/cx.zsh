#!/usr/bin/env zsh

emulate -L zsh

_cx_usage() {
  echo "cx - archive compressor                                            "
  echo "Usage:                                                             "
  echo "  cx [-ah] -o <output> <files...>                                  "
  echo "                                                                   "
  echo "Options:                                                           "
  echo "  -o, --output           Specify output archive name               "
  echo "  -a, --alg              Specify compressing algorithm             "
  echo "                         (zip|7z|rar|tar.gz|tar.bz2|tar.xz|tar.zst)"
  echo "                                                                   "
  echo "  -h, --help             Show help usage                           "
  echo "                                                                   "
}

_cx_auto_alg_from_ext() {
  case "$1" in
    *.tar.gz)  echo tar.gz ;;
    *.tar.bz2) echo tar.bz2 ;;
    *.tar.xz)  echo tar.xz ;;
    *.tar.zst) echo tar.zst ;;
    *.zip)     echo zip ;;
    *.rar)     echo rar ;;
    *.7z)      echo 7z ;;
    *)         echo "" ;;
  esac
}

cx() {
  setopt localoptions err_return

  local -a oflag aflag vflag hflag
  zparseopts -D -E -- \
    o:=oflag -output:=oflag \
    a:=aflag -alg:=aflag \
    h=hflag  -help=hflag

  if (( ${#hflag} )); then
    _cx_usage
    return 0
  fi

  if (( ! ${#oflag} )); then
    echo "error: missing -o output"
    return 1
  fi

  [[ -z "$@" ]] && { echo "error: missing input files"; return 1 }

  local out="${oflag[2]}"
  local alg=""

  if (( ${#aflag} )); then
    alg="${aflag[2]}"
  else
    alg="$(_cx_auto_alg_from_ext "$out")"
  fi

  [[ -z "$alg" ]] && { echo "error: cannot detect algorithm from '$out'; use -a"; return 1 }

  case "$alg" in
    rar)     rar a "$out" "$@" ;;
    7z|zip)  7z a "$out" "$@" ;;
    tar.gz)  tar czf - "$@" > "$out" ;;
    tar.bz2) tar cjf - "$@" > "$out" ;;
    tar.xz)  tar cJf - "$@" > "$out" ;;
    tar.zst) tar cf - "$@" | zstd -T0 -o "$out" ;;
    *) echo "error: unsupported algorithm: $alg"; return 1 ;;
  esac

  echo "Created Archive -> $out"
}
