#!/bin/bash

############################# del 
exec 4<&1
exec 1>task4_2.out

exec 5<&2
exec 2>errors4_2.log
############################# del

if ! [ "$( ntpq -p )" ] ; then
    echo "NOTICE: ntp is not running" 
    sudo service ntp start
fi
 
if ! [ -f /etc/ntp.conf ] ; then 
    echo "Error: ntp_verify: no file /etc/ntp.conf.bak" >&2
    exit 1
fi

if ! [ -f /etc/ntp.conf.bak ] ; then 
    echo "NOTICE: No file '/etc/ntp.conf' " 
    cat /etc/ntp.conf.bak > /etc/ntp.conf
fi

if [ "$( diff -q /etc/ntp.conf.bak /etc/ntp.conf )" ] ; then
    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
    echo "$( diff -u -B /etc/ntp.conf.bak /etc/ntp.conf)"
    cat /etc/ntp.conf.bak > /etc/ntp.conf
    sudo service ntp restart
fi
