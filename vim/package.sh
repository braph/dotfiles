#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="vim"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

SLOW_SYSTEM_default=0
export SLOW_SYSTEM="${SLOW_SYSTEM:-$SLOW_SYSTEM_default}"

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
  mkdir -p "$BUILD_DIR/.config/nvim"
  mkdir -p "$BUILD_DIR/.config/nvim/skeltons"
  mkdir -p "$BUILD_DIR/.config/nvim/syntax"
  mkdir -p "$BUILD_DIR/.vim/skeltons"
  mkdir -p "$BUILD_DIR/.vim/syntax"
  "$FILEPP" -DSLOW_SYSTEM="$SLOW_SYSTEM" -M.filepp_modules -kc '">' -ec ENVIRONMENT. vimrc.pp.vim -o "$BUILD_DIR/.vimrc"
  "$FILEPP" -DSLOW_SYSTEM="$SLOW_SYSTEM" -M.filepp_modules -kc '">' -ec ENVIRONMENT. nvim.pp.vim -o "$BUILD_DIR/.config/nvim/init.vim"
  cp -p "skeltons/bash.skel" "$BUILD_DIR/.vim/skeltons/bash.skel"
  cp -p "skeltons/main.cpp.skel" "$BUILD_DIR/.vim/skeltons/main.cpp.skel"
  cp -p "skeltons/main.c.skel" "$BUILD_DIR/.vim/skeltons/main.c.skel"
  cp -p "skeltons/perl.skel" "$BUILD_DIR/.vim/skeltons/perl.skel"
  cp -p "skeltons/php.skel" "$BUILD_DIR/.vim/skeltons/php.skel"
  cp -p "syntax/cpp.vim" "$BUILD_DIR/.vim/syntax/cpp.vim"
  cp -p "syntax/pacmanlog.vim" "$BUILD_DIR/.vim/syntax/pacmanlog.vim"
  cp -p "syntax/tmux.vim" "$BUILD_DIR/.vim/syntax/tmux.vim"
  cp -p "skeltons/bash.skel" "$BUILD_DIR/.config/nvim/skeltons/bash.skel"
  cp -p "skeltons/main.cpp.skel" "$BUILD_DIR/.config/nvim/skeltons/main.cpp.skel"
  cp -p "skeltons/main.c.skel" "$BUILD_DIR/.config/nvim/skeltons/main.c.skel"
  cp -p "skeltons/perl.skel" "$BUILD_DIR/.config/nvim/skeltons/perl.skel"
  cp -p "skeltons/php.skel" "$BUILD_DIR/.config/nvim/skeltons/php.skel"
  cp -p "syntax/cpp.vim" "$BUILD_DIR/.config/nvim/syntax/cpp.vim"
  cp -p "syntax/pacmanlog.vim" "$BUILD_DIR/.config/nvim/syntax/pacmanlog.vim"
  cp -p "syntax/tmux.vim" "$BUILD_DIR/.config/nvim/syntax/tmux.vim"
  post_build
}

post_install() {
  LAST_CWD="$PWD"

  # vim
  mkdir -p "$DEST_DIR/.vim/view"
  mkdir -p "$DEST_DIR/.vim/bundle"

  cd "$DEST_DIR/.vim/bundle" && {
    git clone https://github.com/VundleVim/Vundle.vim || true
    cd "$LAST_CWD"
  } || true

  # nvim
  mkdir -p "$DEST_DIR/.config/nvim/view"
  mkdir -p "$DEST_DIR/.config/nvim/bundle"

  cd "$DEST_DIR/.config/nvim/bundle" && {
    git clone https://github.com/VundleVim/Vundle.vim || true
    cd "$LAST_CWD"
  } || true

}

