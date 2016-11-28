FROM ubuntu:16.10
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	adduser \
	build-essential \
	chrpath \
	curl \
	debhelper \
	devscripts \
	dh-autoreconf \
	equivs \
	git \
	gsfonts \
	libbz2-dev \
	libexif-dev \
	libfftw3-dev \
	libfontconfig1-dev \
	libfreetype6-dev \
	libjasper-dev \
	libjpeg-dev \
	liblcms2-dev \
	liblqr-1-0-dev \
	libltdl-dev \
	liblzma-dev \
	libpng-dev \
	libsqlite3-dev \
	libtiff5-dev \
	libwebp-dev \
	libxml2-utils \
	lsb-release \
	make \
	pkg-config \
	po-debconf \
	pristine-tar \
	rsync \
	sudo \
	vim \
	wget \
	xsltproc \
	zlib1g-dev

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts
# copy source
COPY source/ /var/cache/source

ENTRYPOINT ["/sbin/entrypoint.sh"]
