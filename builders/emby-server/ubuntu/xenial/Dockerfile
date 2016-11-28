FROM ubuntu:16.04
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && wget -qO - http://download.opensuse.org/repositories/home:hurricanehernandez:emby-server/xUbuntu_16.04/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/hurricanehernandez:/emby-server/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	adduser \
	build-essential \
	cli-common-dev \
	curl \
	debhelper \
	devscripts \
	embymagick \
	equivs \
	git \
	git \
	git-buildpackage \
	libbz2-1.0 \
	libc6 \
	libfftw3-double3 \
	libgdiplus \
	libjbig0 \
	libjpeg8 \
	liblcms2-2 \
	libltdl7 \
	liblzma5 \
	libembysqlite3-0 \
	libmediainfo0v5 \
	libmono-cil-dev \
	libpng16-16 \
	libtiff5 \
	libwebp5 \
	lsb-release \
	make \
	mono-devel \
	mono-xbuild \
	openssh-client \
	po-debconf \
	pristine-tar \
	referenceassemblies-pcl \
	rsync \
	sqlite3 \
	sudo \
	systemd \
	wget \
	zlib1g \
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
