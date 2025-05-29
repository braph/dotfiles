#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="ncmpcpp"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

THEME_COLOR_default=blue
export THEME_COLOR="${THEME_COLOR:-$THEME_COLOR_default}"

MUSIC_DIR_default=/media/main/music
export MUSIC_DIR="${MUSIC_DIR:-$MUSIC_DIR_default}"

NCMPCPP_VERSION_default=$(if type ncmpcpp &>/dev/null; then
    ncmpcpp --version | sed -n 's/ncmpcpp //p;q';
  else
    echo 0.0
  fi)
export NCMPCPP_VERSION="${NCMPCPP_VERSION:-$NCMPCPP_VERSION_default}"

pre_build() {
  get_filepp
  mkdir -p "$BUILD_DIR"
}

post_build() {
  ./makeDummyBindings.sh >> "$BUILD_DIR/.config/ncmpcpp/bindings"

}

cmd_build() {
  echo "Building \"$PACKAGE\" ..." >&2
  pre_build
  mkdir -p "$BUILD_DIR/.config/ncmpcpp"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DMUSIC_DIR="$MUSIC_DIR" -DNCMPCPP_VERSION="$NCMPCPP_VERSION" -M.filepp_modules -m hash-comment.pm -m remove-empty-lines.pm -kc '#>' -ec ENVIRONMENT. bindings.pp -o "$BUILD_DIR/.config/ncmpcpp/bindings"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DMUSIC_DIR="$MUSIC_DIR" -DNCMPCPP_VERSION="$NCMPCPP_VERSION" -M.filepp_modules -m hash-comment.pm -m remove-empty-lines.pm -kc '#>' -ec ENVIRONMENT. config.pp -o "$BUILD_DIR/.config/ncmpcpp/config"
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
  mkdir -p "$DEST_DIR/.config/ncmpcpp"
  cp -p "$BUILD_DIR/.config/ncmpcpp/bindings" "$DEST_DIR/.config/ncmpcpp/bindings"
  cp -p "$BUILD_DIR/.config/ncmpcpp/config" "$DEST_DIR/.config/ncmpcpp/config"
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
  if [ -e "$DEST_DIR/.config/ncmpcpp/bindings" ]; then
    if ! $DIFF "$BUILD_DIR/.config/ncmpcpp/bindings" "$DEST_DIR/.config/ncmpcpp/bindings"; then
      echo " ^--- .config/ncmpcpp/bindings"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/ncmpcpp/bindings'"
  fi
  if [ -e "$DEST_DIR/.config/ncmpcpp/config" ]; then
    if ! $DIFF "$BUILD_DIR/.config/ncmpcpp/config" "$DEST_DIR/.config/ncmpcpp/config"; then
      echo " ^--- .config/ncmpcpp/config"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/ncmpcpp/config'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" THEME_COLOR "$THEME_COLOR"
  printf "export %s=%q\n" MUSIC_DIR "$MUSIC_DIR"
  printf "export %s=%q\n" NCMPCPP_VERSION "$NCMPCPP_VERSION"
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

  mkdir -p "$FILEPP_DIR"

  pushd "$FILEPP_DIR" >/dev/null

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

  pushd "$FILEPP_SOURCE_DIR" >/dev/null

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

  popd >/dev/null
  popd >/dev/null
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