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

PFPCONFIGBINDEPS='getopt rm touch chown chmod crontab sed'
for dependencybin in $PFPCONFIGBINDEPS; do
	CHECKDEPBIN=`which $dependencybin 2>/dev/null`
	if [ $? != "0" ]; then
		echo "ERROR: Cannot find a required dependency: $dependencybin"

		exit 1
	fi

	if ! [ -x $CHECKDEPBIN ]; then
		echo "ERROR: Cannot execute required dependency: $CHECKDEPBIN"

		exit 2
	fi
done

if [ $EUID != "0" ]; then
	echo "ERROR: root user privileges required"

	exit 2
fi

PFPMOI="global"
PFPINSTDIR="/etc/profileplus"
PFPCONFIG=""

if [ -f /etc/profileplus/config ]; then
	echo "WARNING: /etc/profileplus/config is being removed"
	rm /etc/profileplus/config
fi
PFPMOI="global"
PFPINSTDIR="/etc/profileplus"
PFPCONFIG=$PFPINSTDIR/config
echo "CONFIG: creating $PFPCONFIG"
touch $PFPCONFIG
chown root:root $PFPCONFIG
chmod 644 $PFPCONFIG

echo "# profileplus version 1.0" >$PFPCONFIG
echo >>$PFPCONFIG
echo "declare -r PFPMOI=$PFPMOI &>/dev/null" >>$PFPCONFIG
echo "declare -r PFPINSTDIR=$PFPINSTDIR &>/dev/null" >>$PFPCONFIG
echo >>$PFPCONFIG

# Path root
while true
do
	echo -n "Append root path with /root/bin? [Y/n]: "
	read USEPATHROOT

	if [ -z $USEPATHROOT ] || [ $USEPATHROOT == "y" ] || [ $USEPATHROOT == "Y" ]; then
		echo "declare -r PFPPATHROOT=1 &>/dev/null" >>$PFPCONFIG
		break
	elif [ $USEPATHROOT == "n" ] || [ $USEPATHROOT == "N" ]; then
		echo "declare -r PFPPATHROOT=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Path user
while true
do
	echo
	echo "WARNING: Do not use this on systems with trusted path execution."
	echo
	echo "This option will essentially render trusted path execution useless."
	echo "Users can create and execute things from their home directory."
	echo 
	echo -n "Append user path with \$HOME/bin? [Y/n]: "
	read USEPATHUSER

	if [ -z $USEPATHUSER ] || [ $USEPATHUSER == "y" ] || [ $USEPATHUSER == "Y" ]; then
		echo "declare -r PFPPATHUSER=1 &>/dev/null" >>$PFPCONFIG
		break
	elif [ $USEPATHUSER == "n" ] || [ $USEPATHUSER == "N" ]; then
		echo "declare -r PFPPATHUSER=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Path lock
while true
do
	echo -n "Lock the PATH variable? [y/N]: "
	read USEPATHLOCK

	if [ -z $USEPATHLOCK ] || [ $USEPATHLOCK == "n" ] || [ $USEPATHLOCK == "N" ]; then
		echo "declare -r PFPPATHLOCK=0 &>/dev/null" >>$PFPCONFIG
		break
	elif [ $USEPATHLOCK == "y" ] || [ $USEPATHLOCK == "Y" ]; then
		echo "declare -r PFPPATHLOCK=1 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Protect user's shell config files
while true
do
	echo -n "Protect user's shell config files? [Y/n]: "
	read USEPUSCF

	if [ -z $USEPUSCF ] || [ $USEPUSCF == "y" ] || [ $USEPUSCF == "Y" ]; then
		echo "declare -r PFPPUSCF=1 &>/dev/null" >>$PFPCONFIG
		ln -s $PFPINSTDIR/modules/protectshellconfigs.sh $PFPINSTDIR/sbin/protectshellconfigs
		break
	elif [ $USEPUSCF == "n" ] || [ $USEPUSCF == "N" ]; then
		echo "declare -r PFPPUSCF=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Solaris...
if [ "`uname`" == "SunOS" ]; then
# DISABLED solarisalias.sh
	echo "declare -r PFPSOLARISALIAS=0 &>/dev/null" >>$PFPCONFIG
# DISABLED solarisiostat.sh
	echo "declare -r PFPSOLARISIOSTAT=0 &>/dev/null" >>$PFPCONFIG

