#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="moc"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

THEME_COLOR_default=blue
export THEME_COLOR="${THEME_COLOR:-$THEME_COLOR_default}"

USE_THEME_default=frame
export USE_THEME="${USE_THEME:-$USE_THEME_default}"

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
  mkdir -p "$BUILD_DIR/.moc"
  mkdir -p "$BUILD_DIR/.moc/themes"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DUSE_THEME="$USE_THEME" -M.filepp_modules -kc '#>' -ec ENVIRONMENT. config.pp -o "$BUILD_DIR/.moc/config"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DUSE_THEME="$USE_THEME" -M.filepp_modules -kc '#>' -ec ENVIRONMENT. themes/normal.pp -o "$BUILD_DIR/.moc/themes/normal"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DUSE_THEME="$USE_THEME" -M.filepp_modules -kc '#>' -ec ENVIRONMENT. themes/full.pp -o "$BUILD_DIR/.moc/themes/full"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DUSE_THEME="$USE_THEME" -M.filepp_modules -kc '#>' -ec ENVIRONMENT. themes/frame.pp -o "$BUILD_DIR/.moc/themes/frame"
  cp -p "keymap" "$BUILD_DIR/.moc/keymap"
  cp -p "themes/template" "$BUILD_DIR/.moc/themes/template"
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
  mkdir -p "$DEST_DIR/.moc"
  mkdir -p "$DEST_DIR/.moc/themes"
  cp -p "$BUILD_DIR/.moc/config" "$DEST_DIR/.moc/config"
  cp -p "$BUILD_DIR/.moc/themes/normal" "$DEST_DIR/.moc/themes/normal"
  cp -p "$BUILD_DIR/.moc/themes/full" "$DEST_DIR/.moc/themes/full"
  cp -p "$BUILD_DIR/.moc/themes/frame" "$DEST_DIR/.moc/themes/frame"
  cp -p "$BUILD_DIR/.moc/keymap" "$DEST_DIR/.moc/keymap"
  cp -p "$BUILD_DIR/.moc/themes/template" "$DEST_DIR/.moc/themes/template"
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
  if [ -e "$DEST_DIR/.moc/config" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/config" "$DEST_DIR/.moc/config"; then
      echo " ^--- .moc/config"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/config'"
  fi
  if [ -e "$DEST_DIR/.moc/themes/normal" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/themes/normal" "$DEST_DIR/.moc/themes/normal"; then
      echo " ^--- .moc/themes/normal"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/themes/normal'"
  fi
  if [ -e "$DEST_DIR/.moc/themes/full" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/themes/full" "$DEST_DIR/.moc/themes/full"; then
      echo " ^--- .moc/themes/full"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/themes/full'"
  fi
  if [ -e "$DEST_DIR/.moc/themes/frame" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/themes/frame" "$DEST_DIR/.moc/themes/frame"; then
      echo " ^--- .moc/themes/frame"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/themes/frame'"
  fi
  if [ -e "$DEST_DIR/.moc/keymap" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/keymap" "$DEST_DIR/.moc/keymap"; then
      echo " ^--- .moc/keymap"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/keymap'"
  fi
  if [ -e "$DEST_DIR/.moc/themes/template" ]; then
    if ! $DIFF "$BUILD_DIR/.moc/themes/template" "$DEST_DIR/.moc/themes/template"; then
      echo " ^--- .moc/themes/template"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.moc/themes/template'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" THEME_COLOR "$THEME_COLOR"
  printf "export %s=%q\n" USE_THEME "$USE_THEME"
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