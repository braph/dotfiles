#!/usr/bin/env bash

unset CDPATH
set -u +o histexpand

# Usage: $0 [infile] [outfile]
INFILE=${1:-/dev/stdin}
OUTFILE=${2:-/dev/stdout}

# if the setopt list from INFILE is empty, the dash "-" prevents printing
# the options 
{
echo -n 'setopt - '
sed -nr 's/^setopt (.*)/\1/p' "$INFILE" | tr '\n' ' '
echo

echo -n 'unsetopt - '
sed -nr 's/^unsetopt (.*)/\1/p' "$INFILE" | tr '\n' ' '
echo
} > "$OUTFILE"
