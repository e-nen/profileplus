#!/bin/bash

date

apt update
apt -y -q dist-upgrade --fix-missing
apt -y -qq clean
apt -y -qq autoremove
apt -y -qq autoclean
apt -y purge $(dpkg -l | tail -n +6 | grep -v '^ii' | awk '{print $2}')

UDBBIN=$(which updatedb)
if [ -x "${UDBBIN}" ]; then
        updatedb
else
        echo "WARNING: updatedb not found or executable"
fi

CRBIN=$(which checkrestart)
if [ -x "${CRBIN}" ]; then
        checkrestart
else
        echo "WARNING: checkrestart not found or executable"
fi

if [ -f /var/run/reboot-required ]; then
        echo;cat /var/run/reboot-required;echo
fi
