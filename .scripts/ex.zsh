#!/usr/bin/zsh

##
## ex - archive extractor
## usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    local file="$1"
    local base

    case "$file" in
      *.tar.bz2|*.tbz2)  base="${file%.tar.bz2}"; base="${base%.tbz2}" ;;
      *.tar.gz|*.tgz)    base="${file%.tar.gz}";  base="${base%.tgz}" ;;
      *.tar.xz)          base="${file%.tar.xz}" ;;
      *.zip)             base="${file%.zip}" ;;
      *.rar)             base="${file%.rar}" ;;
      *.7z)              base="${file%.7z}" ;;
      *.zst)             base="${file%.zst}" ;;
      *.bz2)             base="${file%.bz2}" ;;
      *.gz)              base="${file%.gz}" ;;
      *.Z)               base="${file%.Z}" ;;
      *)                 base="${file%.*}" ;;
    esac

    mkdir -p "$base"

    case "$file" in
      *.tar.bz2|*.tbz2)  tar xjf "$file" -C "$base" ;;
      *.tar.gz|*.tgz)    tar xzf "$file" -C "$base" ;;
      *.tar.xz)          tar xJf "$file" -C "$base" ;;
      *.tar)             tar xf "$file" -C "$base" ;;
      *.rar)             unrar x "$file" "$base" ;;
      *.7z|*.zip)        7z x "$file" -o "$base" ;;
      *.bz2)             bunzip2 -c "$file" > "$base/$(basename "$base")" ;;
      *.gz)              gunzip -c "$file" > "$base/$(basename "$base")" ;;
      *.Z)               uncompress -c "$file" > "$base/$(basename "$base")" ;;
      *.zst)             zstd -d -c "$file" > "$base/$(basename "$base")" ;;
      *)
        echo "'$file' cannot be extracted via ex()"
        return 1
        ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

