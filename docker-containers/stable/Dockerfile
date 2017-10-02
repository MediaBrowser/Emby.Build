# Emby Server
FROM emby/emby-base:x86_64
ARG ARCH
ENV APP_NAME="emby-server" IMG_NAME="embyserver" TAG_NAME="${ARCH}" EDGE=0 UMASK=002

RUN VERSION=$(curl -sL https://github.com/mediaBrowser/Emby/releases.atom | grep -A 1 -e 'link.*alternate' | grep -e '    <' | sed 'N;s/\n/ /' | grep -v 'beta' | head -1 | sed 's%.*/tag/\([^"]*\).*%\1%') \
 && echo "Downloading version: $VERSION" \
 && rm -rf /var/tmp/emby.zip \
 && curl -o /var/tmp/emby.zip -L https://github.com/MediaBrowser/Emby/releases/download/$VERSION/Emby.Mono.zip \
 && rm -rf /usr/lib/emby-server/bin \
 && mkdir -p /usr/lib/emby-server/bin \
 && unzip /var/tmp/emby.zip -d /usr/lib/emby-server/bin \
 && curl -L https://raw.githubusercontent.com/MediaBrowser/Emby.Build/master/builders/emby-server/debfiles/restart.sh -o /usr/lib/emby-server/restart.sh \
 && chmod 0755 /usr/lib/emby-server/restart.sh \
 && rm -rf /var/tmp/emby.zip \
 && gawk -i inplace -F: '{ if ( $1 == "root" ) print}' /etc/passwd \
 && gawk -i inplace -F: '{ if ( $1 == "root" ) print}' /etc/group \
 && gawk -i inplace '{print $0; exit; }' /etc/shadow


VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

ENTRYPOINT ["/init"]
