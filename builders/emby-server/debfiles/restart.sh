#!/bin/bash

NAME=emby-server

restart_cmds=("s6-svc -t /var/run/s6/services/${NAME}" \
  "systemctl restart ${NAME}" \
  "service ${NAME} restart" \
  "/etc/init.d/${NAME} restart" \
  "invoke-rc.d ${NAME} restart")

PIDFILE=`find /var/run -name "emby*.pid" -print -quit`
[ -n "$PIDFILE" ] && EMBY_PID=`cat ${PIDFILE} 2> /dev/null || true`

for restart_cmd in "${restart_cmds[@]}"; do
  cmd=$(echo "$restart_cmd" | awk '{print $1}')
  cmd_loc=$(command -v ${cmd})
  if [ -n $cmd_loc ]; then
    exec sudo $restart_cmd > /dev/null 2>&1 || true
  fi
done
