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

# add crontab formatted show updates/news

zzgentooupdateusage()
{
	echo 'Usage: gentooupdate <opts>'
	echo '	-a - Update all (same as -slftupec)'
	echo '	-s - Portage rsync'
	echo '	-w - Portage web rsync'
	echo '	-l - Show build env, updates and news'
	echo '	-L - Show available updates (crontab friendly)'
	echo '	-f - Fetch available updates'
	echo '	-u - Update, purge news, etc-update, depclean and revdep-rebuild'
	echo '	-p - Python update'
	echo '	-e - Perl cleaner'
	echo '	-t - Sanitize distfiles permissions'
	echo '	-c - Clean distfiles'
	echo '	-d - Depclean'
	echo '	-r - Revdep-rebuild'
	echo '	-R - Rebuild world'
	echo '	-U - Update only'
	echo '	-n - News read'
	echo '	-N - News purge'
	echo '	-h - Help'

	return 0
}

zzgentooupdateall()
{
	zzgentooupdatesync
	zzgentooupdateshow
	echo
	echo ">>>"
	echo ">>> Now is the time to edit your per package"
	echo ">>> use flags in /etc/portage/package.use"
	echo ">>> and resolve any compile issues."
	echo ">>>"
	echo ">>> Press enter to continue and update.."
	echo ">>>"
	local GARBAGEVAR=""
	read GARBAGEVAR
	zzgentooupdatefetch
	zzgentooupdatesanitize
	zzgentooupdateupdt
	zzgentooupdatepyth
	zzgentooupdateprlc
	zzgentooupdateclean

	return 0
}

zzgentooupdatesync()
{
	echo -n ">>> Syncing portage "
	date
	emerge --quiet --sync

	if [ -n "`grep layman /etc/portage/make.conf`" ]; then
			echo -n ">>> Syncing layman "
			date
			layman -S -Q 2
	fi

	return 0
}

zzgentooupdatewebsync()
{
	echo -n ">>> Web syncing "
	date
	emerge-webrsync --quiet

	if [ -n "`grep layman /etc/portage/make.conf`" ]; then
			echo -n ">>> Syncing layman "
			date
			layman -S -Q 2
	fi

	return 0
}

zzgentooupdatefetch()
{
	echo -n ">>> Fetching available updates "
	date
	emerge -uDNqf --with-bdeps=y @world

	return 0
}

