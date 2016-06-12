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

# test ksh HISTTIMEFORMAT

if [ -x `which uname` ]; then
	case "`uname`" in
		Linux)
			if [ -x "`which whoami`" ]; then
				SUSER=`whoami`
			else
				SUSER=$EUID
			fi
			;;
		*BSD)
			if [ -x "`which whoami`" ]; then
				SUSER=`whoami`
			else
				SUSER=$EUID
			fi
			;;
		SunOS)
			if [ -x /usr/ucb/whoami ]; then
				SUSER=`/usr/ucb/whoami`
			else
				SUSER=$EUID
			fi
			;;
		*)
			SUSER=$EUID
			;;
	esac
else
	echo "ERROR: uname is missing..."

	return 1
fi

case $SHELL in
# add a special case for /bin/sh with a check to make sure its bash
	/bin/sh|*/bash|*/rbash)
		declare -r HISTFILE="$PFPRLOGDIR/$SUSER" &>/dev/null
		declare -r HISTFILESIZE=$PFPRLOGSIZE &>/dev/null
		declare -r HISTSIZE=$PFPRLOGLINES &>/dev/null
		declare -r HISTTIMEFORMAT="%d/%m/%y %T " &>/dev/null
		;;
	*/ksh)
		typeset -r HISTFILE="$PFPRLOGDIR/$SUSER" &>/dev/null
		typeset -r HISTFILESIZE=$PFPRLOGSIZE &>/dev/null
		typeset -r HISTSIZE=$PFPRLOGLINES &>/dev/null
		typeset -r HISTTIMEFORMAT="%d/%m/%y %T " &>/dev/null
		;;
	*)
		echo "ERROR: your shell is not compatible."

		return 911
		;;
esac
