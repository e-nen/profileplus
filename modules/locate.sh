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

LOCATEBINDEPS='which zcat grep'
for dependencybin in $LOCATEBINDEPS; do
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
	echo "you must be root.. exiting."

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

if ! [ -d $PFPINSTDIR ] && [ -e $PFPINSTDIR/$PFPLOCATEDB.gz ]; then
	echo "$PFPINSTDIR/$PFPLOCATEDB.gz does not exist! exiting."

	exit 6
fi

if [ "$#" == "0" ]; then
	echo "locate: missing search criteria!"

	exit 7
elif [ "$#" -gt "1" ]; then
	echo "locate: too many arguments!"

	exit 8
fi

zcat $PFPINSTDIR/$PFPLOCATEDB.gz|grep -i $1
