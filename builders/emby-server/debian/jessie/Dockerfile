FROM debian:jessie
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && wget -qO - http://download.opensuse.org/repositories/home:/emby/Debian_8.0/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/emby/Debian_8.0/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	adduser \
	build-essential \
	cli-common-dev \
	curl \
	debhelper \
	devscripts \
	equivs \
	git \
	git \
	git-buildpackage \
	libgdiplus \
	libmediainfo0 \
	libmono-cil-dev \
	libsqlite3-dev \
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
	wget

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts

ENTRYPOINT ["/sbin/entrypoint.sh"]
