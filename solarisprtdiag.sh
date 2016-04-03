#!/bin/bash
#
#    Copyright (C) 2016 Eric Siskonen
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#    GNU/GPL v2 license can be found here: http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
#
# profileplus version 1.0

# this needs to be tested on solaris 11

PRTDIAGBIN=/usr/platform/`uname -m`/sbin/prtdiag
if ! [ -x $PRTDIAGBIN ]; then
	echo "ERROR: prtdiag not found or executable"

	exit 1
else
	case "`$PRTDIAGBIN -v >/dev/null;echo $?`" in
		0)
			echo;echo "DIAG: System hardware is OK.";echo
			;;
		1)
			echo;echo "DIAG: $PRTDIAGBIN reports hardware problems!";echo
			$PRTDIAGBIN -v
			;;
		*)
			echo;echo "DIAG: $PRTDIAGBIN returned an internal error!";echo
			;;
	esac
fi
