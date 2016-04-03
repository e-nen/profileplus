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

# there are some missing shopt's that should be added

if [ -z $(shopt|grep cmdhist|awk '{ print $2 }') ]; then
	echo "shopt cmdhist missing!"
else
	shopt -s cmdhist
fi

if [ -z $(shopt|grep histappend|awk '{ print $2 }') ]; then
	echo "shopt histappend missing!"
else
	shopt -s histappend
fi

if [ -z $(shopt|grep cdspell|awk '{ print $2 }') ]; then
	echo "shopt cdspell missing!"
else
	shopt -s cdspell
fi

if [ -z $(shopt|grep dirspell|awk '{ print $2 }') ]; then
	echo "shopt dirspell missing!"
else
	shopt -s dirspell
fi

if [ -z $(shopt|grep checkwinsize|awk '{ print $2 }') ]; then
	echo "shopt checkwinsize missing!"
else
	shopt -s checkwinsize
fi

if [ -z $(shopt|grep no_empty_cmd_completion|awk '{ print $2 }') ]; then
	echo "shopt no_empty_cmd_completion missing!"
else
	shopt -s no_empty_cmd_completion
fi
