# Emby Server
FROM emby/emby-base:x86_64
ARG ARCH
ENV APP_NAME="emby-server" IMG_NAME="embyserver_beta" TAG_NAME="${ARCH}" STABLE=0 EDGE=0 UMASK=002

RUN VERSION=$(curl -sL https://github.com/mediaBrowser/Emby/releases.atom | grep -A 1 -e 'link.*alternate' | grep -e '    <' | sed 'N;s/\n/ /' | grep 'beta' | head -1 | sed 's%.*/tag/\([^"]*\).*%\1%') \
 && echo "Downloading version: $VERSION" \
 && rm -rf /var/tmp/emby.zip \
 && curl -o /var/tmp/emby.zip -L https://github.com/MediaBrowser/Emby/releases/download/$VERSION/Emby.Mono.zip \
 && rm -rf /usr/lib/emby-server/bin \
 && mkdir -p /usr/lib/emby-server/bin \
 && unzip /var/tmp/emby.zip -d /usr/lib/emby-server/bin \
 && rm -rf /var/tmp/emby.zip \

VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
