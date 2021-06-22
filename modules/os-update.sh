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

if [ -f /etc/profileplus/modules/utilities.sh ]; then
        source /etc/profileplus/modules/utilities.sh
else
        echo "ERROR: /etc/profileplus/modules/utilities.sh not found or readable"
        exit 1
fi

checkeuidroot
checkdependency 'grep' 'awk'

OSVAR=0
if [ -f /etc/os-release ]; then
    if [ $(grep ID_LIKE /etc/os-release|awk -F= '{print $2}') == "debian" ]; then
        OSVAR=1
    fi
elif [ -f /etc/redhat-release ]; then
    OSVAR=2
elif [ -f /etc/centos-release ]; then
    OSVAR=2
elif [ -f /etc/alpine-release ]; then
    OSVAR=3
elif [ -f /etc/gentoo-release ]; then
    OSVAR=4
else
    errordie 'unsupported OS'
fi

# each of these needs error checking at every step
case $OSVAR in
    1)
        checkdependency 'apt' 'tail' 'updatedb' 'checkrestart'
        date
        apt-get -y -q update
        apt-get -y -q -o Dpkg::Progress=0 -o Dpkg::Progress-Fancy=0 dist-upgrade --fix-missing
        apt-get -y -q clean
        apt-get -y -q autoremove
        apt-get -y -q autoclean
        apt-get -y -q purge $(dpkg -l | tail -n +6 | grep -v '^ii' | awk '{print $2}')
	echo "$(date) updatedb start"
        updatedb
	echo "$(date) updatedb finished"
        checkrestart
        if [ -f /var/run/reboot-required ]; then
                echo;cat /var/run/reboot-required;echo
        fi
		;;
    2)
# figure out which version of redhat and run one of the following
        checkdependency 'yum'
        yum update
#        checkdependency 'dnf'
#        dnf update
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
