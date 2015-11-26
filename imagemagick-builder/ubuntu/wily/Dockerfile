FROM ubuntu:wily
MAINTAINER HurricaneHrndz <carlos@techbyte.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y wget \
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
	po-debconf \
	libsqlite3-dev \
	debhelper \
	cli-common-dev \
	sqlite3

# copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
# copy debian files
COPY debfiles/ /var/cache/buildarea/debfiles
# copy scripts
COPY scripts/ /var/cache/scripts
# copy source
COPY source/ /var/cache/source

ENTRYPOINT ["/sbin/entrypoint.sh"]
