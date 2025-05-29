#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="obthemes"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"



pre_build() {
  get_filepp
  mkdir -p "$BUILD_DIR"
}

post_build() {
  true
}

cmd_build() {
  echo "Building \"$PACKAGE\" ..." >&2
  pre_build
  mkdir -p "$BUILD_DIR/.themes/braph/openbox-3"
  cp -p "braph/openbox-3/themerc" "$BUILD_DIR/.themes/braph/openbox-3/themerc"
  cp -p "braph/openbox-3/shade.xbm" "$BUILD_DIR/.themes/braph/openbox-3/shade.xbm"
  cp -p "braph/openbox-3/max.xbm" "$BUILD_DIR/.themes/braph/openbox-3/max.xbm"
  cp -p "braph/openbox-3/iconify.xbm" "$BUILD_DIR/.themes/braph/openbox-3/iconify.xbm"
  cp -p "braph/openbox-3/desk_toggled.xbm" "$BUILD_DIR/.themes/braph/openbox-3/desk_toggled.xbm"
  cp -p "braph/openbox-3/desk.xbm" "$BUILD_DIR/.themes/braph/openbox-3/desk.xbm"
  cp -p "braph/openbox-3/close.xbm" "$BUILD_DIR/.themes/braph/openbox-3/close.xbm"
  cp -p "braph/openbox-3/bullet.xbm" "$BUILD_DIR/.themes/braph/openbox-3/bullet.xbm"
  cp -p "braph/openbox-3/bullet-small.xbm" "$BUILD_DIR/.themes/braph/openbox-3/bullet-small.xbm"
  post_build
}

post_install() {
  true
}

cmd_install() {
  echo "Installing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  mkdir -p "$DEST_DIR/.themes/braph/openbox-3"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/themerc" "$DEST_DIR/.themes/braph/openbox-3/themerc"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/shade.xbm" "$DEST_DIR/.themes/braph/openbox-3/shade.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/max.xbm" "$DEST_DIR/.themes/braph/openbox-3/max.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/iconify.xbm" "$DEST_DIR/.themes/braph/openbox-3/iconify.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/desk_toggled.xbm" "$DEST_DIR/.themes/braph/openbox-3/desk_toggled.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/desk.xbm" "$DEST_DIR/.themes/braph/openbox-3/desk.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/close.xbm" "$DEST_DIR/.themes/braph/openbox-3/close.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/bullet.xbm" "$DEST_DIR/.themes/braph/openbox-3/bullet.xbm"
  cp -p "$BUILD_DIR/.themes/braph/openbox-3/bullet-small.xbm" "$DEST_DIR/.themes/braph/openbox-3/bullet-small.xbm"
  post_install
}

cmd_apply() {
  echo "Applying \"$PACKAGE\" ..." >&2
}

cmd_diff() {
  echo "Diffing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/themerc" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/themerc" "$DEST_DIR/.themes/braph/openbox-3/themerc"; then
      echo " ^--- .themes/braph/openbox-3/themerc"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/themerc'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/shade.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/shade.xbm" "$DEST_DIR/.themes/braph/openbox-3/shade.xbm"; then
      echo " ^--- .themes/braph/openbox-3/shade.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/shade.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/max.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/max.xbm" "$DEST_DIR/.themes/braph/openbox-3/max.xbm"; then
      echo " ^--- .themes/braph/openbox-3/max.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/max.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/iconify.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/iconify.xbm" "$DEST_DIR/.themes/braph/openbox-3/iconify.xbm"; then
      echo " ^--- .themes/braph/openbox-3/iconify.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/iconify.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/desk_toggled.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/desk_toggled.xbm" "$DEST_DIR/.themes/braph/openbox-3/desk_toggled.xbm"; then
      echo " ^--- .themes/braph/openbox-3/desk_toggled.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/desk_toggled.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/desk.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/desk.xbm" "$DEST_DIR/.themes/braph/openbox-3/desk.xbm"; then
      echo " ^--- .themes/braph/openbox-3/desk.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/desk.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/close.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/close.xbm" "$DEST_DIR/.themes/braph/openbox-3/close.xbm"; then
      echo " ^--- .themes/braph/openbox-3/close.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/close.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/bullet.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/bullet.xbm" "$DEST_DIR/.themes/braph/openbox-3/bullet.xbm"; then
      echo " ^--- .themes/braph/openbox-3/bullet.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/bullet.xbm'"
  fi
  if [ -e "$DEST_DIR/.themes/braph/openbox-3/bullet-small.xbm" ]; then
    if ! $DIFF "$BUILD_DIR/.themes/braph/openbox-3/bullet-small.xbm" "$DEST_DIR/.themes/braph/openbox-3/bullet-small.xbm"; then
      echo " ^--- .themes/braph/openbox-3/bullet-small.xbm"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.themes/braph/openbox-3/bullet-small.xbm'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
}