cmd_install() {
  echo "Installing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  mkdir -p "$DEST_DIR/"
  mkdir -p "$DEST_DIR/.config/nvim"
  mkdir -p "$DEST_DIR/.vim/syntax"
  mkdir -p "$DEST_DIR/.config/nvim/syntax"
  mkdir -p "$DEST_DIR/.config/nvim/skeltons"
  mkdir -p "$DEST_DIR/.vim/skeltons"
  cp -p "$BUILD_DIR/.vimrc" "$DEST_DIR/.vimrc"
  cp -p "$BUILD_DIR/.config/nvim/init.vim" "$DEST_DIR/.config/nvim/init.vim"
  cp -p "$BUILD_DIR/.vim/skeltons/bash.skel" "$DEST_DIR/.vim/skeltons/bash.skel"
  cp -p "$BUILD_DIR/.vim/skeltons/main.cpp.skel" "$DEST_DIR/.vim/skeltons/main.cpp.skel"
  cp -p "$BUILD_DIR/.vim/skeltons/main.c.skel" "$DEST_DIR/.vim/skeltons/main.c.skel"
  cp -p "$BUILD_DIR/.vim/skeltons/perl.skel" "$DEST_DIR/.vim/skeltons/perl.skel"
  cp -p "$BUILD_DIR/.vim/skeltons/php.skel" "$DEST_DIR/.vim/skeltons/php.skel"
  cp -p "$BUILD_DIR/.vim/syntax/cpp.vim" "$DEST_DIR/.vim/syntax/cpp.vim"
  cp -p "$BUILD_DIR/.vim/syntax/pacmanlog.vim" "$DEST_DIR/.vim/syntax/pacmanlog.vim"
  cp -p "$BUILD_DIR/.vim/syntax/tmux.vim" "$DEST_DIR/.vim/syntax/tmux.vim"
  cp -p "$BUILD_DIR/.config/nvim/skeltons/bash.skel" "$DEST_DIR/.config/nvim/skeltons/bash.skel"
  cp -p "$BUILD_DIR/.config/nvim/skeltons/main.cpp.skel" "$DEST_DIR/.config/nvim/skeltons/main.cpp.skel"
  cp -p "$BUILD_DIR/.config/nvim/skeltons/main.c.skel" "$DEST_DIR/.config/nvim/skeltons/main.c.skel"
  cp -p "$BUILD_DIR/.config/nvim/skeltons/perl.skel" "$DEST_DIR/.config/nvim/skeltons/perl.skel"
  cp -p "$BUILD_DIR/.config/nvim/skeltons/php.skel" "$DEST_DIR/.config/nvim/skeltons/php.skel"
  cp -p "$BUILD_DIR/.config/nvim/syntax/cpp.vim" "$DEST_DIR/.config/nvim/syntax/cpp.vim"
  cp -p "$BUILD_DIR/.config/nvim/syntax/pacmanlog.vim" "$DEST_DIR/.config/nvim/syntax/pacmanlog.vim"
  cp -p "$BUILD_DIR/.config/nvim/syntax/tmux.vim" "$DEST_DIR/.config/nvim/syntax/tmux.vim"
  post_install
}

cmd_apply() {
  echo "Applying \"$PACKAGE\" ..." >&2
  # vim
  vim  +PluginInstall +quitall || true

  # nvim
  nvim +PluginInstall +quitall || true

}

