FROM debian:jessie
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && wget -qO - http://download.opensuse.org/repositories/home:emby/Debian_8.0/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/emby/Debian_8.0/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    git \
    adduser \
    sudo \
    build-essential \
    libgdiplus \
    curl \
    devscripts \
    equivs \
    git-buildpackage \
    git \
    lsb-release \
    make \
    openssh-client \
    libembymagickwand-6.q8-2 \
    pristine-tar \
    rsync \
    wget \
    mono-xbuild \
    mono-devel \
    libmediainfo0 \
    po-debconf \
    libsqlite3-dev \
    debhelper \
    libmono-cil-dev \
    cli-common-dev \
    sqlite3

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts

ENTRYPOINT ["/sbin/entrypoint.sh"]