zzgentooupdatesanitize()
{
	case `find /usr/portage/distfiles -type f -print -quit` in
		'')
			echo '>>> Nothing to sanitize in /usr/portage/distfiles'

			return 1
			;;
		*)
			echo ">>> Sanitizing /usr/portage/distfiles"
			chown -R portage:portage /usr/portage/distfiles/*
			chmod -R 664 /usr/portage/distfiles/*
			;;
	esac

	return 0
}

zzgentooupdateclean()
{
	case `find /usr/portage/distfiles -type f -print -quit` in
		'')
			echo '>>> Nothing to clean /usr/portage/distfiles'

			return 1
			;;
		*)
			echo ">>> Cleaning /usr/portage/distfiles"
			rm -rf /usr/portage/distfiles/*
			;;
	esac

	return 0
}

zzgentoonewsread()
{
	echo
	echo ">>> Checking eselect news"
	echo
	eselect news read all

	return 0
}

zzgentoonewspurge()
{
	echo
	echo ">>> Purging eselect news"
	echo
	eselect news purge all

	return 0
}

zzgentooupdateshow()
{
	echo ">>> Checking world updates"
	emerge -uDNvp --with-bdeps=y @world

	zzgentoonewsread

	echo
	echo -n "Profile: "
	eselect profile show|grep --color=never linux|xargs

	echo -n "Compiler: "
	gcc-config -c

	if [ -f /etc/portage/make.conf ]; then
		source /etc/portage/make.conf
	else
		echo "ERROR: /etc/portage/make.conf does not exist"

		return 1
	fi

	if [ -n "$CFLAGS" ]; then
			echo "CFLAGS: $CFLAGS"
	else
		echo "ERROR: Missing environment variable CFLAGS"

		return 1
	fi

	if [ -n "$CXXFLAGS" ]; then
		echo "CXXFLAGS: $CXXFLAGS"
	else
		echo "ERROR: Missing environment variable CXXFLAGS"

		return 1
	fi

	if [ -n "$CHOST" ]; then
		echo "CHOST: $CHOST"
	else
		echo "ERROR: Missing environment variables CHOST"

		return 1
	fi

	if [ -n "$CPU_FLAGS_X86" ]; then
		echo "CPU_FLAGS_X86: $CPU_FLAGS_X86"
	else
		echo "ERROR: Missing environment variables CPU_FLAGS_X86"

		return 1
	fi

	if [ -n "$USE" ]; then
		echo "USE: $USE"
	else
		echo "WARNING: Missing environment variable USE"

		return 1
	fi

	if [ -n "$MAKEOPTS" ]; then
		echo "MAKEOPTS: $MAKEOPTS"
	fi

	if [ -n "$VIDEO_CARDS" ]; then
		echo "VIDEO_CARDS: $VIDEO_CARDS"
	fi

	if [ -n "$INPUT_DEVICES" ]; then
		echo "INPUT_DEVICES: $INPUT_DEVICES"
	fi

	if [ -n "$LINGUAS" ]; then
		echo "LINGUAS: $LINGUAS"
	fi

	if [ -n "$ACCEPT_LICENSE" ]; then
		echo "ACCEPT_LICENSE: $ACCEPT_LICENSE"
	fi

	if [ -n "$GENTOO_MIRRORS" ]; then
		echo "GENTOO_MIRRORS: $GENTOO_MIRRORS"
	fi

	if [ -n "$SYNC" ]; then
		echo "SYNC: $SYNC"
	fi

	if [ -n "`grep layman /etc/portage/make.conf`" ]; then
		echo "Overlays enabled:"
		layman -l
	fi

	return 0
}

zzgentooupdateshowsimple()
{
	zzgentooupdatepackagecount=0
	for curpackage in `emerge -uDNvp --with-bdeps=y @world 2>/dev/null | grep --color=never '\[ebuild' | awk -F "]" '{ print $2 }' | awk -F "[" '{print $1 }' | xargs`
	do
		echo "$curpackage"
		zzgentooupdatepackagecount=$((zzgentooupdatepackagecount+1))
	done

	if [ $zzgentooupdatepackagecount -gt 0 ]; then
		echo
		echo "Total Packages: $zzgentooupdatepackagecount"
	fi

	return 0
}

zzgentoorevdeprebuild()
{
	echo ">>> Repairing broken dependencies"
	revdep-rebuild -- -vq

	return 0
}

zzgentoodepclean()
{
	echo ">>> Removing stale dependencies"
	emerge -cDNqa --with-bdeps=y

	return 0
}

zzgentooupdateupdtonly()
{
	echo -n ">>> Updating world "
	date
	emerge -uDNvq --with-bdeps=y @world

	return 0
}

zzgentooupdateupdt()
{
	zzgentoonewspurge
	zzgentooupdateupdtonly

	echo
	echo ">>>"
	echo ">>> Updating has completed. Please review any"
	echo ">>> package messages or portage news for vital"
	echo ">>> info about additional steps or precautions"
	echo ">>> that this update may require."
	echo ">>>"
	echo ">>> Press enter to continue and finish.."
	echo ">>>"
	local GARBAGEVAR=""
	read GARBAGEVAR

	echo ">>> Updating configuration files"
	etc-update

	zzgentoodepclean
	zzgentoorevdeprebuild

	return 0
}

zzgentooupdaterebuild()
{
	echo ">>> WARNING: Rebuilding world is not trivial, use sparingly."
	echo ">>>"
	echo ">>> This functionanlity is usually reserved for"
	echo ">>>		System profile changes"
	echo ">>>		System CHOST/CFLAGS/CXXFLAGS changes"
	echo ">>>		System USE flag changes"
	echo ">>>		Rebuilding for consistency/optimizations (new compilers, etc.)"
	echo ">>>"
	echo ">>> Press enter to continue and finish.."
	echo ">>>"
	local GARBAGEVAR=""
	read GARBAGEVAR
	echo -n ">>> Rebuilding world "
	date
	emerge -evq @world

	echo ">>> WARNING: It is highly recommended that you reboot now."

	return 0
}

zzgentooupdatepyth()
{
	echo ">>> Python updater"
	python-updater -- -vq

	return 0
}

zzgentooupdateprlc()
{
	local zzgentooupdatets=`date +%m%d%Y%H%M%S`
	local zzgentooperlclrtmp="/tmp/perl-cleaner-$zzgentooupdatets.log"

	echo ">>> Perl cleaner logging to $zzgentooperlclrtmp"
	perl-cleaner --all &>$zzgentooperlclrtmp

	return 0
}

if [ "$EUID" != "0" ]; then
	echo "ERROR: root user privileges required"

	exit 1
fi

if [ "$#" == "0" ]; then
	zzgentooupdateusage

	exit 2
fi

if [ -L /etc/make.conf ]; then
	echo "WARNING: removing /etc/make.conf symbolic link"
	rm /etc/make.conf
fi

if [ -f /etc/make.conf ] && [ -f /etc/portage/make.conf]; then
	zzgentooupdatects=`date +%m%d%Y%H%M`
	zzgentoomkcfclrtmp="/etc/portage/make.conf.bak-$zzgentooupdatects"
	echo "WARNING: /etc/make.conf and /etc/portage/make.conf.. moving /etc/make.conf to $zzgentoomkcfclrtmp"
	mv /etc/make.conf $zzgentoomkcfclrtmp
fi

if [ -f /etc/make.conf ] && ! [ -f /etc/portage/make.conf ]; then
	echo "WARNING: moving /etc/make.conf to /etc/portage/make.conf"
	mv /etc/make.conf /etc/portage/make.conf
fi

GENTOOUPDATEBINDEPS='getopt date chown chmod rm xargs find emerge emerge-webrsync eselect gcc-config etc-update revdep-rebuild python-updater perl-cleaner'
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

args=`getopt aswlLfupetcrdUnNRh $*`
if [ "$?" != "0" ]; then
	zzgentooupdateusage

	exit 5
fi
set -- $args

# "i" know this seems weird.
for i; do
	case "$i" in
		-a)
			shift
			zzgentooupdateall
			;;
		-s)
			shift
			zzgentooupdatesync
			;;
		-w)
			shift
			zzgentooupdatewebsync
			;;
		-l)
			shift
			zzgentooupdateshow
			;;
		-L)
			shift
			zzgentooupdateshowsimple
			;;
		-f)
			shift
			zzgentooupdatefetch
			;;
		-u)
			shift
			zzgentooupdateupdt
			;;
		-p)
			shift
			zzgentooupdatepyth
			;;
		-e)
			shift
			zzgentooupdateprlc
			;;
		-t)
			shift
			zzgentooupdatesanitize
			;;
		-c)
			shift
			zzgentooupdateclean
			;;
		-r)
			shift
			zzgentoorevdeprebuild
			;;
		-d)
			shift
			zzgentoodepclean
			;;
		-U)
			shift
			zzgentooupdateupdtonly
			;;
		-n)
			shift
			zzgentoonewsread
			;;
		-N)
			shift
			zzgentoonewspurge
			;;
		-R)
			shift
			zzgentooupdaterebuild
			;;
		-h)
			shift
			zzgentooupdateusage
			;;
		--)
# make this properly stop processing opts
#				break
			shift
			;;
		*)
			shift
			zzgentooupdateusage
			;;
	esac
done

exit 0
