#!/bin/bash
#
#    Copyright (C) 2023 nickelplated.net
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

if [ -f /etc/profileplus/modules/utilities.sh ]; then
        source /etc/profileplus/modules/utilities.sh
else
        echo "ERROR: /etc/profileplus/modules/utilities.sh not found or readable"
        exit 1
fi

checkeuidroot
checkdependency 'mkdir' 'chown' 'chmod' 'wc' 'cat' 'sed' 'awk' 'touch'

PFPRLOGDIR=$(grep PFPRLOGDIR /etc/profileplus/config|awk -F'=' '{ print $2 }'|awk -F\& '{ print $1 }'|xargs)

if [ -z "$PFPRLOGDIR" ]; then
	errordie 'rlog directory variable not set'
fi

if ! [ -d "$PFPRLOGDIR" ]; then
	mkdir -p "$PFPRLOGDIR"
fi

chown root:root "$PFPRLOGDIR"
chmod 773 "$PFPRLOGDIR"

PASSWDLEN=`wc -l /etc/passwd|awk '{ print $1 }'`
FORLIM=$(($PASSWDLEN+1))

for (( i=1; i<FORLIM; i++ ))
do
	dstring=$i"p"
	CURUSER=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $1 }'`
	CURUID=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $3 }'`
	CURGID=`cat /etc/passwd|sed -n $dstring|awk 'BEGIN { FS=":" } { RS="" } { print $4 }'`
	touch "$PFPRLOGDIR/$CURUSER"
	chown "$CURUID:$CURGID" "$PFPRLOGDIR/$CURUSER"
	chmod 0600 "$PFPRLOGDIR/$CURUSER"
done
