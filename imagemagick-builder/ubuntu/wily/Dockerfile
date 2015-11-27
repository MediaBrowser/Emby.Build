FROM ubuntu:wily
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	git \
	vim \
	adduser \
	sudo \
    build-essential \
	curl \
    devscripts \
    equivs \
    git-buildpackage \
    git \
    lsb-release \
    make \
    pristine-tar \
    rsync \
    wget \
	po-debconf \
	libsqlite3-dev \
	debhelper \
	cli-common-dev \
	chrpath \
	libfftw3-dev \
	liblcms2-dev \
	liblqr-1-0-dev \
	zlib1g-dev \
	liblzma-dev \
	libbz2-dev \
	libexif-dev \
	libjasper-dev \
	libjpeg-dev \
	libpng12-dev \
	libtiff5-dev \
	libwebp-dev \
	libltdl-dev \
	dh-autoreconf \
	xsltproc \
	autotools \
	libxml2-utils

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts
# copy source
COPY source/ /var/cache/source

ENTRYPOINT ["/sbin/entrypoint.sh"]
