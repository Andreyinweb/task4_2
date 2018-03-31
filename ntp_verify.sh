#!/bin/bash

sudo echo "$(date)" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del

if ! [ "$( ntpq -p )" ] ; then
    echo "NOTICE: ntp is not running" 
    echo "$(date) NOTICE: ntp is not running" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del
    sudo service ntp start
    echo "RUN ?" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt
fi
 
if ! [ -f /etc/ntp.conf ] ; then 
    echo "Error: ntp_verify: no file /etc/ntp.conf.bak" >&2
    echo "Error: no file /etc/ntp.conf.bak" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del
    exit 1
fi

if ! [ -f /etc/ntp.conf.bak ] ; then 
    echo "NOTICE: No file '/etc/ntp.conf' " 
    echo "$(date) NOTICE: ntp is not running" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del
    cat /etc/ntp.conf.bak > /etc/ntp.conf
fi

if [ "$( diff -q /etc/ntp.conf.bak /etc/ntp.conf )" ] ; then
    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"

    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:" >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del

    echo "$( diff -u -B /etc/ntp.conf.bak /etc/ntp.conf)"

    echo " $( diff -u -B /etc/ntp.conf.bak /etc/ntp.conf ) " >> /home/stariy/andrey/DevOps/task4_2/PROB.txt #del

    # echo "--- /etc/ntp.conf.bak $(stat -c%z /etc/ntp.conf.bak)"
    # echo "+++ /etc/ntp.conf     $(stat -c%z /etc/ntp.conf)"

    # msstr=$( diff -B /etc/ntp.conf.bak /etc/ntp.conf | sed 's/</-/' | sed 's/>/+/' | grep '\- '| sed 's/- //' | wc -m )
    # plusstr=$( diff -B /etc/ntp.conf.bak /etc/ntp.conf | sed 's/</-/' | sed 's/>/+/' | grep '+ '| sed 's/+ //' | wc -m )
    # echo "@ -$(expr $msstr - 1) +$(expr $plusstr - 1) @" 
    
    # diff -B /etc/ntp.conf.bak /etc/ntp.conf | sed 's/</-/' | sed 's/>/+/' | grep '\- '
    # diff -B /etc/ntp.conf.bak /etc/ntp.conf | sed 's/</-/' | sed 's/>/+/' | grep '+ ' 
    cat /etc/ntp.conf.bak > /etc/ntp.conf

    sudo service ntp restart
fi
