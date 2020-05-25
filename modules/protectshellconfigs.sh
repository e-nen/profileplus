#!/bin/bash
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

if [ $EUID != "0" ]; then
	echo "ERROR: root user privileges required"
        exit 1
fi

if [ -f "/etc/skel/.bashrc" ] && [ "`stat -c %s /etc/skel/.bashrc`" -ne 20 ] && [ -z "`grep 'source /etc/profile' /etc/skel/.bashrc`" ]; then
	if ! [ -d /etc/skel-originals ]; then
		mkdir /etc/skel-originals
		chown root:root /etc/skel-originals
		chmod 000 /etc/skel-originals
	fi
	mv /etc/skel/.bashrc "/etc/skel-originals/.bashrc-$(date +'%m%d%Y%H%M%S')" &>/dev/null
fi
touch /etc/skel/.bashrc &>/dev/null
echo 'source /etc/profile' >/etc/skel/.bashrc
chown root:root /etc/skel/.bashrc &>/dev/null
chmod 644 /etc/skel/.bashrc &>/dev/null

if [ -f "/etc/skel/.bash_profile" ] && [ "`stat -c %s /etc/skel/.bash_profile`" -ne 0 ]; then
	if ! [ -d /etc/skel-originals ]; then
		mkdir /etc/skel-originals
		chown root:root /etc/skel-originals
		chmod 000 /etc/skel-originals
	fi
	mv /etc/skel/.bash_profile "/etc/skel-originals/.bash_profile-$(date +'%m%d%Y%H%M%S')" &>/dev/null
fi
touch /etc/skel/.bash_profile &>/dev/null
chown root:root /etc/skel/.bash_profile &>/dev/null
chmod 644 /etc/skel/.bash_profile &>/dev/null

if [ -f "/etc/skel/.profile" ] && [ "`stat -c %s /etc/skel/.profile`" -ne 0 ]; then
	if ! [ -d /etc/skel-originals ]; then
		mkdir /etc/skel-originals
		chown root:root /etc/skel-originals
		chmod 000 /etc/skel-originals
	fi
	mv /etc/skel/.profile "/etc/skel-originals/.profile-$(date +'%m%d%Y%H%M%S')" &>/dev/null
fi
touch /etc/skel/.profile &>/dev/null
chown root:root /etc/skel/.profile &>/dev/null
chmod 644 /etc/skel/.profile &>/dev/null

PASSWDLEN=`wc -l /etc/passwd|awk '{ print $1 }'`
FORLIM=$(($PASSWDLEN+1))

for (( i=1; i<FORLIM; i++ ))
do
	dstring=$i"p"
	CURUSER=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $1 }'`
	CURGROUP=`id -gn $CURUSER`
	CURHOME=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $6 }'`
	CURSHELL=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $7 }'`

	if [ "$CURUSER" != "root" ] && [ "$CURHOME" == "/root" ]; then
		continue
	fi

	case $CURSHELL in
		/bin/sh|*/bash|*/rbash)
			if [ -d "$CURHOME" ]; then
				if [ -f "$CURHOME/.bashrc" ] && [ "`stat -c %s $CURHOME/.bashrc`" -ne 20 ] && [ -z "`grep 'source /etc/profile' $CURHOME/.bashrc`" ]; then
					rm -f "$CURHOME/.bashrc" &>/dev/null
					cp /etc/skel/.bashrc "$CURHOME/.bashrc" &>/dev/null
					chown root:root "$CURHOME/.bashrc" &>/dev/null
					chmod 644 "$CURHOME/.bashrc" &>/dev/null
				elif ! [ -f "$CURHOME/.bashrc" ]; then
					cp /etc/skel/.bashrc "$CURHOME/.bashrc" &>/dev/null
					chown root:root "$CURHOME/.bashrc" &>/dev/null
					chmod 644 "$CURHOME/.bashrc" &>/dev/null
				fi
				if [ -f "$CURHOME/.bash_profile" ] && [ "`stat -c %s $CURHOME/.bash_profile`" -ne 0 ]; then
					rm -f "$CURHOME/.bash_profile" &>/dev/null
					cp /etc/skel/.bash_profile "$CURHOME/.bash_profile" &>/dev/null
					chown root:root "$CURHOME/.bash_profile" &>/dev/null
					chmod 644 "$CURHOME/.bash_profile" &>/dev/null
				elif ! [ -f "$CURHOME/.bash_profile" ]; then
					cp /etc/skel/.bash_profile "$CURHOME/.bash_profile" &>/dev/null
					chown root:root "$CURHOME/.bash_profile" &>/dev/null
					chmod 644 "$CURHOME/.bash_profile" &>/dev/null
				fi
				if [ -f "$CURHOME/.profile" ] && [ "`stat -c %s $CURHOME/.profile`" -ne 0 ]; then
					rm -f "$CURHOME/.profile" &>/dev/null
					cp /etc/skel/.profile "$CURHOME/.profile" &>/dev/null
					chown root:root "$CURHOME/.profile" &>/dev/null
					chmod 644 "$CURHOME/.profile" &>/dev/null
				elif ! [ -f "$CURHOME/.profile" ]; then
					cp /etc/skel/.profile "$CURHOME/.profile" &>/dev/null
					chown root:root "$CURHOME/.profile" &>/dev/null
					chmod 644 "$CURHOME/.profile" &>/dev/null
				fi
			else
				echo "ERROR: $CURUSER home directory $CURHOME does not exist"
			fi
			;;
		*)
			;;
	esac
done
