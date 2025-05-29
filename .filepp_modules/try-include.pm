########################################################################
#
# try-include is free software; you can redistribute it and/or modify
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
#  Project      :  File Preprocessor - try-include module
#  Filename     :  try-include.pm
#  Author       :  Benjamin Abendroth
#  Maintainer   :  Benjamin Abendroth: braph93@gmx.de
#  File version :  0.1
#  Last changed :  Date: 2017-11-14 09:40:02
#  Description  :  This module removes all empty lines
#  Licence      :  GNU copyleft
#
########################################################################
# THIS IS A FILEPP MODULE, YOU NEED FILEPP TO USE IT!!!
# usage: filepp -m try-include.pm <files>
########################################################################

package TryInclude;

use strict;

# version number of module
my $VERSION = '0.1.0';

# remove all empty lines
sub TryInclude
{
    my $include = shift;
    $include = Filepp::RunProcessors($include);
    


    if (Filepp::Ifdef("REMOVE_WHITESPACE_LINES") && $string =~ /^\s*$/) {
       return '';
    }
    elsif ($string =~ /^$/) {
       return '';
    }
    else {
       return $string;
    }
}

Filepp::AddProcessor("TryInclude::TryInclude");

return 1;

########################################################################
# End of file
########################################################################
