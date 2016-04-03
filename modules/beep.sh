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

# requires the PC speaker beeper (http://www.johnath.com/beep/)
# in gentoo its app-misc/beep
#
# eventually clean this up and integrate it into profileplus
#
# consolebeep() function
# - uses getopt
#   -d denied - deniedbeep()
#   -h hostdown - hostdownbeep()
#   -a alarm - alarmbeep()
#   -w warning - warningbeep()
#   -A alarms and warnings off - alarmoff()

clear
sleep 1
clear
echo "denied alert"
sleep 1
beep -f 100 -l 600 -r 3 -d 500
clear
echo "serious event alert"
sleep 1
for (( j=0; j<3; j++)) do for (( i=100; i<5000; i+=100 )) do beep -f $i -l 10; done; for (( k=5000; k>0; k-=100 )) do beep -f $k -l 10; done; done
clear
echo "moderate event alert"
sleep 1
for (( k=0; k<3; k++ )) do beep -f 200 -l 250 -n -f 100 -l 250; done
clear
echo "generic event alert"
sleep 1
beep -f 2000 -l 100 -r 5 -d 100
