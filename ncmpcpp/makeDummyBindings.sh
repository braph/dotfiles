#!/bin/sh

example='/usr/share/doc/ncmpcpp/bindings'

[ -e "$example" ] || exit 0

sed -n "s/#def_key/def_key/p" "$example" | sort -u | sed 's/$/\n\tdummy/g'
