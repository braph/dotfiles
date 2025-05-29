#!/usr/bin/env python2

# zsh_generate_options.py - extract default zsh config from manpage
# Copyright (C) 2015 Benjamin Abendroth
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

import subprocess
import re
import os

devNull = open(os.devnull, "w")
manZsh	= subprocess.Popen(['man', 'zshoptions'], stdout=subprocess.PIPE, stderr=devNull)

begin = False
startHeading = "Changing Directories"
endHeading = "OPTION ALIASES"

splitPattern = re.compile("(\s*)(.*)")
defaultPattern = re.compile("\\<[DZ]\\>")

ignoreSections = ["Shell State", "Scripts and Functions"]
forceEnabled = ["ZLE", "MONITOR"]
forceDisabled = []
currentSection = ""

print '#!/bin/zsh'
print

for line in manZsh.stdout:
	line = line.rstrip()

	whitespace, line = splitPattern.match(line).groups()
	numWhitespace = len(whitespace)

	if not begin:
		if line == startHeading:
			begin = True
		else:
			continue

	elif line == endHeading:
		break


	if numWhitespace == 3:
		currentSection = line

		if currentSection in ignoreSections:
			continue

		print '#' * 80
		print '#' + line.center(78) + '#'
		print '#' * 80

	if currentSection in ignoreSections:
		continue

	if numWhitespace >= 14:
		print "#", line

	elif numWhitespace >= 7:
		defaults = defaultPattern.findall(line)
		option, trash, trash = line.partition(" ")

		if option in forceEnabled:
			print "setopt", option
		elif option in forceDisabled:
			print "unsetopt", option
		elif "<Z>" in defaults or "<D>" in defaults :
			print "setopt", option
		else:
			print "unsetopt", option

		print '#', line.strip()
		print '#'

	else:
		print '#'
