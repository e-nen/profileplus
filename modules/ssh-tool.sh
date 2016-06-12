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

# implement all of the following stuff from stand alone scripts and implement into profileplus
# fix and reimplement stuff from zimzum's script

# ssh config aliases
# ssh-keygen aliases
# - moduli creation
# - strong host key creation
# - strong public key creation
# - strengthen public key with PKCS#8
# ssh key storage

# opts
# -a add alias
# -l list alias
# -d delete alias
# -m generate moduli
# -k generate host key
# -p generate public key
# -R recommended sshd_config options
# -h help

# host aliases example (probably could use a few other options like preferred auth, etc.)
#Host tunnel
#    HostName database.example.com
#    IdentityFile ~/.ssh/smegma.example.key
#    LocalForward 9906 127.0.0.1:3306
#    User smegma
#    Port 4443

sshcomplement()
{
	case $SHELL in
		*/bash)
			;;
		*)
			echo "ERROR: this is not bash.. permission to freak out"

			return 101
			;;
	esac

	if [ $# == 0 ]; then
		zzsshcomplementusage

		return 1
	fi

	args=`getopt aldmkph $*`
	if [ $? != 0 ]; then
		zzsshcomplementusage

	return 4
	fi
	set -- $args
}

zzsshcompleementusage()
{
        echo "Usage: sshcomplement <option>"
        echo "	-a: add alias"
	echo "	-l: list alias"
	echo "	-d: delete alias"
	echo "	-m: generate moduli"
	echo "	-k: generate host keys"
	echo "	-p: generate public key"
	echo "  -h: this help screen"

	return 0
}

#########################################################
# openssh cryptographic strengthening                   #
# generates new moduli which withstand cryptographic    #
# testing for primeness generates new 4096-bit RSA keys #
# for openssh using the new primes.                     #
#                                                       #
# generate.sh:
# zimzum@logick.net 2006                                #
#########################################################
#
# profileplus version 0.6


# functions
# needs fixing for
# - ec
# - 8192?
# - fuck rsa1?
# - fuck dsa?



sshkg=`which ssh-keygen`
HOSTKEY="/etc/ssh/ssh_host_key"
DSAHOSTKEY="/etc/ssh/ssh_host_dsa_key"
RSAHOSTKEY="/etc/ssh/ssh_host_rsa_key"
MODULIFILE="/etc/ssh/moduli"

#most people wont want to edit below here

if ! [ $sshkg ]; then
        echo "ssh-keygen not found in PATH."
        exit 0
fi

#generate candidates for testing
echo "Generating 1024 primes...please wait..."
$sshkg -q -G ./moduli-1024.candidates -b 1024
echo "1024-bit prime candidates generated..."
echo "Generating 2048-bit primes...please wait..."
$sshkg -q -G ./moduli-2048.candidates -b 2048
echo "2048-bit prime candidates generated..."
echo "Generating 4096-bit primes...please wait...(this may take a while)"
$sshkg -q -G ./moduli-4096.candidates -b 4096
echo "4096-bit prime candidates generated..."

#test candidates with 100 primality tests each
echo "Testing 1024-bit candidates..."
$sshkg -q -T ./moduli-1024 -f ./moduli-1024.candidates
echo "1024-bit primality testing completed..."
echo "Testing 2048-bit candidates..."
$sshkg -q -T ./moduli-2048 -f ././moduli-2048.candidates
echo "2048-bit primality testing completed..."
echo "Testing 4096-bit candidates...(this may take a while)"
$sshkg -q -T ./moduli-4096 -f ./moduli-4096.candidates
echo "4096-bit primality testing completed..."

#install the completed moduli
echo "Creating new moduli file for use with sshd..."
cat ./moduli-1024 ./moduli-2048 ./moduli-4096 > ./moduli.new

echo -n "Would you like to replace your openssh keys now?[y/n] "
read ANS
if [ "$ANS" == "n" ]; then
        exit 0
fi
#key generation should be redone with new moduli
echo "Backing up your old files to $MODULIFILE.old, $HOSTKEY.old, $DSAHOSTKEY.old, and $RSAHOSTKEY.old..."
if [ -e "$MODULIFILE" ]; then
        mv $MODULIFILE $MODULIFILE.old
fi
if [ -e "$HOSTKEY" ]; then
        mv $HOSTKEY $HOSTKEY.old
fi
if [ -e "$DSAHOSTKEY" ]; then
        mv $DSAHOSTKEY $DSAHOSTKEY.old
fi
if [ -e "$RSAHOSTKEY" ]; then
        mv $RSAHOSTKEY $RSAHOSTKEY.old
fi
echo "Generating hostkey..."
$sshkg -t rsa1 -b 4096 -f $HOSTKEY -N ''
echo "Generating DSA-hostkey..."
$sshkg -d -f $DSAHOSTKEY -N ''
echo "Generating RSA-hostkey..."
$sshkg -t rsa -b 4096 -f $RSAHOSTKEY -N ''
echo "done."
echo "You may want to restart your sshd now via your initscripts and end this session to begin using your new keys."
exit 0

