#!/bin/bash

set -e

dir="$1"
file="$2"
shift 2

if [[ "$dir" == "/"* ]] ; then
  if [[ ! -d "$dir" ]] ; then
    echo error: no such directory: "$dir" 1>&2
    exit 1
  fi
else
  echo error: first arg must be an absolute directory path 1>&2
  exit 1
fi

cd "$dir"
export XDG_CONFIG_HOME=/config
exec emacs -nw "$file" "$@"
