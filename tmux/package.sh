#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="tmux"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

THEME_COLOR_default=blue
export THEME_COLOR="${THEME_COLOR:-$THEME_COLOR_default}"

DEFAULT_SHELL_default=$(if type zsh >/dev/null 2>/dev/null; then
    echo /bin/zsh
  elif type bash >/dev/null 2>/dev/null; then
    echo /bin/bash
  else
    echo /bin/sh
  fi)
export DEFAULT_SHELL="${DEFAULT_SHELL:-$DEFAULT_SHELL_default}"

HAVE_DEV_SHM_default=$(test -d /dev/shm && echo 1 || echo 0)
export HAVE_DEV_SHM="${HAVE_DEV_SHM:-$HAVE_DEV_SHM_default}"

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
  mkdir -p "$BUILD_DIR/"
  mkdir -p "$BUILD_DIR/.tmux/bin"
  "$FILEPP" -DTHEME_COLOR="$THEME_COLOR" -DDEFAULT_SHELL="$DEFAULT_SHELL" -DHAVE_DEV_SHM="$HAVE_DEV_SHM" -M.filepp_modules -m bigdef.pm -m function.pm -m hash-comment.pm -m remove-empty-lines.pm -kc '#>' -ec ENVIRONMENT. tmux.conf.pp -o "$BUILD_DIR/.tmux.conf"
  cp -p "tmux/bin/zsh_read" "$BUILD_DIR/.tmux/bin/zsh_read"
  cp -p "tmux/bin/websearch" "$BUILD_DIR/.tmux/bin/websearch"
  cp -p "tmux/bin/w3m_openurl" "$BUILD_DIR/.tmux/bin/w3m_openurl"
  cp -p "tmux/bin/tmux_daemon.pl" "$BUILD_DIR/.tmux/bin/tmux_daemon.pl"
  cp -p "tmux/bin/simpleread" "$BUILD_DIR/.tmux/bin/simpleread"
  cp -p "tmux/bin/menu" "$BUILD_DIR/.tmux/bin/menu"
  cp -p "tmux/bin/aggressive_window_switch" "$BUILD_DIR/.tmux/bin/aggressive_window_switch"
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
  mkdir -p "$DEST_DIR/"
  mkdir -p "$DEST_DIR/.tmux/bin"
  cp -p "$BUILD_DIR/.tmux.conf" "$DEST_DIR/.tmux.conf"
  cp -p "$BUILD_DIR/.tmux/bin/zsh_read" "$DEST_DIR/.tmux/bin/zsh_read"
  cp -p "$BUILD_DIR/.tmux/bin/websearch" "$DEST_DIR/.tmux/bin/websearch"
  cp -p "$BUILD_DIR/.tmux/bin/w3m_openurl" "$DEST_DIR/.tmux/bin/w3m_openurl"
  cp -p "$BUILD_DIR/.tmux/bin/tmux_daemon.pl" "$DEST_DIR/.tmux/bin/tmux_daemon.pl"
  cp -p "$BUILD_DIR/.tmux/bin/simpleread" "$DEST_DIR/.tmux/bin/simpleread"
  cp -p "$BUILD_DIR/.tmux/bin/menu" "$DEST_DIR/.tmux/bin/menu"
  cp -p "$BUILD_DIR/.tmux/bin/aggressive_window_switch" "$DEST_DIR/.tmux/bin/aggressive_window_switch"
  post_install
}

cmd_apply() {
  echo "Applying \"$PACKAGE\" ..." >&2
  echo "Reloading tmux conf ..." >&2
  tmux source ~/.tmux.conf && echo DONE || echo FAILED

}

cmd_diff() {
  echo "Diffing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  if [ -e "$DEST_DIR/.tmux.conf" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux.conf" "$DEST_DIR/.tmux.conf"; then
      echo " ^--- .tmux.conf"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux.conf'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/zsh_read" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/zsh_read" "$DEST_DIR/.tmux/bin/zsh_read"; then
      echo " ^--- .tmux/bin/zsh_read"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/zsh_read'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/websearch" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/websearch" "$DEST_DIR/.tmux/bin/websearch"; then
      echo " ^--- .tmux/bin/websearch"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/websearch'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/w3m_openurl" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/w3m_openurl" "$DEST_DIR/.tmux/bin/w3m_openurl"; then
      echo " ^--- .tmux/bin/w3m_openurl"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/w3m_openurl'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/tmux_daemon.pl" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/tmux_daemon.pl" "$DEST_DIR/.tmux/bin/tmux_daemon.pl"; then
      echo " ^--- .tmux/bin/tmux_daemon.pl"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/tmux_daemon.pl'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/simpleread" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/simpleread" "$DEST_DIR/.tmux/bin/simpleread"; then
      echo " ^--- .tmux/bin/simpleread"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/simpleread'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/menu" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/menu" "$DEST_DIR/.tmux/bin/menu"; then
      echo " ^--- .tmux/bin/menu"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/menu'"
  fi
  if [ -e "$DEST_DIR/.tmux/bin/aggressive_window_switch" ]; then
    if ! $DIFF "$BUILD_DIR/.tmux/bin/aggressive_window_switch" "$DEST_DIR/.tmux/bin/aggressive_window_switch"; then
      echo " ^--- .tmux/bin/aggressive_window_switch"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.tmux/bin/aggressive_window_switch'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" THEME_COLOR "$THEME_COLOR"
  printf "export %s=%q\n" DEFAULT_SHELL "$DEFAULT_SHELL"
  printf "export %s=%q\n" HAVE_DEV_SHM "$HAVE_DEV_SHM"
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