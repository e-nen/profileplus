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

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"
	exit 1
fi

if [ -d /etc/profileplus ]; then
	echo ">>> deleting /etc/profileplus"
	rm -rf /etc/profileplus
else
	echo "ERROR: the /etc/profileplus directory does not exist"
	exit 1
fi

if [ -d /var/history ]; then
	echo "WARNING: the /var/history directory will not be deleted (you will have to remove it manually)"
fi

if [ -L /etc/profile.d/profileplus-launcher.sh ]; then
	rm /etc/profile.d/profileplus-launcher.sh
fi

if [ -n "`grep 'source /etc/profileplus/launcher.sh' /etc/profile`" ]; then
	echo ">>> removing launcher.sh from /etc/profile"
	sed -i '/source \/etc\/profileplus\/launcher.sh/d' /etc/profile
fi

# replace skel configs with the originals

crontab -l|grep -v '/etc/profileplus/sbin/protectshellconfigs' >/tmp/pfuninstall-cron
crontab /tmp/pfuninstall-cron
rm /tmp/pfuninstall-cron
crontab -l|grep -v '/etc/profileplus/sbin/rlogupdate' >/tmp/ppuninstall-cron
crontab /tmp/ppuninstall-cron
rm /tmp/ppuninstall-cron

echo ">>> Uninstall successful"
