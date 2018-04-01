#!/bin/bash

# Permission to run executable code. Разрешение на запуск
chmod +x ntp_deploy.sh
chmod +x ntp_verify.sh
# Specifies the current folder. Определяет текущую папку
wayprog=$(pwd)
# Checks ntp package. Проверяет наличее пакета ntp
indpkg=$( dpkg --get-selections | grep 'ntp' | grep -m 1 'ntp' | awk '{print $2}' )
if [ -n "$indpkg" ] ; then
    # Checks if the package is installed. Проверяет установлен ли пакет
    if [[ "$indpkg" != "install" ]] ; then
        sudo apt-get -y install ntp
    fi
else
    # Installs the package. Устанавливает пакет
    sudo apt-get -y install ntp
fi
# Checks ntp.conf. Проверяет наличее ntp.conf
if ! [ -f /etc/ntp.conf ] ;then 
    echo "Error: ntp_deploy: There is no /etc/ntp.conf file" >&2 
    exit 1
fi
# Modifies ntp.conf. Изменяет ntp.conf
( sed '/pool 0/ c\pool 0.ua.pool.ntp.org' /etc/ntp.conf ) > temp.txt
( sed '/pool 1/ c\pool 1.ua.pool.ntp.org' temp.txt ) > /etc/ntp.conf.bak
( sed '/pool 2/ c\pool 2.ua.pool.ntp.org' /etc/ntp.conf.bak ) > temp.txt
( sed '/pool 3/ c\pool 3.ua.pool.ntp.org' temp.txt ) > /etc/ntp.conf.bak
( sed '/pool ntp/ c\pool ua.pool.ntp.org' /etc/ntp.conf.bak ) > temp.txt
cat temp.txt > /etc/ntp.conf.bak
rm -f temp.txt

cat /etc/ntp.conf.bak > /etc/ntp.conf
# Restarts ntp. Перезапускает ntp
sudo service ntp restart

# ntp_verify.sh
# Adds a task to the scheduler. Дописывает задание в планировщик
sudo echo > /var/spool/cron/root
echo "*/1 * * * * $wayprog/ntp_verify.sh" >> /var/spool/cron/root
echo >> /var/spool/cron/root

crontab -u root /var/spool/cron/root
# Restarts the scheduler. Перезапускает планировщик
service cron reload
# Checks for the presence of ntp_verify.sh  Проверяет наличие ntp_verify.sh
if [ -f ntp_verify.sh ] ; then
    exit 0
else
    echo "ntp_deploy.sh: No ntp_verify.sh file" >&2
    exit 1
fi
exit 1