cmd_diff() {
  echo "Diffing \"$PACKAGE\" ..." >&2
  if ! [ -d "$BUILD_DIR" ]; then
    echo "Error: $BUILD_DIR: No such directory: Did you run \"build\" yet?" >&2
    exit 1
  fi
  if [ -e "$DEST_DIR/.vimrc" ]; then
    if ! $DIFF "$BUILD_DIR/.vimrc" "$DEST_DIR/.vimrc"; then
      echo " ^--- .vimrc"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vimrc'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/init.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/init.vim" "$DEST_DIR/.config/nvim/init.vim"; then
      echo " ^--- .config/nvim/init.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/init.vim'"
  fi
  if [ -e "$DEST_DIR/.vim/skeltons/bash.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/skeltons/bash.skel" "$DEST_DIR/.vim/skeltons/bash.skel"; then
      echo " ^--- .vim/skeltons/bash.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/skeltons/bash.skel'"
  fi
  if [ -e "$DEST_DIR/.vim/skeltons/main.cpp.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/skeltons/main.cpp.skel" "$DEST_DIR/.vim/skeltons/main.cpp.skel"; then
      echo " ^--- .vim/skeltons/main.cpp.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/skeltons/main.cpp.skel'"
  fi
  if [ -e "$DEST_DIR/.vim/skeltons/main.c.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/skeltons/main.c.skel" "$DEST_DIR/.vim/skeltons/main.c.skel"; then
      echo " ^--- .vim/skeltons/main.c.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/skeltons/main.c.skel'"
  fi
  if [ -e "$DEST_DIR/.vim/skeltons/perl.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/skeltons/perl.skel" "$DEST_DIR/.vim/skeltons/perl.skel"; then
      echo " ^--- .vim/skeltons/perl.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/skeltons/perl.skel'"
  fi
  if [ -e "$DEST_DIR/.vim/skeltons/php.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/skeltons/php.skel" "$DEST_DIR/.vim/skeltons/php.skel"; then
      echo " ^--- .vim/skeltons/php.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/skeltons/php.skel'"
  fi
  if [ -e "$DEST_DIR/.vim/syntax/cpp.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/syntax/cpp.vim" "$DEST_DIR/.vim/syntax/cpp.vim"; then
      echo " ^--- .vim/syntax/cpp.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/syntax/cpp.vim'"
  fi
  if [ -e "$DEST_DIR/.vim/syntax/pacmanlog.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/syntax/pacmanlog.vim" "$DEST_DIR/.vim/syntax/pacmanlog.vim"; then
      echo " ^--- .vim/syntax/pacmanlog.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/syntax/pacmanlog.vim'"
  fi
  if [ -e "$DEST_DIR/.vim/syntax/tmux.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.vim/syntax/tmux.vim" "$DEST_DIR/.vim/syntax/tmux.vim"; then
      echo " ^--- .vim/syntax/tmux.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.vim/syntax/tmux.vim'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/skeltons/bash.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/skeltons/bash.skel" "$DEST_DIR/.config/nvim/skeltons/bash.skel"; then
      echo " ^--- .config/nvim/skeltons/bash.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/skeltons/bash.skel'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/skeltons/main.cpp.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/skeltons/main.cpp.skel" "$DEST_DIR/.config/nvim/skeltons/main.cpp.skel"; then
      echo " ^--- .config/nvim/skeltons/main.cpp.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/skeltons/main.cpp.skel'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/skeltons/main.c.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/skeltons/main.c.skel" "$DEST_DIR/.config/nvim/skeltons/main.c.skel"; then
      echo " ^--- .config/nvim/skeltons/main.c.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/skeltons/main.c.skel'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/skeltons/perl.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/skeltons/perl.skel" "$DEST_DIR/.config/nvim/skeltons/perl.skel"; then
      echo " ^--- .config/nvim/skeltons/perl.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/skeltons/perl.skel'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/skeltons/php.skel" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/skeltons/php.skel" "$DEST_DIR/.config/nvim/skeltons/php.skel"; then
      echo " ^--- .config/nvim/skeltons/php.skel"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/skeltons/php.skel'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/syntax/cpp.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/syntax/cpp.vim" "$DEST_DIR/.config/nvim/syntax/cpp.vim"; then
      echo " ^--- .config/nvim/syntax/cpp.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/syntax/cpp.vim'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/syntax/pacmanlog.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/syntax/pacmanlog.vim" "$DEST_DIR/.config/nvim/syntax/pacmanlog.vim"; then
      echo " ^--- .config/nvim/syntax/pacmanlog.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/syntax/pacmanlog.vim'"
  fi
  if [ -e "$DEST_DIR/.config/nvim/syntax/tmux.vim" ]; then
    if ! $DIFF "$BUILD_DIR/.config/nvim/syntax/tmux.vim" "$DEST_DIR/.config/nvim/syntax/tmux.vim"; then
      echo " ^--- .config/nvim/syntax/tmux.vim"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.config/nvim/syntax/tmux.vim'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" SLOW_SYSTEM "$SLOW_SYSTEM"
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