#!/bin/sh

NAME=emby-server

if which systemctl > /dev/null 2>&1; then
  sudo /bin/systemctl restart ${NAME}.service
elif which service >/dev/null 2>&1; then
  sudo /usr/sbin/service ${NAME} restart
elif which invoke-rc.d >/dev/null 2>&1; then
  sudo /usr/sbin/invoke-rc.d ${NAME} restart
else
  sudo /etc/init.d/${NAME} restart
fi
