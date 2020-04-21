#
#    Copyright (C) 2020 Blacklabs.io
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
# profileplus version 2.0

checkdependency 'whoami'
SUSER=$(whoami)

case $SHELL in
	*/bash|*/rbash)
		declare -r HISTFILE="$PFPRLOGDIR/$SUSER" &>/dev/null
		declare -r HISTFILESIZE=$PFPRLOGSIZE &>/dev/null
		declare -r HISTSIZE=$PFPRLOGLINES &>/dev/null
		declare -r HISTTIMEFORMAT="%d/%m/%y %T " &>/dev/null
		declare -r HISTCONTROL='' &>/dev/null
		declare -r HISTIGNORE='' &>/dev/null
		;;
	*)
		echo "ERROR: your shell is not compatible."
		return 1
		;;
esac
