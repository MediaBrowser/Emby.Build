# Emby Server
FROM emby/emby-base
ENV APP_NAME="emby-server" IMG_NAME="embyserver" TAG_NAME="dev" PKG_NAME="emby-server-dev" EDGE=0 UMASK=002

RUN zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive in $PKG_NAME \
 && zypper cc --all \
 && rm -rf /var/cache/zypp*

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

COPY root /
ENTRYPOINT ["/init"]
