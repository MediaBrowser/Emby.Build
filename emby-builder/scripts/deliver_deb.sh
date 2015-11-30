#!/bin/bash
set -e

PACKAGE_NAME=$1
cp /var/cache/buildarea/*.deb /pkg
cp /var/cache/buildarea/*.dsc /pkg
