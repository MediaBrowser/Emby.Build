FROM ubuntu:wily
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_15.04/Release.key | apt-key add - \
 && echo 'deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_15.04/ /' >> /etc/apt/sources.list.d/emby-server.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list.d/mono-xamarin.list \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	git \
	adduser \
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
	libmono-cil-dev \
	cli-common-dev \
	sqlite3

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/debfiles

ENTRYPOINT ["/sbin/entrypoint.sh"]
