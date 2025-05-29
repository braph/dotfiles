#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="shells"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"

LANGUAGE_default=en_US.UTF-8
export LANGUAGE="${LANGUAGE:-$LANGUAGE_default}"

SLOW_SYSTEM_default=0
export SLOW_SYSTEM="${SLOW_SYSTEM:-$SLOW_SYSTEM_default}"

PROMPT_STYLE_default=MOSTLY_RIGHT
export PROMPT_STYLE="${PROMPT_STYLE:-$PROMPT_STYLE_default}"

USE_FORTUNE_default=0
export USE_FORTUNE="${USE_FORTUNE:-$USE_FORTUNE_default}"

COLORIZE_COPE_default=1
export COLORIZE_COPE="${COLORIZE_COPE:-$COLORIZE_COPE_default}"

COLORIZE_GRC_default=1
export COLORIZE_GRC="${COLORIZE_GRC:-$COLORIZE_GRC_default}"

COLORIZE_CW_default=1
export COLORIZE_CW="${COLORIZE_CW:-$COLORIZE_CW_default}"

REMOVE_WHITESPACE_LINES_default=1
export REMOVE_WHITESPACE_LINES="${REMOVE_WHITESPACE_LINES:-$REMOVE_WHITESPACE_LINES_default}"

TMUX_VERSION_default=$(if type tmux &>/dev/null 2>/dev/null; then
    tmux -V | sed 's/tmux //'
  else
    echo 0.0
  fi)
export TMUX_VERSION="${TMUX_VERSION:-$TMUX_VERSION_default}"

GEMPATH_default=$(if type gem &>/dev/null; then
    gem env gempath
  fi)
export GEMPATH="${GEMPATH:-$GEMPATH_default}"

PRESERVE_ROOT_default=$(if rm --help 2>&1 | grep -q -- --preserve-root; then
    echo --preserve-root
  fi)
export PRESERVE_ROOT="${PRESERVE_ROOT:-$PRESERVE_ROOT_default}"

ONE_FILE_SYSTEM_default=$(if rm --help 2>&1 | grep -q -- --one-file-system; then
    echo --one-file-system
  fi)
export ONE_FILE_SYSTEM="${ONE_FILE_SYSTEM:-$ONE_FILE_SYSTEM_default}"

LS_COLOR_default=$(if ls --help 2>&1 | grep -q -- --color; then
    echo --color=auto;
  else
    echo -G
  fi)
export LS_COLOR="${LS_COLOR:-$LS_COLOR_default}"

HAVE_NVIM_default=$(type nvim &>/dev/null && echo 1 || echo 0)
export HAVE_NVIM="${HAVE_NVIM:-$HAVE_NVIM_default}"

HAVE_MAN_PROMPT_default=$(if man --help 2>&1 | grep -q -- --prompt; then
    echo 1
  else
    echo 0
  fi)
export HAVE_MAN_PROMPT="${HAVE_MAN_PROMPT:-$HAVE_MAN_PROMPT_default}"

pre_build() {
  get_filepp
  mkdir -p "$BUILD_DIR"
  # TODO use PACKAGE_TEMP_DIR

  if type conpalette &>/dev/null; then
    conpalette --shell --oneline blah-light > "$TEMP_DIR/vt_palette"
  else
    if ! [ -d "$TEMP_DIR/conpalette" ]; then
      git clone "https://github.com/braph/conpalette" "$TEMP_DIR/conpalette" || true
    fi

    "$TEMP_DIR/conpalette/bin/conpalette" --shell --oneline blah-light > "$TEMP_DIR/vt_palette";
  fi

  ./zsh/tools/zsh_trim_setopts.sh zsh/zshoptions "$TEMP_DIR/zshoptions"
  #./zsh/tools/zsh_trim_aliases.sh

}

post_build() {
  true
}

