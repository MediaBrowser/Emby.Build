#!/bin/bash
docker run -d --net=host -v /var/lib/emby:/config -v /media:/media -e "TZ=America/Edmonton" --name EmbyServer embyserver
