#!/bin/bash



# Checking the operation of ntp. Проверка работы ntp 
if ! [ "$( ntpq -p )" ] ; then
    echo "NOTICE: ntp is not running" 
    sudo service ntp start
fi
# Check for ntp.conf.bak Error, exit. Проверка наличия ntp.conf.bak Ошибка, выход.
if ! [ -f /etc/ntp.conf.bak ] ; then 
    echo "Error: ntp_verify: no file /etc/ntp.conf.bak" >&2
    exit 1
fi
# Check for ntp.conf. Overwriting. Проверка наличия ntp.conf. Перезапись
if ! [ -f /etc/ntp.conf ] ; then 
    echo "NOTICE: No file '/etc/ntp.conf' " 
    cat /etc/ntp.conf.bak > /etc/ntp.conf
fi
# Verifying the Conformity of Configuration Files. Проверка соответствий файлов конфигурации
if [ "$( diff -q /etc/ntp.conf.bak /etc/ntp.conf )" ] ; then
    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
    echo "$( diff -u -B /etc/ntp.conf.bak /etc/ntp.conf)"
    cat /etc/ntp.conf.bak > /etc/ntp.conf
    sudo service ntp restart
fi
# Second check (after overwriting) of configuration file matches.
# Вторая проверка (после перезаписи) соответствий файлов конфигурации
if [ "$( diff -q /etc/ntp.conf.bak /etc/ntp.conf )" ] ; then
    echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
    echo "$( diff -u -B /etc/ntp.conf.bak /etc/ntp.conf)"
    cat /etc/ntp.conf.bak > /etc/ntp.conf
    sudo service ntp restart
fi
# Error . Не удалось изменить файл ntp.conf
if [ "$( diff -q /etc/ntp.conf.bak /etc/ntp.conf )" ] ; then
    echo "Error: ntp_verify: Can not modify ntp.conf file" >&2
    exit 1
fi
