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

# change this implementation to the working one from stand alone script and finish implementing into profileplus
# possibly tie this into the prompt and the format/colors its using?

loadbar() {
	tput cuu1
	tput sc
	tput cup 0 0

	local MEDIUM="40"
	local HIGH="80"
	local COLOR1="\033[0;26m" # WHITE
	local COLOR2="\033[1;34m" # BLUE
	local COLOR3="\033[0;36m" # CYAN
	local COLOR4="\033[1;31m" # RED
	local COLOR5="\033[1;33m" # YELLOW
	local COLOR6="\033[1;32m" # GREEN
	local UPTIME=`uptime`
	local BARCHAR='#'
	local CURLOAD=0
	local b=0

	for tokes in $UPTIME; do
		b=$(($b+1))
	done

	local j=$(($b-2))
	local i=0

	for tokes in $UPTIME; do
		i=$(($i+1))
		if [ $i -eq $j ]; then
			CURLOAD=`echo $tokes|awk -F , '{ print $1 }'`
			DECLOAD=`echo "scale=2; $CURLOAD*100"|bc`
		fi
	done

	local INTLOAD=`echo $DECLOAD|awk -F . '{ print $1 }'`

	echo -en "$COLOR3"
	echo -n '%'
	echo -en "$COLOR2"
	echo -n '['
	echo -en "$COLOR6"

	for (( n=0; n<10; n++ ))
	do
		o=$(($n*10))
		if [ $o -lt $INTLOAD ]; then
			if [ $o -ge $HIGH ]; then
				echo -en "$COLOR4"
			elif [ $o -ge $MEDIUM ]; then
				echo -en "$COLOR5"
			fi
			echo -n $BARCHAR
		else
			echo -n " "
		fi
	done

	echo -n " $CURLOAD"
	echo -en "$COLOR2"
	echo -n ']'

	local FREESTR=`free|sed -n '2p'`
	local USEDMEM=`echo $FREESTR|awk '{ print $3 }'`
	local TOTLMEM=`echo $FREESTR|awk '{ print $2 }'`
	local PREPERC=`echo "scale=2; $USEDMEM/$TOTLMEM"|bc`
	local PSTPERC=`echo "scale=2; $PREPERC*100"|bc|awk -F . '{ print $1 }'`

	echo -en "$COLOR3"
	echo -n '%'
        echo -en "$COLOR2"
	echo -n '['
	echo -en "$COLOR6"

	for (( m=0; m<10; m++ ))
	do
		l=$(($m*10))
		if [ $l -lt $PSTPERC ]; then
			if [ $l -ge $HIGH ]; then
				echo -en "$COLOR4"
			elif [ $l -ge $MEDIUM ]; then
				echo -en "$COLOR5"
			fi
			echo -n $BARCHAR
		else
			echo -n " "
		fi
	done

	echo -n " $PSTPERC%"
	echo -en "$COLOR2"
	echo -n ']'
	echo -en "$COLOR3"
	echo -n '%'
	echo -en "$COLOR2"
	echo -n '['

	local USERSN=$(($b-6))
        local z=0

        for tokers in $UPTIME; do
                z=$(($z+1))
                if [ $z -eq $USERSN ]; then
                        USERSL=$tokers
			break
                fi
        done

	echo -en "$COLOR1"
	echo -n "$USERSL"
	echo -en "$COLOR2"
	echo -n ']'
	echo -en "$COLOR3"
	echo -n '%'
	echo -en "$COLOR2"
	echo -n '['
	echo -en "$COLOR1"
	echo -n "`date "+%I:%M%p %D"`"
	echo -en "$COLOR2"
	echo -n ']'
	echo -en "$COLOR3"
	echo -n '%'
	echo -en "$COLOR1"

	tput rc

	echo
}
