########################################################################
#
# testfile is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#
########################################################################
#
#  Project      :  File Preprocessor - testfile module
#  Filename     :  testfile.pm
#  Author       :  Benjamin Abendroth
#  Description  :  This module allows file testing.
#  Licence      :  GNU copyleft
#
########################################################################
# THIS IS A FILEPP MODULE, YOU NEED FILEPP TO USE IT!!!
# usage: filepp -m testfile.pm <files>
########################################################################

package TestFile;

use strict;

# version number of module
my $VERSION = '0.0.1';

require "function.pm";

sub TestFile
{
    my $flags = shift;
    my $filename = shift;

    for my $flag (split(//, $flags)) {
       return '' if not eval "-$flag $filename";
    }

    return 1;
}
Function::AddFunction("testfile", "TestFile::TestFile");

return 1;

########################################################################
# End of file
########################################################################

