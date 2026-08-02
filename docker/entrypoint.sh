#!/bin/bash

set -e

if [[ $# -lt 1 ]] ; then
  echo "error: at least one argument required (directory)" 1>&2
  exit 1
fi

dir="$1"

if [[ "$dir" != "/"* ]] ; then
  echo "error: first arg must be an absolute directory path" 1>&2
  exit 1
fi

if [[ ! -d "$dir" ]] ; then
  echo "error: no such directory: $dir" 1>&2
  exit 1
fi

cd "$dir"
export XDG_CONFIG_HOME=/config

# If only 1 argument, run emacs without a file
# If 2+ arguments, second is the file, remaining pass to emacs
if [[ $# -eq 1 ]] ; then
  exec emacs -nw
else
  shift
  file="$1"
  shift

  if [[ -f "$file" ]] ; then
    exec emacs -nw "$file" "$@"
  else
    echo "error: no such file: $file" 1>&2
    exit 1
  fi
fi
