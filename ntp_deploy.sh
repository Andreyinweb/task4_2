#!/bin/bash

chmod +x ntp_deploy.sh
chmod +x ntp_verify.sh

wayprog=$(pwd)

indpkg=$( dpkg --get-selections | grep -m 1 'ntp' | awk '{print $2}' )
if [ -n "$indpkg" ] ; then
    echo " TYT $indpkg "  # del
    if [[ "$indpkg" = "install" ]] ; then
       echo "DES install " # del
    else
        sudo apt-get -y install ntp
    fi
else
    sudo apt-get -y install ntp
fi

if ! [ -f /etc/ntp.conf ] ;then 
    echo "Error: ntp_deploy: There is no /etc/ntp.conf file" >&2 
    exit 1
fi

( sed '/pool 0/ c\pool 0.ua.pool.ntp.org' /etc/ntp.conf ) > temp.txt
( sed '/pool 1/ c\pool 1.ua.pool.ntp.org' temp.txt ) > /etc/ntp.conf.bak
( sed '/pool 2/ c\pool 2.ua.pool.ntp.org' /etc/ntp.conf.bak ) > temp.txt
( sed '/pool 3/ c\pool 3.ua.pool.ntp.org' temp.txt ) > /etc/ntp.conf.bak
( sed '/pool ntp/ c\pool ua.pool.ntp.org' /etc/ntp.conf.bak ) > temp.txt
cat temp.txt > /etc/ntp.conf.bak
rm -f temp.txt

cat /etc/ntp.conf.bak > /etc/ntp.conf

sudo service ntp restart

# ntp_verify.sh

sudo echo > /var/spool/cron/root
echo "*/1 * * * * $wayprog/ntp_verify.sh" >> /var/spool/cron/root
echo >> /var/spool/cron/root

crontab -u root /var/spool/cron/root

service cron reload

if [ -f ntp_verify.sh ] ; then
    exit 0
else
    echo "ntp_deploy.sh: No ntp_verify.sh file" >&2
    exit 1
fi
exit 1
