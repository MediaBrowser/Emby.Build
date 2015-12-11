# Emby Server
FROM emby/emby-base
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

RUN apt-get update -qq \
 && apt-get install emby-server \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/* \
 && rm -rf /var/tmp/* \
 && userdel -f nobody

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

COPY root /
ENV S6_LOGGING="1"
ENTRYPOINT ["/init"]
