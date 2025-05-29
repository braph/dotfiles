#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="mcabber"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

THEME_COLOR_default=blue
export THEME_COLOR="${THEME_COLOR:-$THEME_COLOR_default}"

NICK_default=Kartoffel
export NICK="${NICK:-$NICK_default}"

JID_default=INSERT_JID_HERE
export JID="${JID:-$JID_default}"

PASSWORD_default=INSERT_PW_HERE
export PASSWORD="${PASSWORD:-$PASSWORD_default}"

JOIN_ROOMS_default=''
export JOIN_ROOMS="${JOIN_ROOMS:-$JOIN_ROOMS_default}"

PORT_default=5222
export PORT="${PORT:-$PORT_default}"

HOST_default=''
export HOST="${HOST:-$HOST_default}"

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
  mkdir -p "$BUILD_DIR/.mcabber"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DNICK="$NICK" -DJID="$JID" -DPASSWORD="$PASSWORD" -DJOIN_ROOMS="$JOIN_ROOMS" -DPORT="$PORT" -DHOST="$HOST" -M.filepp_modules -m maths.pm -m testfile.pm -m foreach.pm -kc '#>' -ec ENVIRONMENT. mcabber/mcabberrc.pp -o "$BUILD_DIR/.mcabber/mcabberrc"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DNICK="$NICK" -DJID="$JID" -DPASSWORD="$PASSWORD" -DJOIN_ROOMS="$JOIN_ROOMS" -DPORT="$PORT" -DHOST="$HOST" -M.filepp_modules -m maths.pm -m testfile.pm -m foreach.pm -kc '#>' -ec ENVIRONMENT. mcabber/hook-post-connect.pp -o "$BUILD_DIR/.mcabber/hook-post-connect"
  cp -p "mcabber/hook-pre-disconnect" "$BUILD_DIR/.mcabber/hook-pre-disconnect"
  post_build
}

post_install() {
  mkdir -p "$DEST_DIR/.mcabber/history" mkdir -p "$DEST_DIR/.mcabber/otr"
}

cmd_install() {
  echo "Installing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  mkdir -p "$DEST_DIR/.mcabber"
  cp -p "$BUILD_DIR/.mcabber/mcabberrc" "$DEST_DIR/.mcabber/mcabberrc"
  cp -p "$BUILD_DIR/.mcabber/hook-post-connect" "$DEST_DIR/.mcabber/hook-post-connect"
  cp -p "$BUILD_DIR/.mcabber/hook-pre-disconnect" "$DEST_DIR/.mcabber/hook-pre-disconnect"
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
  if [ -e "$DEST_DIR/.mcabber/mcabberrc" ]; then
    if ! $DIFF "$BUILD_DIR/.mcabber/mcabberrc" "$DEST_DIR/.mcabber/mcabberrc"; then
      echo " ^--- .mcabber/mcabberrc"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.mcabber/mcabberrc'"
  fi
  if [ -e "$DEST_DIR/.mcabber/hook-post-connect" ]; then
    if ! $DIFF "$BUILD_DIR/.mcabber/hook-post-connect" "$DEST_DIR/.mcabber/hook-post-connect"; then
      echo " ^--- .mcabber/hook-post-connect"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.mcabber/hook-post-connect'"
  fi
  if [ -e "$DEST_DIR/.mcabber/hook-pre-disconnect" ]; then
    if ! $DIFF "$BUILD_DIR/.mcabber/hook-pre-disconnect" "$DEST_DIR/.mcabber/hook-pre-disconnect"; then
      echo " ^--- .mcabber/hook-pre-disconnect"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.mcabber/hook-pre-disconnect'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" THEME_COLOR "$THEME_COLOR"
  printf "export %s=%q\n" NICK "$NICK"
  printf "export %s=%q\n" JID "$JID"
  printf "export %s=%q\n" PASSWORD "$PASSWORD"
  printf "export %s=%q\n" JOIN_ROOMS "$JOIN_ROOMS"
  printf "export %s=%q\n" PORT "$PORT"
  printf "export %s=%q\n" HOST "$HOST"
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

  LAST_PWD="$PWD"

  mkdir -p "$FILEPP_DIR"

  cd "$FILEPP_DIR"

  FILEPP_VERSION="1.8.0"
  FILEPP_TAR_GZ="filepp-$FILEPP_VERSION.tar.gz"
  FILEPP_SOURCE_DIR="filepp-$FILEPP_VERSION"
  FILEPP_URL="http://www-users.york.ac.uk/~dm26/filepp/$FILEPP_TAR_GZ"

  if type wget >/dev/null 2>/dev/null; then
    echo "Downloading \"$FILEPP_URL\" ..." >&2

    if ! wget "$FILEPP_URL" -O "$FILEPP_TAR_GZ" 2>log; then
      cat log >&2
      echo "Error: Command failed: wget \"$FILEPP_URL\" -O \"$FILEPP_TAR_GZ\"" >&2
      exit 1
    fi
  elif type curl >/dev/null 2>/dev/null; then
    echo "Downloading \"$FILEPP_URL\" ..." >&2

    if ! curl -L --fail "$FILEPP_URL" -o "$FILEPP_TAR_GZ" 2>log; then
      cat log >&2
      echo "Error: Command failed: curl -L --fail \"$FILEPP_URL\" -o \"$FILEPP_TAR_GZ\"" >&2
      exit 1
    fi
  else
    echo "Error: No curl or wget found" >&2
    exit 1
  fi

  if ! type tar >/dev/null 2>/dev/null; then
    echo "Error: No tar program found" >&2
    exit 1
  fi

  if ! type make >/dev/null 2>/dev/null; then
    echo "Error: No make program found" >&2
    exit 1
  fi

  echo "Extracting archive ..." >&2

  if ! tar xf "$FILEPP_TAR_GZ" 2>log; then
    cat log >&2
    echo "Error: Command failed: tar xf \"$FILEPP_TAR_GZ\"" >&2
    exit 1
  fi

  cd "$FILEPP_SOURCE_DIR"

  echo "Calling ./configure ..." >&2

  if ! ./configure --prefix="$FILEPP_DIR" 2>log; then
    cat log >&2
    echo "Error: Command falied: ./configure --prefix=\"$FILEPP_DIR\"" >&2
    exit 1
  fi

  echo "Calling make ..." >&2

  if ! make 2>log; then
    cat log >&2
    echo "Command failed: make" >&2
    exit 1
  fi

  echo "Calling make install ..." >&2

  if ! make install 2>log; then
    cat log >&2
    echo "Command failed: make install" >&2
    exit 1
  fi

  cd "$LAST_PWD"
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