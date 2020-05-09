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
checkdependency 'getopt' 'rm' 'touch' 'chown' 'chmod' 'crontab' 'sed'

if [ -f /etc/profileplus/config ]; then
	echo "WARNING: /etc/profileplus/config is being removed"
	rm /etc/profileplus/config
fi
if [ -d /etc/profileplus/bin ]; then
	echo "WARNING: /etc/profileplus/bin is being removed"
	rm -rf /etc/profileplus/bin
fi
if [ -d /etc/profileplus/sbin ]; then
	echo "WARNING: /etc/profileplus/sbin is being removed"
	rm -rf /etc/profileplus/sbin
fi

echo "CONFIG: creating /etc/profileplus/config"
touch /etc/profileplus/config
chown root:root /etc/profileplus/config
chmod 644 /etc/profileplus/config
echo "CONFIG: creating /etc/profileplus/bin"
mkdir /etc/profileplus/bin
chown root:root /etc/profileplus/bin
chmod 755 /etc/profileplus/bin
echo "CONFIG: creating /etc/profileplus/sbin"
mkdir /etc/profileplus/sbin
chown root:root /etc/profileplus/sbin
chmod 700 /etc/profileplus/sbin

echo -e "# profileplus version 2.0\n" >/etc/profileplus/config

if [ "$1" == "-1" ]; then
	echo "declare -r PFPPATHROOT=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPPATHUSER=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPPATHLOCK=0 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPPUSCF=1 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/protectshellconfigs.sh /etc/profileplus/sbin/protectshellconfigs
	echo "declare -r PFPRLOG=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGDIR=/var/history &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGSIZE=134217728 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGLINES=100000000 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/rlogupdate.sh /etc/profileplus/sbin/rlogupdate
	/etc/profileplus/sbin/rlogupdate
	if [ -z "$(crontab -l|grep /etc/profileplus/sbin/rlogupdate)" ]; then                                                                                                               
		crontab -l|sed '/^#/ d' >/tmp/rlog-cron
		echo "0 */2 * * * /etc/profileplus/sbin/rlogupdate" >>/tmp/rlog-cron
		crontab /tmp/rlog-cron
		rm /tmp/rlog-cron
	fi
	echo "declare -r PFPSHOPT=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPOSUPDATE=1 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/os-update.sh /etc/profileplus/sbin/os-update
	echo "declare -r PFPPROMPT=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPPROMPTTERMBAR=1 &>/dev/null" >>/etc/profileplus/config
	source /etc/profile.d/profileplus-launcher.sh
	exit 0
fi

read -e -t 30 -p "Append root path with /root/bin? [Y/n]: " USEPATHROOT
if [ -z $USEPATHROOT ] || [ $USEPATHROOT == "y" ] || [ $USEPATHROOT == "Y" ]; then
	echo "declare -r PFPPATHROOT=1 &>/dev/null" >>/etc/profileplus/config
else
	echo "declare -r PFPPATHROOT=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Append user path with \$HOME/bin? [Y/n]: " USEPATHUSER
if [ -z $USEPATHUSER ] || [ $USEPATHUSER == "y" ] || [ $USEPATHUSER == "Y" ]; then
	echo "declare -r PFPPATHUSER=1 &>/dev/null" >>/etc/profileplus/config
else
	echo "declare -r PFPPATHUSER=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Lock the PATH variable? [y/N]: " USEPATHLOCK
if [ -z $USEPATHLOCK ] || [ $USEPATHLOCK == "n" ] || [ $USEPATHLOCK == "N" ]; then
	echo "declare -r PFPPATHLOCK=0 &>/dev/null" >>/etc/profileplus/config
else
	echo "declare -r PFPPATHLOCK=1 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Protect user's shell config files? [Y/n]: " USEPUSCF
if [ -z $USEPUSCF ] || [ $USEPUSCF == "y" ] || [ $USEPUSCF == "Y" ]; then
	echo "declare -r PFPPUSCF=1 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/protectshellconfigs.sh /etc/profileplus/sbin/protectshellconfigs
else
	echo "declare -r PFPPUSCF=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Use the restricted logging module? [Y/n]: " USERLOG
if [ -z $USERLOG ] || [ $USERLOG == "y" ] || [ $USERLOG == "Y" ]; then
	echo "declare -r PFPRLOG=1 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGDIR=/var/history &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGSIZE=134217728 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPRLOGLINES=100000000 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/rlogupdate.sh /etc/profileplus/sbin/rlogupdate
	/etc/profileplus/sbin/rlogupdate
	if [ -z "$(crontab -l|grep /etc/profileplus/sbin/rlogupdate)" ]; then                                                                                                               
		crontab -l|sed '/^#/ d' >/tmp/rlog-cron
		echo "0 */2 * * * /etc/profileplus/sbin/rlogupdate" >>/tmp/rlog-cron
		crontab /tmp/rlog-cron
		rm /tmp/rlog-cron
	fi
else
	echo "declare -r PFPRLOG=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Use the shopt module? [Y/n]: " USESHOPT
if [ -z $USESHOPT ] || [ $USESHOPT == "y" ] || [ $USESHOPT == "Y" ]; then
	echo "declare -r PFPSHOPT=1 &>/dev/null" >>/etc/profileplus/config
else
	echo "declare -r PFPSHOPT=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Use the os-update module? [Y/n]: " USESHOPT
if [ -z $USESHOPT ] || [ $USESHOPT == "y" ] || [ $USESHOPT == "Y" ]; then
	echo "declare -r PFPOSUPDATE=1 &>/dev/null" >>/etc/profileplus/config
	ln -s /etc/profileplus/modules/os-update.sh /etc/profileplus/sbin/os-update
else
	echo "declare -r PFPOSUPDATE=0 &>/dev/null" >>/etc/profileplus/config
fi

read -e -t 30 -p "Use the prompt module? [Y/n]: " USEPROMPT
if [ -z $USEPROMPT ] || [ $USEPROMPT == "y" ] || [ $USEPROMPT == "Y" ]; then
	showprompts
	read -e -t 30 -p "Default user prompt (1-29) [1]: " USEPROMPT
	if [ -z $USEPROMPT ]; then
		echo "declare -r PFPPROMPT=1 &>/dev/null" >>/etc/profileplus/config
	else
		case $USEPROMPT in
			1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29)
				echo "declare -r PFPPROMPT=$USEPROMPT &>/dev/null" >>/etc/profileplus/config
				;;
			*)
				echo "declare -r PFPPROMPT=1 &>/dev/null" >>/etc/profileplus/config
				;;
		esac
	fi
	read -e -t 30 -p "Use termbar module? [Y/n]: " USETERMBAR
	if [ -z $USETERMBAR ] || [ $USETERMBAR == "y" ] || [ $USETERMBAR == "Y" ]; then
		echo "declare -r PFPPROMPTTERMBAR=1 &>/dev/null" >>/etc/profileplus/config
	else
		echo "declare -r PFPPROMPTTERMBAR=0 &>/dev/null" >>/etc/profileplus/config
	fi
else
	echo "declare -r PFPPROMPT=0 &>/dev/null" >>/etc/profileplus/config
	echo "declare -r PFPPROMPTTERMBAR=0 &>/dev/null" >>/etc/profileplus/config
fi

. /etc/profile.d/profileplus-launcher.sh