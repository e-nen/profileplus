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

#[ -z "$PS1" ] && return # this would probably work fine but i want to actually check for the interactive flag so...
case $- in
	*i*)
		;;
	*)
		return
		;;
esac

if [ -f /etc/profileplus/modules/utilities.sh ]; then
	source /etc/profileplus/modules/utilities.sh
else
	errorfail '/etc/profileplus/modules/utilities.sh not found or readable'
fi

if [ -f /etc/profileplus/config ]; then
# this needs to check the config perms and env
	source /etc/profileplus/config
else
	warnfail '/etc/profileplus/config not found or readable... creating default config'
	/etc/profileplus/configure.sh -1
	source /etc/profileplus/config
fi

if [ "$EUID" == "0" ]; then
	export PATH=$PATH:/etc/profileplus/sbin:/etc/profileplus/bin &>/dev/null
else
	export PATH=$PATH:/etc/profileplus/bin &>/dev/null
fi

if [ "$PFPPATHROOT" == "1" ] && [ "$EUID" == "0" ]; then
	if ! [ -d /root/bin ]; then
		mkdir /root/bin
		chmod 700 /root/bin
	fi
	export PATH=$PATH:/root/bin &>/dev/null
fi

if [ "$PFPPATHUSER" == "1" ] && [ "$EUID" != "0" ]; then
	if ! [ -d $HOME/bin ]; then
		mkdir $HOME/bin
		chmod 700 $HOME/bin
	fi
	export PATH=$PATH:$HOME/bin &>/dev/null
fi

if [ "$PFPPATHLOCK" == "1" ]; then
	declare -r PATH=$PATH &>/dev/null
fi

if [ "$PFPRLOG" == "1" ]; then
	source /etc/profileplus/modules/rlog.sh
fi

if [ "$PFPSHOPT" == "1" ]; then
	source /etc/profileplus/modules/shopt.sh
fi

if ! [ "$PFPPROMPT" == "0" ]; then
	source /etc/profileplus/modules/prompt.sh
	prompt
	if [ "$PFPPROMPTTERMBAR" == "1" ]; then
		termbar
	fi
fi

if [ -f /etc/profileplus/modules/aliases.sh ]; then
	source /etc/profileplus/modules/aliases.sh
else
	warnfail '/etc/profileplus/modules/aliases.sh not found or readable'
fi