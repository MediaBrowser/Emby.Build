#!/bin/bash
set -e

PACKAGE_NAME=$1
\cp /var/cache/buildarea/*.deb /pkg
\cp /var/cache/buildarea/*.dsc /pkg/obs/$PACKAGE_NAME.dsc
{
  echo "Debtransform-Release: 1"
  echo "Debtransform-Files-Tar: debian.tar.gz"
} >> /pkg/obs/$PACKAGE_NAME.dsc
sed -i -e '/Package-List/ { N; d;}' /pkg/obs/$PACKAGE_NAME.dsc
sed -i -e '/Checksums/ { N; d;}' /pkg/obs/$PACKAGE_NAME.dsc
sed -i -e '/Files/,/Debtransform/{s/\(emby-server-dev\)_\([^_]*\)/\1-\2/}' /pkg/obs/$PACKAGE_NAME.dsc
\cp /var/cache/buildarea/*.build /pkg
