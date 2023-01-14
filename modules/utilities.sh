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

declare -a BCC # terminal basic colors
BCC[0]='\e[0;30m' # Black - Regular
BCC[1]='\e[0;31m' # Red
BCC[2]='\e[0;32m' # Green
BCC[3]='\e[0;33m' # Yellow
BCC[4]='\e[0;34m' # Blue
BCC[5]='\e[0;35m' # Purple
BCC[6]='\e[0;36m' # Cyan
BCC[7]='\e[0;37m' # White
BCC[8]='\e[1;30m' # Black - Bold
BCC[9]='\e[1;31m' # Red
BCC[10]='\e[1;32m' # Green
BCC[11]='\e[1;33m' # Yellow
BCC[12]='\e[1;34m' # Blue
BCC[13]='\e[1;35m' # Purple
BCC[14]='\e[1;36m' # Cyan
BCC[15]='\e[1;37m' # White
BCC[16]='\e[4;30m' # Black - Underline
BCC[17]='\e[4;31m' # Red
BCC[18]='\e[4;32m' # Green
BCC[19]='\e[4;33m' # Yellow
BCC[20]='\e[4;34m' # Blue
BCC[21]='\e[4;35m' # Purple
BCC[22]='\e[4;36m' # Cyan
BCC[23]='\e[4;37m' # White
BCC[24]='\e[40m'   # Black - Background
BCC[25]='\e[41m'   # Red
BCC[26]='\e[42m'   # Green
BCC[27]='\e[43m'   # Yellow
BCC[28]='\e[44m'   # Blue
BCC[29]='\e[45m'   # Purple
BCC[30]='\e[46m'   # Cyan
BCC[31]='\e[47m'   # White
BCC[32]='\e[0m'    # Text Reset

declare -a PCC # terminal prompt colors... these had to be different because bash
PCC[0]="\[\033[0;30m\]" # Black - Regular
PCC[1]="\[\033[0;31m\]" # Red
PCC[2]="\[\033[0;32m\]" # Green
PCC[3]="\[\033[0;33m\]" # Yellow
PCC[4]="\[\033[0;34m\]" # Blue
PCC[5]="\[\033[0;35m\]" # Purple
PCC[6]="\[\033[0;36m\]" # Cyan
PCC[7]='\e[0;37m' # White
PCC[8]="\[\033[1;30m\]" # Black - Bold
PCC[9]="\[\033[1;31m\]" # Red
PCC[10]="\[\033[1;32m\]" # Green
PCC[11]="\[\033[1;33m\]" # Yellow
PCC[12]="\[\033[1;34m\]" # Blue
PCC[13]="\[\033[1;35m\]" # Purple
PCC[14]="\[\033[1;36m\]" # Cyan
PCC[15]="\[\033[1;37m\]" # White
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
PCC[32]="\[\033[0;26m\]"

