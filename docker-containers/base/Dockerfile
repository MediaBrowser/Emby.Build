FROM scratch
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>
ARG ARCH
ENV LC_ALL="C.utf8"

ADD rootfs.tar.xz    /
ADD overlay-${ARCH}  /
COPY overlay-common  /
COPY usr /usr/
