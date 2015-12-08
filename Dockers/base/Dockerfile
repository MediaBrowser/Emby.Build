FROM debian:sid
MAINTAINER hurricanehrndz@techbyte.ca

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && sed -i.bak 's/sid main/sid main contrib non-free/g' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y -qq \
    vim.tiny \
    wget \
    sudo \
    net-tools \
    ca-certificates \
    unzip \
    locales \
 && dpkg-reconfigure locales \
 && locale-gen C.UTF-8  \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && rm -rf /var/lib/apt/lists/*
