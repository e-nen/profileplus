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
#    GNU/GPL v2 license can be found here: http://www.gnu.org/old-licenses/lgpl-2.0.txt
#
# profileplus version 2.0

# this needs further sanity checks
# require git so updating is simple?

PFPINSTALLBINDEPS='mkdir cp chown chmod git'
for dependencybin in $PFPINSTALLBINDEPS; do
	CHECKDEPBIN=`which $dependencybin 2>/dev/null`
	if [ "$?" != "0" ]; then
		echo "ERROR: Cannot find a required dependency: $dependencybin"
		exit 1
	fi

	if ! [ -x "$CHECKDEPBIN" ]; then
		echo "ERROR: Cannot execute required dependency: $CHECKDEPBIN"
		exit 1
	fi
done

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"
	exit 1
fi

if [ -d /etc/profileplus ]; then
	read -e -t 3 -n 1 -p "WARNING: /etc/profileplus already exists, would you like to uninstall and proceed? [Y/n] " TRASHVAR
	if [ -z "$TRASHVAR" ] || [ "$TRASHVAR" == "y" ] || [ "$TRASHVAR" == "Y" ]; then
		/etc/profileplus/uninstall.sh
		case $? in
			0)
				break
				;;
			*)
				echo "ERROR: /etc/profileplus/uninstall.sh was not successful.."
				exit 1
				;;
		esac
	else
		echo "ERROR: exiting installer.."
		exit 1
	fi
fi

echo "INSTALL: creating /etc/profileplus"
cd /etc
git clone https://github.com/e-nen/profileplus
if [ -d /etc/profileplus ]; then
	chown -R root:root /etc/profileplus
	chmod 755 /etc/profileplus
	chmod 755 /etc/profileplus/configure.sh
	chmod 755 /etc/profileplus/launcher.sh
	chmod 755 /etc/profileplus/uninstall.sh
	chmod 755 /etc/profileplus/modules/*.sh
	chmod 755 /etc/profileplus/modules
else
	echo "ERROR: install failed... check /etc/profileplus"
fi

if [ -d /etc/profile.d ]; then
	ln -s /etc/profileplus/launcher.sh /etc/profile.d/profileplus-launcher.sh
else
	echo "source /etc/profileplus/launcher.sh" >>/etc/profile
fi

echo "INSTALL: completed successfully"

/etc/profileplus/configure.sh -1
. /etc/profileplus/launcher.sh
/etc/profileplus/sbin/protectshellconfigs
