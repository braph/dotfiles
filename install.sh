#!/usr/bin/env bash

unset CDPATH
set +o histexpand # -u

TMPDIR=${TMPDIR:-${TMP:-${TEMP:-${TEMPDIR:-/tmp}}}}
LOG_DIR="$TMPDIR/dotfiles-$USER.logs"
CURRENT_DIR=$(pwd)
declare -a VARIABLES=()
declare -a FILES=()
declare -a FAILED=()

if which gmake &>/dev/null; then
	MAKE=gmake
elif which make &>/dev/null && make --version | grep -q 'GNU'; then
	MAKE=make
else
	echo "Could not find GNU make" >&2
  exit 1
fi

rm -rf "$LOG_DIR"
mkdir -p "$LOG_DIR" || {
   echo "Could not create log dir" >&2
   exit 1
}

ACTION=$1; shift
if [[ "$ACTION" != "diff" ]] && \
   [[ "$ACTION" != "info" ]] && \
   [[ "$ACTION" != "build" ]] && \
   [[ "$ACTION" != "install" ]]; then
   echo "Unknown command: $ACTION" >&2
   exit 1
fi

for arg; do
   if [[ "$arg" != "${arg/=/}" ]]; then
      VARIABLES+=($arg)
   elif [[ -d "$arg" ]]; then
      FILES+=($arg)
   else
      echo "> skipping $arg (not a directory)"
   fi
done

for file in "${FILES[@]}"; do
   cd "$CURRENT_DIR"

   if ! cd "$file"; then
      echo "Directory not found" > "$LOG_DIR/$file"
      FAILED+=($file)
      continue
   fi

   echo "> ${ACTION}ing $file"
   if ! $MAKE $ACTION "${VARIABLES[@]}" &> "$LOG_DIR/$file"; then
      FAILED+=($file)
      continue
   fi
done

printf "> Done\n\n"

if [[ "$ACTION" == info ]] || [[ "$ACTION" == diff ]]; then
   cat "$LOG_DIR"/*
fi

if [[ -n "${FAILED[@]}" ]]; then
   if [[ "$ACTION" == 'diff' ]]; then
      echo "> These dotfiles are different: ${FAILED[@]}"
      echo "> See logs in $LOG_DIR"
   else
      echo "> These dotfiles failed to $ACTION: ${FAILED[@]}"
      echo "> See logs in $LOG_DIR"
   fi
fi
