#!/usr/bin/env zsh

cx() {
  usage() {
    echo "Usage: cx [-v] [-a alg] -o output <files...>"
    echo "Algorithms: zip 7z rar tar.gz tar.bz2 tar.xz tar.zst"
    return 1
  }

  if (( $# == 0 )); then
    usage
    return 1
  fi

  local alg="" out="" verbose=0 opt

  while getopts "a:o:vh" opt; do
    case $opt in
      a) alg="$OPTARG" ;;
      o) out="$OPTARG" ;;
      v) verbose=1 ;;
      h) usage; return 0 ;;
      *) usage; return 1 ;;
    esac
  done
  shift $((OPTIND-1))

  if (( $# == 0 )); then
    echo "Error: no input files."
    usage
    return 1
  fi

  if [[ -z "$out" ]]; then
    echo "Error: missing -o output."
    usage
    return 1
  fi

  auto_alg_from_ext() {
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

  [[ -z "$alg" ]] && alg=$(auto_alg_from_ext "$out")
  [[ -z "$alg" ]] && { echo "Cannot detect algorithm; use -a."; return 1; }

  v() { ((verbose)) && echo "$@"; }

  case "$alg" in
    zip)     zip "$out" "$@" ;;
    rar)     rar a "$out" "$@" ;;
    7z)      7z a "$out" "$@" ;;

    tar.gz)  tar czf - "$@" > "$out" ;;
    tar.bz2) tar cjf - "$@" > "$out" ;;
    tar.xz)  tar cJf - "$@" > "$out" ;;
    tar.zst) tar cf - "$@" | zstd -T0 -o "$out" ;;

    *) echo "Unsupported algorithm: $alg"; return 1 ;;
  esac

  v "Created Archive -> $out"
}

