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
#
# profileplus version 1.0

# implement stuff from stand alone scripts and implement into profileplus
# fix and reimplement stuff from zimzum's script

########################################################
# 512 or 1024 bit keys should support most clients     #
# keys are valid up to 8192 bits in openssl            #
#                                                      #
# NOTE: newest IE and firefox work with >1024 bits     #
#       but netscape appears to malfunction. Use       #
#       512 or 1024-bit keys for greatest              #
#       compatability.                                 #
#                                                      #
# for Apache you'll want to make sure you              #
# compiled with ./configure --enable-ssl               #
# and add the following to your httpd.conf:            #
#                                                      #
# SSLEngine on                                         #
# SSLCertificateFile /path/to/www.yourhost.com.cert    #
# SSLCertificateKeyFile /path/to/www.yourhost.com.key  #
# SSLProtocol all                                      #
# SSLCipherSuite HIGH:MEDIUM                           #
#                                                      #
# you need this for each <VirtualHost> you want ssl on #
# -zimzum <zimzum@logick.net>                          #
########################################################

openssl=`which openssl`

if ! [ "$1" ] || ! [ "$2" ] || ! [ "$3" ] || ! [ "$4" ]; then
        echo "Usage:"
        echo "$0 hostname orgname adminEmail KeyBits"
        echo "eg: "
        echo "./makesslcerts.sh www.somehost.com someorg root@somehost.com 1024"
        echo "creates:"
        echo "www.somehost.com.key"
        echo "www.somehost.com.csr"
        echo "www.somehost.com.cert"
        echo "if successful."
        exit 0
fi


#grsec provides a HUGE kernel entropy pool in /dev/urandom
#NOTE:private key is not encrypted for the sake of
#functionality in a chroot()
#to encrypt private keys replace the command below this comment with:

#$openssl genrsa -rand /dev/urandom -aes256 -out $1.key $4

$openssl genrsa -rand /dev/urandom -out $1.key $4
chmod 400 ./$1.key

#create csr (certificate signing request needed for a cert)
$openssl req -new -subj /C=US/O=$2/CN=$2/emailAddress=$3 -key $1.key -out $1.csr

#create our cert
$openssl x509 -req -days 1024 -in $1.csr -signkey $1.key -out $1.cert

echo
echo
echo "To view Keypair info do:"
echo " openssl rsa -noout -text -in $1.key"
echo "To view Cert Signing Request info: "
echo " openssl req -noout -text -in $1.csr"

