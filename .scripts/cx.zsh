#!/usr/bin/env zsh

_cx_output() {
  local ext candidate separator
  local -a candidates

  if [[ "$PREFIX" == *. ]]; then
    separator=''
  else
    separator='.'
  fi

  for ext in zip 7z rar tar.gz tar.bz2 tar.xz tar.zst; do
    candidate="${PREFIX}${separator}${ext}"

    if [[ ! -e "$candidate" ]]; then
      candidates+=("$candidate")
    fi
  done

  compstate[insert]=menu
  compadd -- "${candidates[@]}"
}

_cx() {
  _arguments -s \
    '(-o --output)'{-o,--output}'[output file]:output file:_cx_output' \
    '(-a --alg)'{-a,--alg}'[algorithm]:algorithm:(zip 7z rar tar.gz tar.bz2 tar.xz tar.zst)' \
    '(-h --help)'{-h,--help}'[show help]' \
    '*:input file(s):_files'
}

_cx_usage() {
  echo "cx - archive compressor                                                    "
  echo "Usage:                                                                     "
  echo "  cx [-ah] -o <output> <files...>                                          "
  echo "                                                                           "
  echo "Options:                                                                   "
  echo "  -o, --output           Specify output archive name                       "
  echo "  -a, --alg              Specify compressing algorithm                     "
  echo "                         (zip|7z|rar|tar.gz|tar.bz2|tar.xz|tar.zst)        "
  echo "                         The algorithm can be detected from the output file"
  echo "                                                                           "
  echo "  -h, --help             Show help usage                                   "
  echo "                                                                           "
}

_cx_die() {
  echo "$1" >&2
  return 1;
}

_cx_detect_ext() {
  case "$1" in
    (*.tar.gz)  echo tar.gz ;;
    (*.tar.bz2) echo tar.bz2 ;;
    (*.tar.xz)  echo tar.xz ;;
    (*.tar.zst) echo tar.zst ;;
    (*.zip)     echo zip ;;
    (*.rar)     echo rar ;;
    (*.7z)      echo 7z ;;
    (*)         echo "" ;;
  esac
}

cx() {
  emulate -L zsh
  setopt localoptions err_return

  local -a f_out f_alg f_help
  zparseopts -D -E -- \
    o:=f_out -output:=f_out \
    a:=f_alg -alg:=f_alg \
    h=f_help  -help=f_help

  if (( ${#f_help} )); then
    _cx_usage
    return 0
  fi

  if (( ! ${#f_out} )); then
    _cx_die "error: missing output -o flag"
  fi

  if (( $# == 0 )); then
    _cx_die "error: missing input files"
  fi

  local out="${f_out[2]}"
  local alg=""

  if (( ${#f_alg} )); then
    alg="${f_alg[2]}"
  else
    alg="$(_cx_detect_ext "$out")"
  fi

  if [[ -z "$alg" ]]; then
    _cx_die "error: cannot detect algorithm from '$out'; use -a"
  fi

  case "$alg" in
    (rar)     rar a "$out" "$@" ;;
    (7z|zip)  7z a "$out" "$@" ;;
    (tar.gz)  tar czf - "$@" > "$out" ;;
    (tar.bz2) tar cjf - "$@" > "$out" ;;
    (tar.xz)  tar cJf - "$@" > "$out" ;;
    (tar.zst) tar cf - "$@" | zstd -T0 -o "$out" ;;
    (*)       _cx_die "error: unsupported algorithm: $alg" ;;
  esac

  echo "Created Archive -> $out"
}

compdef _cx cx
