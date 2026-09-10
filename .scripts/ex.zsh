#!/usr/bin/env zsh

_ex() {
  _arguments -s \
    '(-d --dir)'{-d,--dir}'[output directory]:output directory:_files' \
    '(-l --list)'{-l,--list}'[list content]' \
    '(-h --help)'{-h,--help}'[show help]' \
    '*:input file:_files'
}

_ex_usage() {
  echo "ex - archive extractor                 "
  echo "Usage:                                 "
  echo "  ex [-dlh] <file>                     "
  echo "                                       "
  echo "Options:                               "
  echo "  -d, --dir       Extract to directory "
  echo "  -l, --list      List archive contents"
  echo "  -h, --help      Show help usage      "
  echo "                                       "
}

_ex_die() {
  echo "$1" >&2
  return 1;
}

ex() {
  setopt localoptions err_return

  local -a f_dir f_list f_help
  zparseopts -D -E -- \
    d::=f_dir -dir::=f_dir \
    l=f_list -list=f_list \
    h=f_help -help=f_help

  if (( ${#f_help} )); then
    _ex_usage
    return 0
  fi

  local file="$1"
  if [[ -z "$file" ]]; then
    _ex_die "error: missing archive"
  fi

  if [[ ! -f "$file" ]]; then
    _ex_die "error: '$file' is not a valid archive"
  fi

  local base="${file:t}"
  base="${base%.tar.*}"
  base="${base%.*}"

  local dest="."
  if (( ${#f_dir} )); then
    dest="${f_dir[2]:-$base}"
    mkdir -p "$dest"
  fi

  if (( ${f_list} )); then
    case "$file" in
      (*.tar.bz2|*.tbz2) tar tjvf "$file" -C "$dest" ;;
      (*.tar.gz|*.tgz)   tar tzvf "$file" -C "$dest" ;;
      (*.tar.xz)         tar tJvf "$file" -C "$dest" ;;
      (*.tar)            tar tvf "$file" -C "$dest" ;;
      (*.rar)            unrar l "$file" ;;
      (*.7z|*.zip)       7z l "$file" -o"$dest" ;;
      (*.gz)             gunzip -l "$file" ;;
      (*.Z)              uncompress -l "$file" ;;
      (*.zst)            zstd -d -c "$file" > "$dest/$base" ;;
      (*)                _ex_die "error: '$file' contents cannot be listed via ex()" ;;
    esac
    return 0;
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
    (*)                _ex_die "error: '$file' cannot be extracted via ex()" ;;
  esac
}

compdef _ex ex
