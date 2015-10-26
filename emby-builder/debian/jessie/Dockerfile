FROM debian:jessie
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && wget -qO - http://download.opensuse.org/repositories/home:emby/Debian_8.0/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/emby/Debian_8.0/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list.d/mono-xamarin.list \
 && apt-get update \
 && apt-get upgrade \
 && apt-get install -y \
    build-essential \
    curl \
    devscripts \
    equivs \
    git-buildpackage \
    git \
    lsb-release \
    make \
    openssh-client \
	libmagickwand-6.q8-2 \
    pristine-tar \
    rsync \
    wget \
	mono-xbuild \
	mono-devel \
	libmediainfo0 \
	po-debconf \
	libsqlite3-dev \
	debhelper \
	libmono-cil-dev

# copy debian files
COPY debfiles /var/cache/debfiles
# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
