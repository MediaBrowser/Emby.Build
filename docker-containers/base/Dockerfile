FROM scratch
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>
ARG ARCH=x86_64
ENV LC_ALL="C.utf8"

ADD rootfs.tar.xz    /
ADD overlay-common   /
ADD overlay-${ARCH}  /
COPY usr /usr/