cmd_build() {
  echo "Building \"$PACKAGE\" ..." >&2
  pre_build
  mkdir -p "$BUILD_DIR/"
  "$FILEPP" -DLANGUAGE="$LANGUAGE" -DSLOW_SYSTEM="$SLOW_SYSTEM" -DPROMPT_STYLE="$PROMPT_STYLE" -DUSE_FORTUNE="$USE_FORTUNE" -DCOLORIZE_COPE="$COLORIZE_COPE" -DCOLORIZE_GRC="$COLORIZE_GRC" -DCOLORIZE_CW="$COLORIZE_CW" -DREMOVE_WHITESPACE_LINES="$REMOVE_WHITESPACE_LINES" -DTMUX_VERSION="$TMUX_VERSION" -DGEMPATH="$GEMPATH" -DPRESERVE_ROOT="$PRESERVE_ROOT" -DONE_FILE_SYSTEM="$ONE_FILE_SYSTEM" -DLS_COLOR="$LS_COLOR" -DHAVE_NVIM="$HAVE_NVIM" -DHAVE_MAN_PROMPT="$HAVE_MAN_PROMPT" -M.filepp_modules -m hash-comment.pm -m remove-empty-lines.pm -I$TEMP_DIR -Icommon -kc '#>' -ec ENVIRONMENT. bash/bashrc -o "$BUILD_DIR/.bashrc"
  "$FILEPP" -DLANGUAGE="$LANGUAGE" -DSLOW_SYSTEM="$SLOW_SYSTEM" -DPROMPT_STYLE="$PROMPT_STYLE" -DUSE_FORTUNE="$USE_FORTUNE" -DCOLORIZE_COPE="$COLORIZE_COPE" -DCOLORIZE_GRC="$COLORIZE_GRC" -DCOLORIZE_CW="$COLORIZE_CW" -DREMOVE_WHITESPACE_LINES="$REMOVE_WHITESPACE_LINES" -DTMUX_VERSION="$TMUX_VERSION" -DGEMPATH="$GEMPATH" -DPRESERVE_ROOT="$PRESERVE_ROOT" -DONE_FILE_SYSTEM="$ONE_FILE_SYSTEM" -DLS_COLOR="$LS_COLOR" -DHAVE_NVIM="$HAVE_NVIM" -DHAVE_MAN_PROMPT="$HAVE_MAN_PROMPT" -M.filepp_modules -m hash-comment.pm -m remove-empty-lines.pm -I$TEMP_DIR -Icommon -kc '#>' -ec ENVIRONMENT. zsh/zshrc -o "$BUILD_DIR/.zshrc"
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
  cp -p "$BUILD_DIR/.bashrc" "$DEST_DIR/.bashrc"
  cp -p "$BUILD_DIR/.zshrc" "$DEST_DIR/.zshrc"
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
  if [ -e "$DEST_DIR/.bashrc" ]; then
    if ! $DIFF "$BUILD_DIR/.bashrc" "$DEST_DIR/.bashrc"; then
      echo " ^--- .bashrc"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.bashrc'"
  fi
  if [ -e "$DEST_DIR/.zshrc" ]; then
    if ! $DIFF "$BUILD_DIR/.zshrc" "$DEST_DIR/.zshrc"; then
      echo " ^--- .zshrc"
    fi
  else
    echo "No such file or directory: '$DEST_DIR/.zshrc'"
  fi
}

cmd_show() {
  echo "Showing \"$PACKAGE\" ..." >&2
  printf "export %s=%q\n" LANGUAGE "$LANGUAGE"
  printf "export %s=%q\n" SLOW_SYSTEM "$SLOW_SYSTEM"
  printf "export %s=%q\n" PROMPT_STYLE "$PROMPT_STYLE"
  printf "export %s=%q\n" USE_FORTUNE "$USE_FORTUNE"
  printf "export %s=%q\n" COLORIZE_COPE "$COLORIZE_COPE"
  printf "export %s=%q\n" COLORIZE_GRC "$COLORIZE_GRC"
  printf "export %s=%q\n" COLORIZE_CW "$COLORIZE_CW"
  printf "export %s=%q\n" REMOVE_WHITESPACE_LINES "$REMOVE_WHITESPACE_LINES"
  printf "export %s=%q\n" TMUX_VERSION "$TMUX_VERSION"
  printf "export %s=%q\n" GEMPATH "$GEMPATH"
  printf "export %s=%q\n" PRESERVE_ROOT "$PRESERVE_ROOT"
  printf "export %s=%q\n" ONE_FILE_SYSTEM "$ONE_FILE_SYSTEM"
  printf "export %s=%q\n" LS_COLOR "$LS_COLOR"
  printf "export %s=%q\n" HAVE_NVIM "$HAVE_NVIM"
  printf "export %s=%q\n" HAVE_MAN_PROMPT "$HAVE_MAN_PROMPT"
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