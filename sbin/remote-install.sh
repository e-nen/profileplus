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
#    GNU/GPL v2 license can be found here: http://www.gnu.org/old-licenses/lgpl-2.0.txt
#
# profileplus version 1.0

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

		exit 2
	fi
done

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"

	exit 3
fi

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

# make local install possible later
PFPMOI="global"
# make this configurable later
PFPINSTDIR="/etc/profileplus"

echo "INSTALL: creating $PFPINSTDIR"
cd /etc
git clone https://github.com/e-nen/profileplus
# test that the $PFPINSTDIR is there
# test that the files are also there...

#mkdir $PFPINSTDIR/bin
#mkdir $PFPINSTDIR/sbin
#chown -R root:root $PFPINSTDIR
#chmod 700 $PFPINSTDIR/sbin
#chmod 755 $PFPINSTDIR/bin
#chmod 755 $PFPINSTDIR/configure.sh
#chmod 755 $PFPINSTDIR/launcher.sh
#chmod 755 $PFPINSTDIR/uninstall.sh
#chmod 755 $PFPINSTDIR/modules/*.sh
#chmod 755 $PFPINSTDIR/modules

if [ -d /etc/profile.d ]; then
	ln -s $PFPINSTDIR/launcher.sh /etc/profile.d/profileplus-launcher.sh
else
	echo "source $PFPINSTDIR/launcher.sh" >>/etc/profile
fi

echo "INSTALL: completed successfully"
echo
echo "You now need to run as root: /etc/profileplus/configure.sh"
echo

exit 0
