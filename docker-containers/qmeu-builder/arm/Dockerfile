# Emby Server
FROM scratch
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>
ENV LANG="en_US.UTF-8"

ADD rootfs.tar.xz /

COPY usr/ /

ENTRYPOINT ["/init"]