#	while true
#	do
#		echo -n "Use iostat to alert you of diagnostic problems at login? [Y/n]: "
#		read USEIOSTAT
#
#		if [ -z $USEIOSTAT ] || [ $USEIOSTAT == "y" ] || [ $USEIOSTAT == "Y" ]; then
#			echo "declare -r PFPSOLARISIOSTAT=1 &>/dev/null" >>$PFPCONFIG
#			break
#		elif [ $USEIOSTAT == "n" ] || [ $USEIOSTAT == "N" ]; then
#			echo "declare -r PFPSOLARISIOSTAT=0 &>/dev/null" >>$PFPCONFIG
#			break
#		else
#			continue
#		fi
#	done

	while true
	do
		echo -n "Use prtdiag to alert you of diagnostic problems at login? [Y/n]: "
		read USEPRTDIAG

		if [ -z $USEPRTDIAG ] || [ $USEPRTDIAG == "y" ] || [ $USEPRTDIAG == "Y" ]; then
			echo "declare -r PFPSOLARISPRTDIAG=1 &>/dev/null" >>$PFPCONFIG
			break
		elif [ $USEPRTDIAG == "n" ] || [ $USEPRTDIAG == "N" ]; then
			echo "declare -r PFPSOLARISPRTDIAG=0 &>/dev/null" >>$PFPCONFIG
			break
		else
			continue
		fi
	done
else
	echo "declare -r PFPSOLARISALIAS=0 &>/dev/null" >>$PFPCONFIG
	echo "declare -r PFPSOLARISPRTDIAG=0 &>/dev/null" >>$PFPCONFIG
	echo "declare -r PFPSOLARISIOSTAT=0 &>/dev/null" >>$PFPCONFIG
	echo "declare -r PFPSOLARISSMPATCH=0 &>/dev/null" >>$PFPCONFIG
fi

# Gentoo...
if [ -f /etc/gentoo-release ]; then
	while true
	do
		echo -n "Use the gentooupdate module? [Y/n]: "
		read USEGENTOOUP

		if [ -z $USEGENTOOUP ] || [ $USEGENTOOUP == "y" ] || [ $USEGENTOOUP == "Y" ]; then
# INSTALL CRONTAB TO SYNC DAILY AND MAKE A REPORT
			echo "declare -r PFPGENTOOUPDATE=1 &>/dev/null" >>$PFPCONFIG
			ln -s $PFPINSTDIR/modules/gentooupdate.sh $PFPINSTDIR/sbin/gentooupdate
			break
		elif [ $USEGENTOOUP == "n" ] || [ $USEGENTOOUP == "N" ]; then
			echo "declare -r PFPGENTOOUPDATE=0 &>/dev/null" >>$PFPCONFIG
			break
		else
			continue
		fi
	done
else
	echo "declare -r PFPGENTOOUPDATE=0 &>/dev/null" >>$PFPCONFIG
fi

# Grsecurity
if [ -d /proc/sys/kernel/grsecurity ]; then
	while true
	do
		echo -n "Use the grsecurity module? [Y/n]: "
		read USEGRSEC

		if [ -z $USEGRSEC ] || [ $USEGRSEC == "y" ] || [ $USEGRSEC == "Y" ]; then
			echo "declare -r PFPGRSEC=1 &>/dev/null" >>$PFPCONFIG
			ln -s $PFPINSTDIR/modules/grsec.sh $PFPINSTDIR/sbin/grsec
			break
		elif [ $USEGRSEC == "n" ] || [ $USEGRSEC == "N" ]; then
			echo "declare -r PFPGRSEC=0 &>/dev/null" >>$PFPCONFIG
			break
		else
			continue
		fi
	done
fi

if [ "`uname`" == "Linux" ]; then
	while true
	do
		echo -n "Use the checksec module? [Y/n]: "
		read USECHECKSEC

		if [ -z $USECHECKSEC ] || [ $USECHECKSEC == "y" ] || [ $USECHECKSEC == "Y" ]; then
			echo "declare -r PFPCHECKSEC=1 &>/dev/null" >>$PFPCONFIG
			ln -s $PFPINSTDIR/modules/checksec.sh $PFPINSTDIR/bin/checksec
			break
		elif [ $USECHECKSEC == "n" ] || [ $USECHECKSEC == "N" ]; then
			echo "declare -r PFPCHECKSEC=0 &>/dev/null" >>$PFPCONFIG
			break
		else
			continue
		fi
	done
else
	echo "declare -r PFPCHECKSEC=0 &>/dev/null" >>$PFPCONFIG
fi

