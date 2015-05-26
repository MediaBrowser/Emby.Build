#docker Emby Server

## Description:

This is a Dockerfile for "Emby Server" - (http://emby.media/)

## Build from docker file:

```
git clone --depth=1 https://github.com/MediaBrowser/MediaBrowser.git 
rd MediaBrowser/Docker
docker build --rm=true -t mbserver . 
```

## Volumes:

#### `/config`

Configuration files and state of MediaBrowser Server folder. (i.e. /opt/appdata/emby)

## Environment Variables:

### `TZ`

TimeZone. (i.e America/Edmonton)

### `MB_USER_ID`

User ID emby should run under, default is 99 for unRAID compatiability.

### `MB_GROUP_ID`

Group ID emby should run under, default is 100 for unRAID compatiability.

## Docker run command:

```
docker run -d --net=host -v /*your_config_location*:/config -v /*your_media_location*:/media -e TZ=<TIMEZONE> --name=EmbyServer emby/emby

```

## Other info:

### Restarting emby

```
docker exec EmbyServer sv restart emby
```	
