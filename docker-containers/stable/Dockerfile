# Emby Server
FROM emby/emby-base:x86_64
ARG ARCH=latest
ENV APP_NAME="emby-server" IMG_NAME="embyserver" TAG_NAME="${ARCH}" PKG_NAME="emby-server" EDGE=0 UMASK=002


VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
