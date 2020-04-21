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
#    GNU/GPL v2 license can be found here: http://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
#
# profileplus version 2.0

termbar()
{
	case $TERM in
		xterm*|rxvt*|Eterm*|eterm*)
			export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD} - $(date)\007"'
			return 0
			;;
		*)
			return 1
			;;
	esac
	return 0
}

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
			return 0
			;;
		*)
			return 1
			;;
	esac
	return 0
}
