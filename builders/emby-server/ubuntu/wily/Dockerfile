FROM ubuntu:wily
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_15.10/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_15.10/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    systemd \
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
    pristine-tar \
    rsync \
    wget \
	mono-xbuild \
	mono-devel \
	libembymagickwand-6.q8-2 \
	libmediainfo0v5 \
	po-debconf \
	libsqlite3-dev \
	debhelper \
	libmono-cil-dev \
	cli-common-dev \
	libbz2-1.0 \
	libc6 \
	libfftw3-double3 \
	libjbig0 \
	libjpeg8 \
	liblcms2-2 \
	libltdl7 \
	liblzma5 \
	libpng12-0 \
	libtiff5 \
	libwebp5 \
	zlib1g \
	sqlite3 \
 && (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) \
 && rm -f /lib/systemd/system/multi-user.target.wants/* \
 && rm -f /etc/systemd/system/*.wants/* \
 && rm -f /lib/systemd/system/local-fs.target.wants/* \
 && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
 && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
 && rm -f /lib/systemd/system/basic.target.wants/* \
 && rm -f /lib/systemd/system/anaconda.target.wants/*

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts


ENTRYPOINT ["/sbin/entrypoint.sh"]
