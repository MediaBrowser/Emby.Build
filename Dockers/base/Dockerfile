FROM debian:sid
MAINTAINER hurricanehrndz@techbyte.ca

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 LANG=C.UTF-8 LANGUAGE=C.UTF-8

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01buildconfig \
 && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01buildconfig \
 && echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01buildconfig \
 && sed -i.bak 's/sid main/sid main contrib non-free/g' /etc/apt/sources.list \
 && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 0x782cc96a9bcfd389 \
 && echo 'deb http://download.opensuse.org/repositories/home:/hurricanehernandez/Debian_8.0/ /' >> /etc/apt/sources.list.d/emby.list \
 && apt-get update \
 && apt-get install -y -qq --no-install-recommends \
    sudo \
    ca-certificates \
    libembymagickwand-6.q8-2 \
    libembymagickcore-6.q8-2 \
    libsqlite3-0 \
    libmono-csharp4.0c-cil \
    libmono-system-data4.0-cil \
    libmono-microsoft-csharp4.0-cil \
    libmono-system-io-compression4.0-cil \
	libmono-system-runtime-serialization4.0-cil \
	libmono-system-data-linq4.0-cil \
    libmono-system-drawing4.0-cil \
    libmono-system-servicemodel4.0a-cil \
    libmono-system-web4.0-cil \
    libmono-system-xml-linq4.0-cil \
	mono-devel \
    mediainfo \
	locales \
    xz-utils \
	psmisc \
 && apt-get clean \
 && apt-get autoclean \
 && locale-gen C.UTF-8 \
 && dpkg-reconfigure locales \
 && rm -rf mono-devel*.deb \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/share/man/* \
 && rm -rf /usr/share/doc/* \
 && rm -rf /lib/systemd/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.17.0.0/s6-overlay-amd64.tar.gz /tmp/
ADD http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz /tmp/
# Install process supervisor
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
# Install static build of ffmpeg
 && tar xf /tmp/ffmpeg-release-64bit-static.tar.xz -C /tmp --strip-components=1 \
 && cp /tmp/ffmpeg /bin \
 && cp /tmp/ffprobe /bin \
 && cp /tmp/ffmpeg-10bit /bin \
 && rm -rf /tmp/*
