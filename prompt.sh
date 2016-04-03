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

# put original colors back and scrap "official" color codes... they suck and break everything
# add a few more prompts
# add a built in function to print out the available prompts?

declare -a PCC
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

prompt()
{
	case $SHELL in
		*/bash)
			case $PFPPROMPT in
				1) PS1="${PCC[6]}%${PCC[12]}[${PCC[32]}\u${PCC[6]}@${PCC[32]}\h${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[32]}\w${PCC[12]}]${PCC[6]}\\$ ${PCC[32]}";;
				2) PS1="${PCC[6]}%${PCC[12]}[${PCC[15]}\u${PCC[6]}@${PCC[15]}\h${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[15]}\w${PCC[12]}]${PCC[6]}\\$ ${PCC[32]}";;
				3) PS1="${PCC[6]}%${PCC[12]}[${PCC[14]}\u${PCC[6]}@${PCC[14]}\h${PCC[12]}]${PCC[6]}%${PCC[12]}[${PCC[14]}\w${PCC[12]}]${PCC[6]}\\$ ${PCC[32]}";;
				4) PS1="${PCC[14]}%${PCC[12]}[${PCC[6]}\u${PCC[4]}@${PCC[6]}\h${PCC[12]}]${PCC[14]}%${PCC[12]}[${PCC[6]}\w${PCC[12]}]${PCC[14]}\\$ ${PCC[32]}";;
				5) PS1="${PCC[7]}%${PCC[9]}[${PCC[15]}\u${PCC[7]}@${PCC[15]}\h${PCC[9]}]${PCC[7]}%${PCC[9]}[${PCC[15]}\w${PCC[9]}]${PCC[7]}\\$ ${PCC[32]}";;
				6) PS1="${PCC[8]}%${PCC[9]}[${PCC[15]}\u${PCC[8]}@${PCC[15]}\h${PCC[9]}]${PCC[8]}%${PCC[9]}[${PCC[15]}\w${PCC[9]}]${PCC[8]}\\$ ${PCC[32]}";;
				7) PS1="${PCC[7]}%${PCC[9]}[${PCC[32]}\u${PCC[7]}@${PCC[32]}\h${PCC[9]}]${PCC[7]}%${PCC[9]}[${PCC[32]}\w${PCC[9]}]${PCC[7]}\\$ ${PCC[32]}";;
				8) PS1="${PCC[8]}%${PCC[9]}[${PCC[32]}\u${PCC[8]}@${PCC[32]}\h${PCC[9]}]${PCC[8]}%${PCC[9]}[${PCC[32]}\w${PCC[9]}]${PCC[8]}\\$ ${PCC[32]}";;
				9) PS1="${PCC[6]}%${PCC[10]}[${PCC[15]}\u${PCC[6]}@${PCC[15]}\h${PCC[10]}]${PCC[6]}%${PCC[10]}[${PCC[15]}\w${PCC[10]}]${PCC[6]}\\$ ${PCC[32]}";;
				10) PS1="${PCC[14]}%${PCC[10]}[${PCC[15]}\u${PCC[14]}@${PCC[15]}\h${PCC[10]}]${PCC[14]}%${PCC[10]}[${PCC[15]}\w${PCC[10]}]${PCC[14]}\\$ ${PCC[32]}";;
				11) PS1="${PCC[6]}%${PCC[10]}[${PCC[32]}\u${PCC[6]}@${PCC[32]}\h${PCC[10]}]${PCC[6]}%${PCC[10]}[${PCC[32]}\w${PCC[10]}]${PCC[6]}\\$ ${PCC[32]}";;
				12) PS1="${PCC[14]}%${PCC[10]}[${PCC[32]}\u${PCC[14]}@${PCC[32]}\h${PCC[10]}]${PCC[14]}%${PCC[10]}[${PCC[32]}\w${PCC[10]}]${PCC[14]}\\$ ${PCC[32]}";;
				13) PS1="${PCC[12]}(${PCC[32]}\u${PCC[6]}@${PCC[32]}\h${PCC[12]})(${PCC[32]}\w${PCC[12]})${PCC[6]}\\$ ${PCC[32]}";;
				14) PS1="${PCC[9]}(${PCC[32]}\u${PCC[7]}@${PCC[32]}\h${PCC[9]})(${PCC[32]}\w${PCC[9]})${PCC[7]}\\$ ${PCC[32]}";;
				15) PS1="${PCC[10]}(${PCC[32]}\u${PCC[14]}@${PCC[32]}\h${PCC[10]})(${PCC[32]}\w${PCC[10]})${PCC[14]}\\$ ${PCC[32]}";;
				16) PS1="${PCC[11]}(${PCC[32]}\u${PCC[10]}@${PCC[32]}\h${PCC[11]})(${PCC[32]}\w${PCC[11]})${PCC[10]}\\$ ${PCC[32]}";;
				17) PS1="${PCC[6]}\u ${PCC[32]}\w ${PCC[6]}\\$ ${PCC[32]}";;
				18) PS1="${PCC[14]}\u ${PCC[15]}\w ${PCC[14]}\\$ ${PCC[32]}";;
				19) PS1="${PCC[10]}\u ${PCC[32]}\w ${PCC[6]}\\$ ${PCC[32]}";;
				20) PS1="${PCC[10]}\u ${PCC[15]}\w ${PCC[14]}\\$ ${PCC[32]}";;
				21) PS1="${PCC[11]}\u ${PCC[32]}\w ${PCC[10]}\\$ ${PCC[32]}";;
				22) PS1="${PCC[11]}\u ${PCC[10]}\w ${PCC[15]}\\$ ${PCC[32]}";;
				23) PS1="${PCC[6]}\u ${PCC[14]}\w ${PCC[32]}\\$ ${PCC[32]}";;
				24) PS1="${PCC[6]}\u ${PCC[14]}\w ${PCC[15]}\\$ ${PCC[32]}";;
				25) PS1="${PCC[32]}\u ${PCC[15]}\w ${PCC[9]}\\$ ${PCC[32]}";;
				26) PS1="${PCC[8]}\u ${PCC[32]}\w ${PCC[9]}\\$ ${PCC[32]}";;
				27) PS1="${PCC[12]}\u ${PCC[32]}\w ${PCC[5]}\\$ ${PCC[32]}";;
				28) PS1="${PCC[5]}\u ${PCC[32]}\w ${PCC[13]}\\$ ${PCC[32]}";;
				29) PS1="${PCC[5]}\u ${PCC[12]}\w ${PCC[13]}\\$ ${PCC[32]}";;
			esac
			export PS1
			;;
		*)
			return 1
			;;
	esac
}