# Restricted logging
while true
do
	echo
	echo "WARNING: This module is not is not a totally secure logging method."
	echo
	echo "This module is only intended for convenient command history."
	echo "It can also be a distraction for an attacker (script kiddie)."
	echo "For safer logging use bash logger and kernel exec logging."
	echo
	echo -n "Use the restricted logging module? [Y/n]: "
	read USERLOG

	if [ -z $USERLOG ] || [ $USERLOG == "y" ] || [ $USERLOG == "Y" ]; then
		echo "declare -r PFPRLOG=1 &>/dev/null" >>$PFPCONFIG
		echo "declare -r PFPRLOGDIR=/var/history &>/dev/null" >>$PFPCONFIG
		echo "declare -r PFPRLOGSIZE=134217728 &>/dev/null" >>$PFPCONFIG
		echo "declare -r PFPRLOGLINES=1000000 &>/dev/null" >>$PFPCONFIG
		ln -s $PFPINSTDIR/modules/rlogupdate.sh $PFPINSTDIR/sbin/rlogupdate
		$PFPINSTDIR/sbin/rlogupdate
		crontab -l|sed '/^#/ d' >/tmp/rlog-cron
		echo "0 */2 * * * $PFPINSTDIR/sbin/rlogupdate" >>/tmp/rlog-cron
		crontab /tmp/rlog-cron
		rm /tmp/rlog-cron
		break
	elif [ $USERLOG == "n" ] || [ $USERLOG == "N" ]; then
		echo "declare -r PFPRLOG=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Permissions checker
while true
do
	echo -n "Use the permission checker (permcheck) module? [Y/n]: "
	read USEPERMCHECK

	if [ -z $USEPERMCHECK ] || [ $USEPERMCHECK == "y" ] || [ $USEPERMCHECK == "Y" ]; then
		echo "declare -r PFPPERMCHECK=1 &>/dev/null" >>$PFPCONFIG
		ln -s $PFPINSTDIR/modules/permcheck.sh $PFPINSTDIR/sbin/permcheck
		break
	elif [ $USEPERMCHECK == "n" ] || [ $USEPERMCHECK == "N" ]; then
		echo "declare -r PFPPERMCHECK=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# Locate in a jam
while true
do
	echo -n "Use the locate/updatedb only when you are in a jam module? [y/N]: "
	read USELOCATE

	if [ -z $USELOCATE ] || [ $USELOCATE == "n" ] || [ $USELOCATE == "N" ]; then
		echo "declare -r PFPLOCATE=0 &>/dev/null" >>$PFPCONFIG
		break
	elif [ $USELOCATE == "y" ] || [ $USELOCATE == "Y" ]; then
# CRONTAB TO RUN UPDATEDB DAILY
		echo "declare -r PFPLOCATE=1 &>/dev/null" >>$PFPCONFIG
		echo "declare -r PFPLOCATEDB=\".locatedb\" &>/dev/null" >>$PFPCONFIG
		ln -s $PFPINSTDIR/modules/locate.sh $PFPINSTDIR/sbin/locate
		ln -s $PFPINSTDIR/modules/updatedb.sh $PFPINSTDIR/sbin/updatedb
		break
	else
		continue
	fi
done

# bash shopt
while true
do
	echo -n "Use the shopt module? [Y/n]: "
	read USESHOPT
	if [ -z $USESHOPT ] || [ $USESHOPT == "y" ] || [ $USESHOPT == "Y" ]; then
		echo "declare -r PFPSHOPT=1 &>/dev/null" >>$PFPCONFIG
		source $PFPINSTDIR/config
		source $PFPINSTDIR/modules/shopt.sh
		break
	elif [ $USESHOPT == "n" ] || [ $USESHOPT == "N" ]; then
		echo "declare -r PFPSHOPT=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

