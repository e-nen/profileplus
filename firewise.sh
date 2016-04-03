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
#
# finish converting stand alone script and implement into profileplus
#
# firewise
# getopt
# -f first firewall - firewisefirstfw()
#	* INPUT default drop policy with stateful RELATED,ESTABLISHED allow
#	* FORWARD default drop?
#	* OUTPUT default allow?
#	* logging w or w/o rate limiting
#       * logging w or w/o special --log-prefix
#	* frag drop
#	* bad syn drop
#	* null scan drop
#	* xmas all scan drop
#	* xmas scan drop
#	* ack scan drop
#	* fin scan drop
#	* maimon scan drop
#	* invalid drop
#	* GEOIP drop w/ country list (requires xtables-addons)
#	* MASQUERADE
#	* DNAT
#	* SNAT?
#	* PKNOCK?
#	* chains to create LOGIACCEPT,LOGIDROP,LOGODROP,SHUN,FRAGDROP,BADSYNDROP,NULLSCANDROP,XMASALLSCANDROP,XMASSCANDROP,ACKSCANDROP,FINSCANDROP,MAIMONSCANDROP,INVALIDDROP,GEOIDROP,GEOODROP
# -F flush all - firewiseflushall()
# -l list all w/ line numbers - firewiselistall()
# -s shun host - firewiseshun()
# -p panic mode - firewisepanic()
# -c cook logs - firewiselogcooker()
# -h usage - firewiseusage()

zzfirewiseusage()
{
	echo 'Usage: firewise <option>'
	echo '       -f - first firewall setup'
	echo '       -F - flush all'
        echo '       -l - list all rules with line numbers'
	echo '       -s - shun <IP/netblock>'
	echo '       -p - panic mode (block everything: USE WITH CAUTION)'
	echo '       -c - cook logs and print statistics'
	echo '       -h - help'

	return 0
}

zzfirewisefirstfw()
{
	echo ">>> Configuring first firewall"
	return 0
}

zzfirewiseflushall()
{
	echo flushall
	return 0
}

zzfirewiselistall()
{
	echo listall
	return 0
}

zzfirewiseshun()
{
	echo shun
	return 0
}

zzfirewisepanic()
{
	echo panic
	return 0
}

zzfirewiselogcooker()
{
	echo logcooker
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

args=`getopt hfFlspc $*`
if [ "$?" != "0" ]; then
        zzfirewiseusage

        exit 1
fi
set -- $args

NUMOPTS=0
FWFUNC=0

for i; do
        if [ "$NUMOPTS" -gt "1" ]; then
                echo "ERROR: only specify one flag at a time"

                exit 1
        fi

        case "$i" in
                -h)
                        shift
                        zzfirewiseusage

                        exit 1
                        ;;
                -f)
                        shift
                        NUMOPTS=$(($NUMOPTS+1))
                        FWFUNC=1
                        ;;
                -F)
                        shift
                        NUMOPTS=$(($NUMOPTS+1))
                        FWFUNC=2
                        ;;
                -l)
                        shift
                        NUMOPTS=$(($NUMOPTS+1))
                        FWFUNC=3
                        ;;
                -s)
                        shift
                        NUMOPTS=$(($NUMOPTS+1))
                        FWFUNC=4
                        ;;
                -p)
                        shift
                        NUMOPTS=$(($NUMOPTS+1))
			FWFUNC=5
			;;
		-c)
			shift
			NUMOPTS=$(($NUMOPTS+1))
			FWFUNC=6
			;;
                --)
                        shift
                        ;;
                *)
                        shift
                        zzfirewiseusage

                        exit 1
                        ;;
        esac
done

case $FWFUNC in
        1)
                zzfirewisefirstfw
                ;;
        2)
                zzfirewiseflushall
                ;;
        3)
                zzfirewiselistall
                ;;
        4)
                zzfirewiseshun
                ;;
        5)
                zzfirewisepanic
                ;;
	6)
		zzfirewiselogcooker
		;;
        *)
                echo "ERROR: you broke it"

                exit 1
                ;;
esac

exit 0