cmd_clean() {
  echo "Cleaning up \"$PACKAGE\" ..." >&2
  rm -rf "$BUILD_DIR"
}

cmd_help() {
  cat << EOF
Usage: $0 {build|clean|diff|install|show|help}

apply:
  Apply configurations

build:
  Build the current package

clean:
  Remove the build directory

diff:
  Diff the builded package

install:
  Install the builded package

show:
  Show configuration variables
EOF
}

get_filepp() {
  [ -x "$FILEPP" ] && return

  OLDPWD="$PWD"

  mkdir -p "$FILEPP_DIR"

  cd "$FILEPP_DIR"

  FILEPP_VERSION="1.8.0"
  FILEPP_TAR_GZ="filepp-$FILEPP_VERSION.tar.gz"
  FILEPP_SOURCE_DIR="filepp-$FILEPP_VERSION"
  FILEPP_URL="http://www-users.york.ac.uk/~dm26/filepp/$FILEPP_TAR_GZ"

  if type wget &>/dev/null; then
    echo "Downloading \"$FILEPP_URL\" ..." >&2

    if ! wget "$FILEPP_URL" -O "$FILEPP_TAR_GZ" &>log; then
      cat log >&2
      echo "Error: Command failed: wget \"$FILEPP_URL\" -O \"$FILEPP_TAR_GZ\"" >&2
      exit 1
    fi
  elif type curl &>/dev/null; then
    echo "Downloading \"$FILEPP_URL\" ..." >&2

    if ! curl -L --fail "$FILEPP_URL" -o "$FILEPP_TAR_GZ" &>log; then
      cat log >&2
      echo "Error: Command failed: curl -L --fail \"$FILEPP_URL\" -o \"$FILEPP_TAR_GZ\"" >&2
      exit 1
    fi
  else
    echo "Error: No curl or wget found" >&2
    exit 1
  fi

  if ! type tar &>/dev/null; then
    echo "Error: No tar program found" >&2
    exit 1
  fi

  if ! type make &>/dev/null; then
    echo "Error: No make program found" >&2
    exit 1
  fi

  echo "Extracting archive ..." >&2

  if ! tar xf "$FILEPP_TAR_GZ" &>log; then
    cat log >&2
    echo "Error: Command failed: tar xf \"$FILEPP_TAR_GZ\"" >&2
    exit 1
  fi

  cd "$FILEPP_SOURCE_DIR"

  echo "Calling ./configure ..." >&2

  if ! ./configure --prefix="$FILEPP_DIR" &>log; then
    cat log >&2
    echo "Error: Command falied: ./configure --prefix=\"$FILEPP_DIR\"" >&2
    exit 1
  fi

  echo "Calling make ..." >&2

  if ! make &>log; then
    cat log >&2
    echo "Command failed: make" >&2
    exit 1
  fi

  echo "Calling make install ..." >&2

  if ! make install &>log; then
    cat log >&2
    echo "Command failed: make install" >&2
    exit 1
  fi

  cd "$OLDPWD"
} 

if [ $# -eq 0 ]; then
  echo "Error: Missing command" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
  exit 1
elif [ $# -gt 1 ]; then
  echo "Error: Too many arguments" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
  exit 1
elif [ "$1" = "apply" ]; then
  cmd_apply
elif [ "$1" = "build" ]; then
  cmd_build
elif [ "$1" = "clean" ]; then
  cmd_clean
elif [ "$1" = "diff" ]; then
  cmd_diff
elif [ "$1" = "install" ]; then
  cmd_install
elif [ "$1" = "show" ]; then
  cmd_show
elif [ "$1" = "help" ]; then
  cmd_help
else
  echo "Error: Unknown command: $1" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
fi