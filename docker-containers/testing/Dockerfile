# Emby Server
FROM emby/emby-base
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

RUN zypper --quiet --non-interactive ar obs://home:hurricanehernandez/openSUSE_Tumbleweed emby \
 && zypper --quiet --non-interactive ref -f emby \
 && zypper --quiet --non-interactive in emby-server-dev


VOLUME [ "/config" ]
EXPOSE 8096 8920 7359/udp 1900/udp

COPY root /
#ENV S6_LOGGING="1"
ENTRYPOINT ["/init"]
