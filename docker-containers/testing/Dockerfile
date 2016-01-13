# Emby Server
FROM emby/emby-base
ENV APP_NAME="emby-server" IMG_NAME_AND_TAG="emby-server:testing" PKG_NAME="emby-server"

RUN zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive in emby-server \
 && zypper cc --all \
 && rm -rf /var/cache/zypp*

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

COPY root /
ENTRYPOINT ["/init"]
