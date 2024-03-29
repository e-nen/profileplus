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

if [ -f /etc/profileplus/modules/utilities.sh ]; then
        source /etc/profileplus/modules/utilities.sh
else
        echo "ERROR: /etc/profileplus/modules/utilities.sh not found or readable"
        exit 1
fi

checkeuidroot
checkdependency 'grep' 'awk'

OSVAR=0
if [ -e /etc/os-release ]; then
    if [ "$(grep ID_LIKE /etc/os-release|awk -F= '{print $2}')" == "debian" ]; then
        OSVAR=1
    fi
fi
if [ -e /etc/redhat-release ]; then
    OSVAR=2
fi
if [ -e /etc/centos-release ]; then
    OSVAR=2
fi
if [ -e /etc/alpine-release ]; then
    OSVAR=3
fi
if [ -e /etc/gentoo-release ]; then
    OSVAR=4
fi
if [ $OSVAR == 0 ]; then
    errordie 'unsupported OS'
fi

case $OSVAR in
    1)
        checkdependency 'apt' 'aptitude' 'dpkg' 'tail' 'updatedb' 'checkrestart'
        date
        aptitude update
        aptitude -y full-upgrade
        apt-get -y -q clean
        apt-get -y -q autoremove
        apt-get -y -q autoclean
        apt-get -y -q purge $(dpkg -l | tail -n +6 | grep -v '^ii' | awk '{print $2}')
        if [ -x "`which snap`" ]; then
            snap refresh
        fi
        echo "$(date) updatedb started"
        updatedb
        echo "$(date) updatedb finished"
        checkrestart
        if [ -f /var/run/reboot-required ]; then
            echo;cat /var/run/reboot-required;echo
        fi
    	;;
    2)
        checkdependency 'dnf' 'updatedb'
        date
        dnf upgrade -y
        if [ -x "`which flatpak`" ]; then
            flatpak upgrade -y
        fi
        echo "$(date) updatedb started"
        updatedb
        echo "$(date) updatedb finished"
        dnf needs-restarting -r
        ;;
    3)
        checkdependency 'apk'
        apk update
        apk upgrade -i -a
        ;;
    4)
# squish all of the old gentooupdate.sh functions into this case statement...
        checkdependency 'getopt' 'date' 'chown' 'chmod' 'rm' 'xargs' 'find' 'emerge' 'emerge-webrsync' 'eselect' 'gcc-config' 'etc-update' 'revdep-rebuild' 'perl-cleaner'
        errordie 'i didnt port the gentooupdate.sh code yet'
        ;;
    *)
        errordie 'no bueno..'
	;;
esac
