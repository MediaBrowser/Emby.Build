#!/bin/bash

NAME=emby-server

restart_cmds=("/bin/s6-svc -t /var/run/s6/services/${NAME}" \
  "systemctl restart ${NAME}.service" \
  "service ${NAME} restart" \
  "/etc/init.d/${NAME} restart" \
  "invoke-rc.d ${NAME} restart")

PIDFILE=`find /var/run -name "emby*.pid" -print -quit`
[ -n "$PIDFILE" ] && EMBY_PID=`cat ${PIDFILE} 2> /dev/null || true`

for restart_cmd in "${restart_cmds[@]}"; do
  exec /usr/bin/sudo $restart_cmd > /dev/null 2>&1 || true
  sleep 1

  if ! kill -0 $EMBY_PID > /dev/null; then
    break
  fi
done

# is emby still running? Might have been manually started
if kill -0 $EMBY_PID > /dev/null 2>&1; then
  CPIDS=$(pgrep -P $EMBY_PID)
  sleep 2 && kill -KILL $CPIDS
  kill -TERM $CPIDS > /dev/null 2>&1
  # restart it
  exec emby-server start &
fi
