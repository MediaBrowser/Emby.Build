# Emby Server
FROM emby/emby-base:x86_64
ARG ARCH=latest
ENV APP_NAME="emby-server" IMG_NAME="embyserver" TAG_NAME="${ARCH}" PKG_NAME="emby-server" EDGE=0 UMASK=002

RUN zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive in $PKG_NAME \
 && zypper cc --all \
 && rm -rf /var/cache/zypp*

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
