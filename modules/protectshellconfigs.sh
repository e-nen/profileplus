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

if [ -e "/etc/skel/.bashrc" ]; then
	mv /etc/skel/.bashrc /etc/bashrc.skel.original
fi
touch /etc/skel/.bashrc
echo 'source /etc/profile' >>/etc/skel/.bashrc
chown root:root /etc/skel/.bashrc
chmod 644 /etc/skel/.bashrc

if [ -e "/etc/skel/.bash_profile" ]; then
	mv /etc/skel/.bash_profile /etc/bash_profile.skel.original
fi
touch /etc/skel/.bash_profile
chown root:root /etc/skel/.bash_profile
chmod 644 /etc/skel/.bash_profile

if [ -e "/etc/skel/.bashrc" ]; then
	mv /etc/skel/.profile /etc/profile.skel.original
fi
touch /etc/skel/.profile
chown root:root /etc/skel/.profile
chmod 644 /etc/skel/.profile

PASSWDLEN=`wc -l /etc/passwd|awk '{ print $1 }'`
FORLIM=$(($PASSWDLEN+1))

for (( i=1; i<FORLIM; i++ ))
do
	dstring=$i"p"
	CURUSER=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $1 }'`
	CURGROUP=`id -gn $CURUSER`
	CURHOME=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $6 }'`
	CURSHELL=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $7 }'`

	# Operator accounts cause problems
	if [ "$CURUSER" != "root" ] && [ "$CURHOME" == "/root" ]; then
		continue
	fi

	case $CURSHELL in
		/bin/sh|*/bash|*/rbash)
			if [ -d "$CURHOME" ]; then
				if [ -e "$CURHOME/.bashrc" ]; then
					rm "$CURHOME/.bashrc"
					cp /etc/skel/.bashrc "$CURHOME/.bashrc"
				fi
				chown root:root "$CURHOME/.bashrc"
				chmod 644 "$CURHOME/.bashrc"

				if [ -e "$CURHOME/.bash_profile" ]; then
					rm "$CURHOME/.bash_profile"
					cp /etc/skel/.bash_profile "$CURHOME/.bash_profile"
				fi
				chown root:root "$CURHOME/.bash_profile"
				chmod 644 "$CURHOME/.bash_profile"

				if [ -e "$CURHOME/.profile" ]; then
					rm "$CURHOME/.profile"
					cp /etc/skel/.profile "$CURHOME/.profile"
				fi
				chown root:root "$CURHOME/.profile"
				chmod 644 "$CURHOME/.profile"
			else
				echo "ERROR: $CURUSER home directory $CURHOME does not exist"|logger
			fi
			;;
		*)
			;;
	esac
done
