#!/bin/sh

set -e

cd "$(dirname "$0")"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"

cmd_build() {
  WITH_EDIT=0
  PACKAGE_COUNT=0
  FILE="$TEMP_DIR/dotfiles-edit-$USER.sh"

  for package; do
    if [ "$package" = "-e" ]; then
      WITH_EDIT=1
    else
      PACKAGE_COUNT=$(( $PACKAGE_COUNT + 1 ))
    fi
  done

  ensure_package_count "$PACKAGE_COUNT"

  if [ "$WITH_EDIT" -eq 0 ]; then
    for package; do
      ensure_package "$package" && "./$package/package.sh" build
    done
  else
    echo "#/bin/sh" > "$FILE"
    echo "" >> "$FILE"
    echo "# exit # uncomment this to cancel build" >> "$FILE"
    echo "" >> "$FILE"

    for package; do
      if [ "$package" != "-e" ]; then
        ensure_package "$package" || continue

        echo "# $package"
        "./$package/package.sh" show
        echo "./$package/package.sh build"
        echo
      fi
    done >> "$FILE"

    chmod +x "$FILE"

    "$EDITOR" "$FILE"

    "$FILE"
  fi
}

cmd_install() {
  ensure_package_count "$#"

  for package; do
    ensure_package "$package" && "./$package/package.sh" install
  done
}

cmd_diff() {
  ensure_package_count "$#"

  for package; do
    ensure_package "$package" && "./$package/package.sh" diff
  done
}

cmd_apply() {
  ensure_package_count "$#"

  for package; do
    ensure_package "$package" && "./$package/package.sh" apply
  done
}

cmd_show() {
  ensure_package_count "$#"

  for package; do
    ensure_package "$package" && "./$package/package.sh" show
  done
}

cmd_clean() {
  ensure_package_count "$#"

  for package; do
    ensure_package "$package" && "./$package/package.sh" clean
  done
}

cmd_help() {
  cat << EOF
Usage: $0 {build|clean|diff|install|show|help} [OPTIONS] <PACKAGE...>

apply:
  Apply configuration for given packages

build:
  Build given packages

  Options:
    -e       Edit variables before building

clean:
  Clean build directory for given packages

diff:
  Diff the given packages

install:
  Install the given packages

show:
  Show configuration variables for given packages
EOF
}

ensure_package() {
  if ! [ -x "$1/package.sh" ]; then
    echo "Warning: $1: Not a package" >&2
    return 1
  fi

  return 0
}

ensure_package_count() {
  if [ "$1" -eq 0 ]; then
    echo "Error: No packages provided" >&2
    exit 1
  fi
}

if [ $# -eq 0 ]; then
  echo "Error: Missing command" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
  exit 1
fi

CMD="$1"; shift

if [ "$CMD" = "apply" ]; then
  cmd_apply "$@"
elif [ "$CMD" = "build" ]; then
  cmd_build "$@"
elif [ "$CMD" = "clean" ]; then
  cmd_clean "$@"
elif [ "$CMD" = "diff" ]; then
  cmd_diff "$@"
elif [ "$CMD" = "install" ]; then
  cmd_install "$@"
elif [ "$CMD" = "show" ]; then
  cmd_show "$@"
elif [ "$CMD" = "help" ]; then
  cmd_help
else
  echo "Error: Unknown command: $CMD" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
fi

