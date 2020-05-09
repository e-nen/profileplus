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
#    GNU/GPL v2 license can be found here: http://www.gnu.org/old-licenses/lgpl-2.0.txt
#
# profileplus version 2.0

# needs some extra sanity checks
if [ -f $PWD/modules/utilities.sh ]; then
        source $PWD/modules/utilities.sh
else
        echo "ERROR: $PWD/modules/utilities.sh not found or readable"
        exit 1
fi

checkeuidroot
checkdependency 'mkdir' 'cp' 'chown' 'chmod'

if [ -d /etc/profileplus ]; then
	while true
	do
		echo -n "WARNING: /etc/profileplus already exists, would you like to uninstall and proceed? [Y/n] "
		read TRASHVAR

		if [ -z "$TRASHVAR" ] || [ "$TRASHVAR" == "y" ] || [ "$TRASHVAR" == "Y" ]; then
			/etc/profileplus/uninstall.sh
			case $? in
				0)
					break
					;;
				*)
					echo "ERROR: /etc/profileplus/uninstall.sh was not successful.."

					exit 4
					;;
			esac
		elif [ "$TRASHVAR"  == "n" ] || [ "$TRASHVAR" == "N" ]; then
			echo "ERROR: exiting installer.."

			exit 5
		fi
	done
fi

echo "INSTALL: creating /etc/profileplus"
mkdir /etc/profileplus
cp -r configure.sh launcher.sh uninstall.sh LICENSE modules /etc/profileplus/
chown -R root:root /etc/profileplus

if [ -d /etc/profile.d ]; then
	ln -s /etc/profileplus/launcher.sh /etc/profile.d/profileplus-launcher.sh
else
	echo "source /etc/profileplus/launcher.sh" >>/etc/profile
fi

echo "INSTALL: completed successfully"

/etc/profileplus/configure.sh -1
. /etc/profileplus/launcher.sh