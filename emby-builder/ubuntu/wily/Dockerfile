FROM ubuntu:wily
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list.d/mono-xamarin.list \
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
	sqlite3

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts
# copy emby build of imagemagick
COPY debs/ /var/cache/embymagick

RUN dpkg -i /var/cache/embymagick/*.deb

ENTRYPOINT ["/sbin/entrypoint.sh"]
