# Qemu Builder for arm archs
FROM scratch
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>
ENV LANG="en_US.UTF-8"

ADD rootfs.tar.xz /

COPY usr/ /

ENTRYPOINT ["/init"]
WORKDIR /var/tmp/build-root
CMD make && tar cJvf /ffmpeg_$(uname -m).tar.xz -C /var/tmp/ffmpeg .
