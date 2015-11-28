#!/bin/bash
set -e

PACKAGE_NAME=$1
PACKAGE_NAME=${PACKAGE_NAME-embymagick}
VERSION="8:6.9.2-7"

build_imagemagick() {
  prep_source
  build_package
}

prep_debfiles() {
  # debianize source
  mv /var/cache/buildarea/debfiles /var/cache/buildarea/imagemagick-source/debian
  create_changelog
}

prep_source() {
  if [ ! -d /var/cache/buildarea/imagemagick-source ]; then
    mkdir -p /var/cache/buildarea/imagemagick-source
  fi
  tar -xvf /var/cache/source/ImageMagick.tar.gz -C /var/cache/buildarea/imagemagick-source --strip-components=1
  # debianize source
  prep_debfiles
  produce_obsfiles
}

produce_obsfiles() {
  # deliver deb files for obs
  mkdir -p /pkg/obs
  tar -cvzf /pkg/obs/debian.tar.gz /var/cache/buildarea/imagemagick-source/debian
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
  debuild -uc -us -b
}

build_imagemagick
