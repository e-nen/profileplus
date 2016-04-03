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

if [ -f /etc/profileplus/config ]; then
# this needs to check the config perms and env
	source /etc/profileplus/config
else
	echo "ERROR: /etc/profileplus/config not found or readable"

	exit 1
fi

if [ -z $PFPINSTDIR ]; then
	echo "ERROR: YOUR ENVIRONMENT IS NOT PROPERLY CONFIGURED"

	exit 2
fi

if [ "$EUID" == "0" ]; then
	export PATH=$PATH:$PFPINSTDIR/sbin:$PFPINSTDIR/bin &>/dev/null
else
	export PATH=$PATH:$PFPINSTDIR/bin &>/dev/null
fi

if [ "$PFPPATHROOT" == "1" ] && [ "$EUID" == "0" ]; then
	if ! [ -d /root/bin ]; then
		echo -e "\nCreating /root/bin\n"
		mkdir /root/bin
		chmod 700 /root/bin
	fi
	export PATH=/root/bin:$PATH &>/dev/null
fi

if [ "$PFPPATHUSER" == "1" ] && [ "$EUID" != "0" ]; then
	if ! [ -d $HOME/bin ]; then
		echo -e "\nCreating $HOME/bin\n"
		mkdir $HOME/bin
		chmod 700 $HOME/bin
	fi
	export PATH=$HOME/bin:$PATH &>/dev/null
fi

if [ "$PFPPATHLOCK" == "1" ]; then
	declare -r PATH=$PATH &>/dev/null
fi

if [ "$PFPPUSCF" == "1" ] && [ "$EUID" == "0" ]; then
	$PFPINSTDIR/sbin/protectshellconfigs
fi

if [ "$PFPSOLARISPRTDIAG" == "1" ] && [ "$EUID" == "0" ]; then
	$PFPINSTDIR/sbin/solarisprtdiag
fi

if [ "$PFPRLOG" == "1" ]; then
	source $PFPINSTDIR/modules/rlog.sh
fi

if [ "$PFPSHOPT" == "1" ]; then
	source $PFPINSTDIR/modules/shopt.sh
fi

if ! [ "$PFPPROMPT" == "0" ]; then
	source $PFPINSTDIR/modules/prompt.sh
	prompt
	if [ "$PFPPROMPTTERMBAR" == "1" ]; then
		source $PFPINSTDIR/modules/termbar.sh
		termbar
	fi
fi

# loadbar
# clock
