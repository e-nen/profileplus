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

# fix this with improved stand alone script

zzpermcheckusage()
{
	echo 'Usage: permcheck <opts>'
	echo '	-s - Find SUID/SGID files'
	echo '	-r - Remove SUID/SGID permissions'
	echo '	-p - Find dangerous file/directory permissions'
	echo '	-h - Help'

	return 0
}

zzsuidcheck()
{
	echo "checking for suid files.."
	find / -perm -4000 -type f -print
	echo "checking for sgid files.."
	find / -perm -2000 -type f -print

	return 0
}

zzsuidremove()
{
	echo "enter a space seperated list of filenames to exclude from suid/gid permission removal. (su and passwd are automatic exceptions)"
	echo -n "exceptions: "
	read SUIDEXCEPTIONS
	if [ -z $SUIDEXCEPTIONS ]; then
		SUIDEXCEPTIONS="someridiculousvariablesotheforloopwillwork"
	fi

	echo "finding suid permissions.."
	SUIDPERMS=`find / -perm -4000 -type f -print`
	for suidfile in $SUIDPERMS; do
		for suidexcept in $SUIDEXCEPTIONS; do
			case $suidfile in
				*/$suidexcept)
					continue
					;;
				*/su)
					continue
					;;
				*/passwd)
					continue
					;;
				*)
					if [ "`uname`" == "FreeBSD" ]; then
					# this is needed because freebsd links passwd and yppasswd
						if [ "$suidfile" == "/usr/bin/yppasswd" ]; then
							continue
						fi
						if [ -n "`/bin/ls -lo $suidfile|grep chg`" ]; then
							echo "chflags noschg $suidfile"
							chflags noschg $suidfile
						fi
					fi
					echo "chmod -s $suidfile"
					chmod -s $suidfile
					;;
			esac
		done
	done
	echo "suid removal completed."

	echo "finding sgid permissions.."
	SGIDPERMS=`find / -perm -2000 -type f -print`
	for sgidfile in $SGIDPERMS; do
		for sgidexcept in $SUIDEXCEPTIONS; do
			case $sgidfile in
				*/$sgidexcept)
					continue
					;;
				*/su)
					continue
					;;
				*/passwd)
					continue
					;;
				*)
					if [ "`uname`" == "FreeBSD" ]; then
					# this is needed because freebsd links passwd and yppasswd
						if [ "$sgidfile" == "/usr/bin/yppasswd" ]; then
							continue
						fi
						if [ -n "`/bin/ls -lo $sgidfile|grep chg`" ]; then
							echo "chflags noschg $sgidfile"
							chflags noschg $sgidfile
						fi
					fi
					echo "chmod -s $sgidfile"
					chmod -s $sgidfile
					;;
			esac
		done
	done
	echo "sgid removal completed."

	return 0
}

zzpermcheck()
{
	echo "checking for global writable suid files.."
	find / -perm -4002 -type f -print
	echo "checking for global writable suid directories.."
	find / -perm -4002 -type d -print
	echo "checking for global writable sgid files.."
	find / -perm -2002 -type f -print
	echo "checking for global writable sgid directories.."
	find / -perm -2002 -type d -print
	echo "checking for global writable files.."
	find / -perm -0002 -type f -print
	echo "checking for global writable directories.."
	find / -perm -0002 -type d -print

	return 0
}

case $SHELL in
	*/bash)
		;;
	*)
		echo "ERROR: this is not bash.. permission to freak out"

		exit 1
		;;
esac

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"

	exit 1
fi

if [ "$#" == "0" ]; then
	zzpermcheckusage

	exit 2
fi

# need to add chflags check for freebsd/openbsd
GENTOOUPDATEBINDEPS='find uname ls chmod'
for dependencybin in $GENTOOUPDATEBINDEPS; do
	CHECKDEPBIN=`which $dependencybin 2>/dev/null`
	if [ "$?" != "0" ]; then
		echo "ERROR: Cannot find a required dependency: $dependencybin"

		exit 3
	fi

	if ! [ -x $CHECKDEPBIN ]; then
		echo "ERROR: Cannot execute required dependency: $CHECKDEPBIN"

		exit 4
	fi
done

args=`getopt srph $*`
if [ "$?" != "0" ]; then
	zzpermcheckusage

	exit 5
fi
set -- $args

# "i" know this seems weird.
for i; do
	case "$i" in
		-s)
			shift
			zzsuidcheck
			;;
		-r)
			shift
			zzsuidremove
			;;
		-p)
			shift
			zzpermcheck
			;;
		-h)
			shift
			zzpermcheckusage
			;;
		--)
# make this properly stop processing opts
#				break
			shift
			;;
		*)
			shift
			zzpermcheckusage
			;;
	esac
done

exit 0
