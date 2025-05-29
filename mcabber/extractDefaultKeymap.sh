#!/bin/bash

# extractDefaultKeymap.sh - extract default mcabber keymap
# Copyright (C) 2017 Benjamin Abendroth
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

MCABBER_BUFFER="/tmp/mcabber-extractDefaultKeymap.$USER.$$"

# dump "bind" command to file
mcabber -f <(printf "bind\n\n") > "$MCABBER_BUFFER" &
sleep 1;
kill %1

sed -n -r "s/.*Key[[:space:]]*(.*) is bound to: ([a-zA-Z0-9_ -]*).*/bind \1 \2/p" "$MCABBER_BUFFER"

rm "$MCABBER_BUFFER"
