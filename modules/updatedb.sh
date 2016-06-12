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

UPDATEDBBINDEPS='rm touch chown chmod find gzip'
for dependencybin in $UPDATEDBBINDEPS; do
	CHECKDEPBIN=`which $dependencybin 2>/dev/null`
	if [ "$?" != "0" ]; then
		echo "ERROR: Cannot find a required dependency: $dependencybin"

		exit 1
	fi

	if ! [ -x $CHECKDEPBIN ]; then
		echo "ERROR: Cannot execute required dependency: $CHECKDEPBIN"

		exit 2
	fi
done

if [ "$EUID" != "0" ]; then
	echo "you need to be root.. exiting."

	exit 3
fi

if ! [ -d $PFPINSTDIR ]; then
	echo "you do not have a $PFPINSTDIR directory! exiting."

	exit 4
fi

if ! [ -d $PFPLOCATEDB ]; then
	echo "you do not have a locatedb set! exiting."

	exit 5
fi

if [ -e "${PFPINSTDIR}/${PFPLOCATEDB}" ]; then
	rm -rf "${PFPINSTDIR}/${PFPLOCATEDB}"
elif [ -e "${PFPINSTDIR}/${PFPLOCATEDB}.gz" ]; then
	rm -rf "${PFPINSTDIR}/${PFPLOCATEDB}.gz"
fi

touch "${PFPINSTDIR}/${PFPLOCATEDB}"
chown root "${PFPINSTDIR}/${PFPLOCATEDB}"
chmod 600 "${PFPINSTDIR}/${PFPLOCATEDB}"
find / 1> "${PFPINSTDIR}/${PFPLOCATEDB}"
gzip "${PFPINSTDIR}/${PFPLOCATEDB}"
