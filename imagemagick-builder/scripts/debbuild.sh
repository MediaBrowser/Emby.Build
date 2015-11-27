#!/bin/bash
set -e

PACKAGE_NAME=""
VERSION=""
COMMIT=""

build_imagemagick() {
  prep_source
  build_package
}

prep_debfiles() {
  # debianize source
  prep_debfiles
  mv /var/cache/buildarea/debfiles /var/cache/buildarea/imagemagick-source/debian
  create_changelog
}

prep_source() {
  tar -xvf /var/cache/source/ImageMagick.tar.gz -C /var/cache/buildarea/imagemagick-source
  # debianize source
  prep_debfiles
  #produce_obsfiles
}

produce_obsfiles() {
# deliver deb files for obs
mkdir -p /pkg/obs
}

create_changelog() {
  DEBFULLNAME="HurricaneHrndz" \
    NAME="HurricaneHrndz" \
    DEBEMAIL="hurricanehrndz@techbyte.ca" \
    dch --create -v $VERSION --package $PACKAGE_NAME "Automatic build."
}

build_package() {
  cd /var/cache/buildarea/imagemagick-source
  debuild -uc -us -b
}

build_imagemagick
