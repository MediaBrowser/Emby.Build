# Emby Server
FROM scratch
ADD rootfs.tar.xz /

ENV APP_NAME="emby-server" IMG_NAME="embyserver" TAG_NAME="latest" PKG_NAME="emby-server" LANG="en_US.UTF-8"

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
