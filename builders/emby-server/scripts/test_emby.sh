#!/bin/bash
set -e

dpkg -i /var/cache/buildarea/*.deb
/usr/bin/emby-server start &
PID=$?
  sleep 120
http_result="0"
http_result=$(curl -sL -w "%{http_code}" "http://localhost:8096" -o /dev/null)
if [ "$http_result" == "200" ]; then
  CPIDS=$(pgrep -P $PID)
  sleep 2 && kill -KILL $CPIDS
  exit 0
else
  exit 1
fi
