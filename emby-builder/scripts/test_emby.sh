#!/bin/bash
set -e

dpkg -i /var/cache/*.deb
/usr/bin/emby-server start &
PID=$?
  sleep 120
http_result="0"
http_result=$(curl -sL -w "%{http_code}" "http://localhost:8096" -o /dev/null)
if [ "$http_result" == "200" ]; then
  echo "Package was built successfully."
else
  echo "Package is deffective."
fi
CPIDS=$(pgrep -P $PID)
sleep 2 && kill -KILL $CPIDS
exit 0
