FROM scratch
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>
ARG ARCH=x86_64
ENV LC_ALL="C.utf8"

ADD rootfs.tar.xz    /
ADD overlay-${ARCH}  /
COPY overlay-common  /
COPY usr /usr/
