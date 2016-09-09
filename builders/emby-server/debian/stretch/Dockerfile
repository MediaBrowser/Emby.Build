FROM debian:sid
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget gnupg \
 && apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list.d/mono-xamarin.list \
 && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" >>  /etc/apt/sources.list.d/mono-xamarin.list \
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
	libmediainfo0v5 \
	libmono-cil-dev \
	libsqlite3-dev \
	lsb-release \
	make \
	mono-devel \
	mono-xbuild \
	openssh-client \
	po-debconf \
	pristine-tar \
	procps \
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
