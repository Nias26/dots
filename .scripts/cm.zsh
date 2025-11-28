#!/usr/bin/env zsh

###############################################################################
## cm - archive compressor                                                   ##
## usage: cm <compression method> [-v|--verbose] -O <output file> [file...] ##
###############################################################################

zmodload zsh/zutil || exit 1

VALID_TYPES=(tbz2 tgz txz zip rar 7z zst bz2 gz Z)

cm () {
  local output_file=""
  local verbose_flag=false
  local compression_method=""

  local verbose_arg=()
  local output_arg=()

  zparseopts -D -F {v,-verbose}=verbose_arg {O,-output}:=output_arg || { print "Error parsing options." >&2; return 1 }

  # verboose
  if (( $#verbose_arg )); then
    verbose_flag=true
  fi

  if (( $#output_arg )); then
    output_file="${output_arg[-1]}"
  else
    print "Error: -O <output file> is required." >&2
    print "Usage: cm <compression method> [-v|--verbose] -O <output file> [file...]" >&2
    return 1
  fi

  # if no compression method, exit
  if (( $# == 0 )); then
    print "Error: Compression method is missing." >&2
    print "Available types: ${VALID_TYPES[*]}" >&2
    return 1
  fi

  compression_method="$1"

  if ! (( ${VALID_TYPES[(I)$compression_method]} )); then
    print "Error: Invalid compression method '$compression_method'." >&2
    print "Available types: ${VALID_TYPES[*]}" >&2
    return 1
  fi

  # remove the compression method from the arguments to leave only the files
  shift

  # remaining arguments are the input files
  local files=("$@")

  if (( $#files == 0 )); then
    print "Error: No input files specified." >&2
    return 1
  fi

  $verbose_flag && print "Input files: ${files[*]}"
  $verbose_flag && print "Compression: $compression_method"

  case "$compression_method" in
    tbz2)
      tar -cjf "$output_file" ${verbose_flag:?v:? } "${files[@]}"
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    tgz)
      tar -czf "$output_file" ${verbose_flag:?v:? } "${files[@]}"
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    txz)
      tar -cJf "$output_file" ${verbose_flag:?v:? } "${files[@]}"
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    zip)
      zip ${verbose_flag:?-v:? } "$output_file" "${files[@]}"
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    rar)
      rar a ${verbose_flag:?-v:? } "$output_file" "${files[@]}"
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    7z)
      7z a "$output_file" "${files[@]}" ${verbose_flag:? }
      if (($? == 0)) print "Created Archive -> $output_file"
      ;;
    *)
      print "Internal Error: Unhandled compression method $compression_method" >&2
      return 1
      ;;
  esac
}

cm "$@"