# prompt
declare -a PCC
PCC[0]='\e[0;30m' # Black - Regular
PCC[1]='\e[0;31m' # Red
PCC[2]='\e[0;32m' # Green
PCC[3]='\e[0;33m' # Yellow
PCC[4]='\e[0;34m' # Blue
PCC[5]='\e[0;35m' # Purple
PCC[6]='\e[0;36m' # Cyan
PCC[7]='\e[0;37m' # White
PCC[8]='\e[1;30m' # Black - Bold
PCC[9]='\e[1;31m' # Red
PCC[10]='\e[1;32m' # Green
PCC[11]='\e[1;33m' # Yellow
PCC[12]='\e[1;34m' # Blue
PCC[13]='\e[1;35m' # Purple
PCC[14]='\e[1;36m' # Cyan
PCC[15]='\e[1;37m' # White
PCC[16]='\e[4;30m' # Black - Underline
PCC[17]='\e[4;31m' # Red
PCC[18]='\e[4;32m' # Green
PCC[19]='\e[4;33m' # Yellow
PCC[20]='\e[4;34m' # Blue
PCC[21]='\e[4;35m' # Purple
PCC[22]='\e[4;36m' # Cyan
PCC[23]='\e[4;37m' # White
PCC[24]='\e[40m'   # Black - Background
PCC[25]='\e[41m'   # Red
PCC[26]='\e[42m'   # Green
PCC[27]='\e[43m'   # Yellow
PCC[28]='\e[44m'   # Blue
PCC[29]='\e[45m'   # Purple
PCC[30]='\e[46m'   # Cyan
PCC[31]='\e[47m'   # White
PCC[32]='\e[0m'    # Text Reset
while true
do
	echo -n "Use the prompt module? [Y/n]: "
	read USEPROMPT

	if [ -z $USEPROMPT ] || [ $USEPROMPT == "y" ] || [ $USEPROMPT == "Y" ]; then
		while true
		do
			echo "Fancy prompts"
			echo
			echo -e " 1. ${PCC[6]}%${PCC[12]}[${PCC[32]}username${PCC[6]}@${PCC[32]}hostname${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[32]}path${PCC[12]}]${PCC[6]}\$ ${PCC[32]}./test"
			echo -e " 2. ${PCC[6]}%${PCC[12]}[${PCC[15]}username${PCC[6]}@${PCC[15]}hostname${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[15]}path${PCC[12]}]${PCC[6]}\$ ${PCC[32]}./test"
			echo -e " 3. ${PCC[6]}%${PCC[12]}[${PCC[14]}username${PCC[6]}@${PCC[14]}hostname${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[14]}path${PCC[12]}]${PCC[6]}\$ ${PCC[32]}./test"
			echo -e " 4. ${PCC[14]}%${PCC[12]}[${PCC[6]}username${PCC[4]}@${PCC[6]}hostname${PCC[12]}]${PCC[14]}%${PCC[12]}[${PCC[6]}path${PCC[12]}]${PCC[14]}\$ ${PCC[32]}./test"
			echo -e " 5. ${PCC[7]}%${PCC[9]}[${PCC[15]}username${PCC[7]}@${PCC[15]}hostname${PCC[9]}]${PCC[7]}%${PCC[9]}[${PCC[15]}path${PCC[9]}]${PCC[7]}\$ ${PCC[32]}./test"
			echo -e " 6. ${PCC[8]}%${PCC[9]}[${PCC[15]}username${PCC[8]}@${PCC[15]}hostname${PCC[9]}]${PCC[8]}%${PCC[9]}[${PCC[15]}path${PCC[9]}]${PCC[8]}\$ ${PCC[32]}./test"
			echo -e " 7. ${PCC[7]}%${PCC[9]}[${PCC[32]}username${PCC[7]}@${PCC[32]}hostname${PCC[9]}]${PCC[7]}%${PCC[9]}[${PCC[32]}path${PCC[9]}]${PCC[7]}\$ ${PCC[32]}./test"
			echo -e " 8. ${PCC[8]}%${PCC[9]}[${PCC[32]}username${PCC[8]}@${PCC[32]}hostname${PCC[9]}]${PCC[8]}%${PCC[9]}[${PCC[32]}path${PCC[9]}]${PCC[8]}\$ ${PCC[32]}./test"
			echo -e " 9. ${PCC[6]}%${PCC[10]}[${PCC[15]}username${PCC[6]}@${PCC[15]}hostname${PCC[10]}]${PCC[6]}%${PCC[10]}[${PCC[15]}path${PCC[10]}]${PCC[6]}\$ ${PCC[32]}./test"
			echo -e "10. ${PCC[14]}%${PCC[10]}[${PCC[15]}username${PCC[14]}@${PCC[15]}hostname${PCC[10]}]${PCC[14]}%${PCC[10]}[${PCC[15]}path${PCC[10]}]${PCC[14]}\$ ${PCC[32]}./test"
			echo -e "11. ${PCC[6]}%${PCC[10]}[${PCC[32]}username${PCC[6]}@${PCC[32]}hostname${PCC[10]}]${PCC[6]}%${PCC[10]}[${PCC[32]}path${PCC[10]}]${PCC[6]}\$ ${PCC[32]}./test"
			echo -e "12. ${PCC[14]}%${PCC[10]}[${PCC[32]}username${PCC[14]}@${PCC[32]}hostname${PCC[10]}]${PCC[14]}%${PCC[10]}[${PCC[32]}path${PCC[10]}]${PCC[14]}\$ ${PCC[32]}./test"
			echo
			echo "Simpler prompts"
			echo
			echo -e "13. ${PCC[12]}(${PCC[32]}username${PCC[6]}@${PCC[32]}hostname${PCC[12]})(${PCC[32]}path${PCC[12]})${PCC[6]}\$ ${PCC[32]}./test"
			echo -e "14. ${PCC[9]}(${PCC[32]}username${PCC[7]}@${PCC[32]}hostname${PCC[9]})(${PCC[32]}path${PCC[9]})${PCC[7]}\$ ${PCC[32]}./test"
			echo -e "15. ${PCC[10]}(${PCC[32]}username${PCC[14]}@${PCC[32]}hostname${PCC[10]})(${PCC[32]}path${PCC[10]})${PCC[14]}\$ ${PCC[32]}./test"
			echo -e "16. ${PCC[11]}(${PCC[32]}username${PCC[10]}@${PCC[32]}hostname${PCC[11]})(${PCC[32]}path${PCC[11]})${PCC[10]}\$ ${PCC[32]}./test"
			echo
			echo "Minimal prompts"
			echo
			echo -e "17. ${PCC[6]}username ${PCC[32]}path ${PCC[6]}\$ ${PCC[32]}./test"
			echo -e "18. ${PCC[14]}username ${PCC[15]}path ${PCC[14]}\$ ${PCC[32]}./test"
			echo -e "19. ${PCC[10]}username ${PCC[32]}path ${PCC[6]}\$ ${PCC[32]}./test"
			echo -e "20. ${PCC[10]}username ${PCC[15]}path ${PCC[14]}\$ ${PCC[32]}./test"
			echo -e "21. ${PCC[11]}username ${PCC[32]}path ${PCC[10]}\$ ${PCC[32]}./test"
			echo -e "22. ${PCC[11]}username ${PCC[10]}path ${PCC[15]}\$ ${PCC[32]}./test"
			echo -e "23. ${PCC[6]}username ${PCC[14]}path ${PCC[32]}\$ ${PCC[32]}./test"
			echo -e "24. ${PCC[6]}username ${PCC[14]}path ${PCC[15]}\$ ${PCC[32]}./test"
			echo -e "25. ${PCC[32]}username ${PCC[15]}path ${PCC[9]}\$ ${PCC[32]}./test"
			echo -e "26. ${PCC[8]}username ${PCC[32]}path ${PCC[9]}\$ ${PCC[32]}./test"
			echo -e "27. ${PCC[12]}username ${PCC[32]}path ${PCC[5]}\$ ${PCC[32]}./test"
			echo -e "28. ${PCC[5]}username ${PCC[32]}path ${PCC[13]}\$ ${PCC[32]}./test"
			echo -e "29. ${PCC[5]}username ${PCC[12]}path ${PCC[13]}\$ ${PCC[32]}./test"

			echo -n "Default user prompt (1-29) [1]: "
			read USEPROMPT
			if [ -z $USEPROMPT ]; then
				echo "declare -r PFPPROMPT=1 &>/dev/null" >>$PFPCONFIG
				break
			fi
			case $USEPROMPT in
				1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29)
					echo "declare -r PFPPROMPT=$USEPROMPT &>/dev/null" >>$PFPCONFIG
					break
					;;
				*)
					continue
					;;
			esac
		done

# termbar
		while true
		do
			echo -n "Use termbar module? [Y/n]: "
			read USETERMBAR
			if [ -z $USETERMBAR ] || [ $USETERMBAR == "y" ] || [ $USETERMBAR == "Y" ]; then
				echo "declare -r PFPPROMPTTERMBAR=1 &>/dev/null" >>$PFPCONFIG
				break
			elif [ $USETERMBAR == "n" ] || [ $USETERMBAR == "Y" ]; then
				echo "declare -r PFPPROMPTTERMBAR=0 &>/dev/null" >>$PFPCONFIG
				break
			else
				continue
			fi
		done
		break
	elif [ $USEPROMPT == "n" ] || [ $USEPROMPT == "N" ]; then
		echo "declare -r PFPPROMPT=0 &>/dev/null" >>$PFPCONFIG
		echo "declare -r PFPPROMPTTERMBAR=0 &>/dev/null" >>$PFPCONFIG
		break
	else
		continue
	fi
done

exit 0
