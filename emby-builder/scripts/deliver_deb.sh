#!/bin/bash
set -e

cp /var/cache/*.deb /pkg
# create obs files
mkdir -p /pkg/obs
mv /var/cache/emby-source/debian/emby /pkg/obs/debian.emby
mv /var/cache/emby-source/debian/emby-server.conf /pkg/obs/debian.emby-server.conf
mv /var/cache/emby-source/debian/${PACKAGE_NAME}.emby-server.service /pkg/obs/debian.${PACKAGE_NAME}.emby-server.service
mv /var/cache/emby-source/debian/${PACKAGE_NAME}.emby-server.default /pkg/obs/debian.${PACKAGE_NAME}.emby-server.default
mv /var/cache/emby-source/debian/restart.sh /pkg/obs/debian.restart.sh
tar -cvzf /pkg/obs/debian.tar.gz /var/cache/emby-source/debian