errordie() # one paramater which is a string explaining the error
{
	if [ $# -gt 1 ]; then
		echo "ERROR: errordie() too many arguments"
	elif [ $# -eq 0 ]; then
		echo "ERROR: errordie() missing argument"
	else
		echo "ERROR: $1"
	fi
	exit 1
}

errorfail() # one paramater which is a string explaining the error
{
	if [ $# -gt 1 ]; then
		echo "ERROR: errorfail() too many arguments"
	elif [ $# -eq 0 ]; then
		echo "ERROR: errorfail() missing argument"
	else
		echo "ERROR: $1"
	fi
}

warnfail() # one paramater which is a string explaining the error
{
	if [ $# -gt 1 ]; then
		echo "WARNING: warnfail() too many arguments"
	elif [ $# -eq 0 ]; then
		echo "WARNING: warnfail() missing argument"
	else
		echo "WARNING: $1"
	fi
}

checkdependency() # variable arguments to loop and which/exec test
{
	if [ $# -gt 0 ]; then
		for (( ijt=1; ijt<=$#; ijt++ ))
		{
			eval dependencybin='$'$ijt
			CHECKDEPBIN=`which $dependencybin 2>/dev/null`
			if [ $? != "0" ]; then
				echo "ERROR: Cannot find a required dependency: $dependencybin"
				exit 1
			fi

			if ! [ -x $CHECKDEPBIN ]; then
				echo "ERROR: Cannot execute required dependency: $CHECKDEPBIN"
				exit 1
			fi
		}
	fi
}

checkeuidroot()
{
	if [ $EUID != "0" ]; then
		echo "ERROR: root user privileges required"
		exit 1
	fi
}

showprompts()
{
	echo -e " 1. ${BCC[6]}%${BCC[12]}[${BCC[32]}username${BCC[6]}@${BCC[32]}hostname${BCC[12]}]${BCC[6]}%${BCC[12]}[${BCC[32]}path${BCC[12]}]${BCC[6]}\$ ${BCC[32]}./test"
	echo -e " 2. ${BCC[6]}%${BCC[12]}[${BCC[15]}username${BCC[6]}@${BCC[15]}hostname${BCC[12]}]${BCC[6]}%${BCC[12]}[${BCC[15]}path${BCC[12]}]${BCC[6]}\$ ${BCC[32]}./test"
	echo -e " 3. ${BCC[6]}%${BCC[12]}[${BCC[14]}username${BCC[6]}@${BCC[14]}hostname${BCC[12]}]${BCC[6]}%${BCC[12]}[${BCC[14]}path${BCC[12]}]${BCC[6]}\$ ${BCC[32]}./test"
	echo -e " 4. ${BCC[14]}%${BCC[12]}[${BCC[6]}username${BCC[4]}@${BCC[6]}hostname${BCC[12]}]${BCC[14]}%${BCC[12]}[${BCC[6]}path${BCC[12]}]${BCC[14]}\$ ${BCC[32]}./test"
	echo -e " 5. ${BCC[7]}%${BCC[9]}[${BCC[15]}username${BCC[7]}@${BCC[15]}hostname${BCC[9]}]${BCC[7]}%${BCC[9]}[${BCC[15]}path${BCC[9]}]${BCC[7]}\$ ${BCC[32]}./test"
	echo -e " 6. ${BCC[8]}%${BCC[9]}[${BCC[15]}username${BCC[8]}@${BCC[15]}hostname${BCC[9]}]${BCC[8]}%${BCC[9]}[${BCC[15]}path${BCC[9]}]${BCC[8]}\$ ${BCC[32]}./test"
	echo -e " 7. ${BCC[7]}%${BCC[9]}[${BCC[32]}username${BCC[7]}@${BCC[32]}hostname${BCC[9]}]${BCC[7]}%${BCC[9]}[${BCC[32]}path${BCC[9]}]${BCC[7]}\$ ${BCC[32]}./test"
	echo -e " 8. ${BCC[8]}%${BCC[9]}[${BCC[32]}username${BCC[8]}@${BCC[32]}hostname${BCC[9]}]${BCC[8]}%${BCC[9]}[${BCC[32]}path${BCC[9]}]${BCC[8]}\$ ${BCC[32]}./test"
	echo -e " 9. ${BCC[6]}%${BCC[10]}[${BCC[15]}username${BCC[6]}@${BCC[15]}hostname${BCC[10]}]${BCC[6]}%${BCC[10]}[${BCC[15]}path${BCC[10]}]${BCC[6]}\$ ${BCC[32]}./test"
	echo -e "10. ${BCC[14]}%${BCC[10]}[${BCC[15]}username${BCC[14]}@${BCC[15]}hostname${BCC[10]}]${BCC[14]}%${BCC[10]}[${BCC[15]}path${BCC[10]}]${BCC[14]}\$ ${BCC[32]}./test"
	echo -e "11. ${BCC[6]}%${BCC[10]}[${BCC[32]}username${BCC[6]}@${BCC[32]}hostname${BCC[10]}]${BCC[6]}%${BCC[10]}[${BCC[32]}path${BCC[10]}]${BCC[6]}\$ ${BCC[32]}./test"
	echo -e "12. ${BCC[14]}%${BCC[10]}[${BCC[32]}username${BCC[14]}@${BCC[32]}hostname${BCC[10]}]${BCC[14]}%${BCC[10]}[${BCC[32]}path${BCC[10]}]${BCC[14]}\$ ${BCC[32]}./test"
	echo -e "13. ${BCC[12]}(${BCC[32]}username${BCC[6]}@${BCC[32]}hostname${BCC[12]})(${BCC[32]}path${BCC[12]})${BCC[6]}\$ ${BCC[32]}./test"
	echo -e "14. ${BCC[9]}(${BCC[32]}username${BCC[7]}@${BCC[32]}hostname${BCC[9]})(${BCC[32]}path${BCC[9]})${BCC[7]}\$ ${BCC[32]}./test"
	echo -e "15. ${BCC[10]}(${BCC[32]}username${BCC[14]}@${BCC[32]}hostname${BCC[10]})(${BCC[32]}path${BCC[10]})${BCC[14]}\$ ${BCC[32]}./test"
	echo -e "16. ${BCC[11]}(${BCC[32]}username${BCC[10]}@${BCC[32]}hostname${BCC[11]})(${BCC[32]}path${BCC[11]})${BCC[10]}\$ ${BCC[32]}./test"
	echo -e "17. ${BCC[6]}username ${BCC[32]}path ${BCC[6]}\$ ${BCC[32]}./test"
	echo -e "18. ${BCC[14]}username ${BCC[15]}path ${BCC[14]}\$ ${BCC[32]}./test"
	echo -e "19. ${BCC[10]}username ${BCC[32]}path ${BCC[6]}\$ ${BCC[32]}./test"
	echo -e "20. ${BCC[10]}username ${BCC[15]}path ${BCC[14]}\$ ${BCC[32]}./test"
	echo -e "21. ${BCC[11]}username ${BCC[32]}path ${BCC[10]}\$ ${BCC[32]}./test"
	echo -e "22. ${BCC[11]}username ${BCC[10]}path ${BCC[15]}\$ ${BCC[32]}./test"
	echo -e "23. ${BCC[6]}username ${BCC[14]}path ${BCC[32]}\$ ${BCC[32]}./test"
	echo -e "24. ${BCC[6]}username ${BCC[14]}path ${BCC[15]}\$ ${BCC[32]}./test"
	echo -e "25. ${BCC[32]}username ${BCC[15]}path ${BCC[9]}\$ ${BCC[32]}./test"
	echo -e "26. ${BCC[8]}username ${BCC[32]}path ${BCC[9]}\$ ${BCC[32]}./test"
	echo -e "27. ${BCC[12]}username ${BCC[32]}path ${BCC[5]}\$ ${BCC[32]}./test"
	echo -e "28. ${BCC[5]}username ${BCC[32]}path ${BCC[13]}\$ ${BCC[32]}./test"
	echo -e "29. ${BCC[5]}username ${BCC[12]}path ${BCC[13]}\$ ${BCC[32]}./test"
	return 0
}
