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

# implement RBAC stuff from stand alone script

zzgrsecusage()
{
	echo 'Usage: grsec <option>'
	echo '       -c - enforce chroot restrictions'
	echo '       -C - relax chroot restrictions'
	echo '       -t - enable trusted path execution'
	echo '       -T - disable trusted path execution'
	echo '       -S - status'
	echo '       -h - Help'

	return 0
}

zzgrsecrelaxchrootrestrictions()
{
	CHROOTVARS=`ls -1 /proc/sys/kernel/grsecurity/chroot_*`

	for sysctlvar in $CHROOTVARS
	do
		echo 0 >$sysctlvar
	done

	return 0
}

zzgrsecenforcechrootrestrictions()
{
	CHROOTVARS=`ls -1 /proc/sys/kernel/grsecurity/chroot_*`

	for sysctlvar in $CHROOTVARS
	do
		echo 1 >$sysctlvar
	done

	return 0
}

zzgrsecenabletpe()
{
	echo 1 >/proc/sys/kernel/grsecurity/tpe

	return 0
}

zzgrsecdisabletpe()
{
	echo 0 >/proc/sys/kernel/grsecurity/tpe

	return 0
}

zzgrsecstatus()
{
	CHROOTPROCS=`find /proc/sys/kernel/grsecurity -iname 'chroot_*' 2>/dev/null`

	if [ -n "$CHROOTPROCS" ]; then
		for fixproc in $CHROOTPROCS; do
			echo -n "$fixproc "

			if [ "`cat $fixproc`" == "1" ]; then
				echo "enabled"
			else
				echo "disabled"
			fi
		done
	fi

	if [ -f /proc/sys/kernel/grsecurity/tpe ]; then
		if [ "`cat /proc/sys/kernel/grsecurity/tpe`" == "1" ]; then
			echo "/proc/sys/kernel/grsecurity/tpe enabled"
		else
			echo "/proc/sys/kernel/grsecurity/tpe disabled"
		fi
	fi

	return 0
}

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"

	exit 1
fi

if [ "$#" == "0" ]; then
	zzgrsecusage

	exit 1
fi

args=`getopt hcCtTS $*`
if [ "$?" != "0" ]; then
	zzgrsecusage

	exit 1
fi
set -- $args

NUMOPTS=0
GRSECFUNC=0

for i; do
	if [ "$NUMOPTS" -gt "1" ]; then
		echo "ERROR: only specify one flag at a time"

		exit 1
	fi

	case "$i" in
		-h)
			shift
			zzgrsecusage

			exit 1
			;;
		-c)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			GRSECFUNC=1
			;;
		-C)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			GRSECFUNC=2
			;;
		-t)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			GRSECFUNC=3
			;;
		-T)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			GRSECFUNC=4
			;;
		-S)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			GRSECFUNC=5
			;;
		--)
			shift
			;;
		*)
			shift
			zzgrsecusage

			exit 1
			;;
	esac
done

case $GRSECFUNC in
	1)
		zzgrsecenforcechrootrestrictions
		;;
	2)
		zzgrsecrelaxchrootrestrictions
		;;
	3)
		zzgrsecenabletpe
		;;
	4)
		zzgrsecdisabletpe
		;;
	5)
		zzgrsecstatus
		;;
	*)
		echo "ERROR: you broke it"

		exit 1
		;;
esac

exit 0
