#!/usr/bin/env bash

unset CDPATH
set -u +o histexpand

# Usage: $0 [infile] [outfile]
INFILE=${1:-/dev/stdin}
OUTFILE=${2:-/dev/stdout}

# not used!
# TODO rewrite!
exit;

ALIASES=$(grep '^alias ' "$INFILE")
sed -i '/^alias /d' "$1"

{
   printf "alias --"

   while read -r _ ALIAS; do
      printf " %s" "$ALIAS"
   done <<< "$ALIASES"

} > "$OUTFILE"
