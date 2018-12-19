#!/usr/bin/env bash

FILEPP_VERSION=1.8.0
FILEPP_TAR_GZ="filepp-$FILEPP_VERSION.tar.gz"
FILEPP_URL="http://www-users.york.ac.uk/~dm26/filepp/$FILEPP_TAR_GZ"
FILEPP_DIR="filepp-$FILEPP_VERSION"

MYDIR=$(realpath "$(dirname "$0")")
cd "$MYDIR"

rm -rf "$FILEPP_TAR_GZ" "$FILEPP_DIR" "bin" "share"

wget "$FILEPP_URL" || {
   echo "Could not download filepp archive" >&2;
   exit 1;
}

tar xf "$FILEPP_TAR_GZ" || {
   echo "Could not extract filepp archive" >&2;
   exit 1;
}

cd "$FILEPP_DIR" || {
   echo "Could not change to filepp directory" >&2;
   exit 1;
}

./configure --prefix="$MYDIR"
make
make install

cd "$MYDIR"
rm -rf "$FILEPP_TAR_GZ" "$FILEPP_DIR"
