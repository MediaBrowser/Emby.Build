# Emby Server
FROM emby/emby-base
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

RUN apt-get update -qq \
 && apt-get download emby-server > /dev/null 2>& 1\
 && dpkg --force-all -i emby-server*.deb \
 && rm *.deb \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/init"]
