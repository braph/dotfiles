#!/usr/bin/env bash

FILEPP_VERSION=1.8.0
FILEPP_FILE="filepp-$FILEPP_VERSION.tar.gz"
FILEPP_URL="http://www-users.york.ac.uk/~dm26/filepp/$FILEPP_FILE"

cd '/tmp'

wget "$FILEPP_URL" || {
   echo "Could not download filepp archive" >&2;
   exit 1;
}

tar xf "$FILEPP_FILE" || {
   echo "Could not extract filepp archive" >&2;
   exit 1;
}

cd "filepp-$FILEPP_VERSION" || {
   echo "Could not change to filepp directory" >&2;
   exit 1;
}

./configure
make
sudo make install
