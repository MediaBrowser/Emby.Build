FROM debian:stretch
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list.d/mono-xamarin.list \
 && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" >>  /etc/apt/sources.list.d/mono-xamarin.list \
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
    pristine-tar \
    rsync \
    wget \
	mono-xbuild \
	mono-devel \
	libmediainfo0v5 \
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
