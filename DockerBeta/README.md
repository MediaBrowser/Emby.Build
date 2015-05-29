# ![Alt text](https://raw.githubusercontent.com/MediaBrowser/Emby.Resources/master/images/Logos/logo.png "")

## Description:

This is a Dockerfile for "Emby Server Beta" - (http://emby.media/)

## How to use:

```
docker run -d --net=host -v /*your_config_location*:/config -v /*your_media_location*:/media -e TZ=<TIMEZONE> --name=EmbyServer emby/embyserver
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


## Other info:

### Restarting emby

```
docker exec EmbyServer sv restart emby
```	
