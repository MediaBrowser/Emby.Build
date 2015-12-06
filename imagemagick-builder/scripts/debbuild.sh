#!/bin/bash
set -e

PACKAGE_NAME=$1
PACKAGE_NAME=${PACKAGE_NAME-embymagick}
VERSION="8:6.9.2-8"

build_imagemagick() {
  prep_source
  build_package
}

prep_debfiles() {
  # debianize source
  mkdir -p /var/cache/buildarea/imagemagick-source/debian
  mv /var/cache/buildarea/debfiles /var/cache/buildarea/debian
  cp -r /var/cache/buildarea/debian /var/cache/buildarea/imagemagick-source/
  create_changelog
}

prep_source() {
  if [ ! -d /var/cache/buildarea/imagemagick-source ]; then
    mkdir -p /var/cache/buildarea/imagemagick-source
  fi
  cp /var/cache/source/embymagick*.orig.tar.gz /var/cache/buildarea/
  tar -xvf /var/cache/source/embymagick*.orig.tar.gz -C /var/cache/buildarea/imagemagick-source --strip-components=1
  # debianize source
  prep_debfiles
}

produce_obsfiles() {
  # deliver deb files for obs
  mkdir -p /pkg/obs
  tar -cvzf /pkg/obs/debian.tar.gz /var/cache/buildarea/debian
  cp /var/cache/buildarea/embymagick*.orig.tar.gz /pkg/obs
  cp /var/cache/buildarea/*.dsc /pkg/obs
  cp /var/cache/buildarea/*.debian.* /pkg/obs
}

create_changelog() {
  CODENAME=$(lsb_release -c | awk -F ":" '{print $2}')
  cd /var/cache/buildarea/imagemagick-source
  DEBFULLNAME="HurricaneHrndz" \
    NAME="HurricaneHrndz" \
    DEBEMAIL="hurricanehrndz@techbyte.ca" \
    dch --create -v $VERSION \
	--distribution $CODENAME \
	--package $PACKAGE_NAME "Automatic build."
}

build_package() {
  cd /var/cache/buildarea/imagemagick-source
  exec bash
  debuild -uc -us
  produce_obsfiles
}

build_imagemagick
