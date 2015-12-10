# Emby Server
FROM emby/emby-base
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

RUN apt-get update -qq \
 && apt-get install emby-server \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/* \
 && rm -rf /var/tmp/* \

VOLUME [  "/var/lib/emby-server", "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
