#!/bin/bash
set -e

PACKAGE_NAME=$1
PACKAGE_NAME=${PACKAGE_NAME-embymagick}
VERSION="8:7.0.3-6"

build_imagemagick() {
  prep_source
  build_package
}


prep_source() {
  cp /var/cache/source/embymagick*.orig.tar.gz /var/cache/buildarea/
}

produce_obsfiles() {
  # deliver deb files for obs
  mkdir -p /pkg/obs
  cp /var/cache/buildarea/*.spec /pkg/obs
}


build_package() {
  cd /var/cache/buildarea/
  produce_obsfiles
}

build_imagemagick
