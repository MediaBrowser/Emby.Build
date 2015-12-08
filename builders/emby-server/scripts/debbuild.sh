#!/bin/bash
set -e

EMBY_PACKAGES=(mediabrowser emby emby-server-beta emby-server-dev emby-server)
PACKAGE_NAME=""
VERSION=""
COMMIT=""

build_emby() {
  prep_source
  build_package
}

prep_debfiles() {
  # rename package
  sed -i -e s%"Package: emby-server"%"Package: ${PACKAGE_NAME}"%1 /var/cache/buildarea/debfiles/control
  sed -i -e s%"Source: emby-server"%"Source: ${PACKAGE_NAME}"%1 /var/cache/buildarea/debfiles/control
  # update conflicts, breaks and replaces
  conflicting_packages="$(get_conflicts $PACKAGE_NAME)"
  sed -i -e s%"\(Replaces: \).*$"%"\1${conflicting_packages}"%1 /var/cache/buildarea/debfiles/control
  sed -i -e s%"\(Breaks: \).*$"%"\1${conflicting_packages}"%1 /var/cache/buildarea/debfiles/control
  sed -i -e s%"\(Conflicts: \).*$"%"\1${conflicting_packages}"%1 /var/cache/buildarea/debfiles/control

  # prep init scripts
  mv /var/cache/buildarea/debfiles/emby-server.upstart /var/cache/buildarea/debfiles/${PACKAGE_NAME}.emby-server.upstart
  mv /var/cache/buildarea/debfiles/emby-server.init /var/cache/buildarea/debfiles/${PACKAGE_NAME}.emby-server.init
  mv /var/cache/buildarea/debfiles/emby-server.service /var/cache/buildarea/debfiles/${PACKAGE_NAME}.emby-server.service
  mv /var/cache/buildarea/debfiles/emby-server.default /var/cache/buildarea/debfiles/${PACKAGE_NAME}.emby-server.default

  # fix overrides
  sed -i -e s%"emby-server source"%"${PACKAGE_NAME} source"%g /var/cache/buildarea/debfiles/source.lintian-overrides
}

prep_source() {
  git clone https://github.com/MediaBrowser/Emby.git /var/cache/buildarea/emby-source
  cd /var/cache/buildarea/emby-source
  if [ "$PACKAGE_NAME" == "emby-server-dev" ] || [ "$PACKAGE_NAME" == "emby-server-beta" ]; then
    git checkout dev
  fi
  # add short commit hash to beta and dev.
  if [ "$PACKAGE_NAME" == "emby-server-beta" ]; then
    COMMIT=$(git --no-pager log --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $1}')
    VERSION=$(git --no-pager log --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $2}')
    # switch to the last beta release
    git checkout $COMMIT
    VERSION=${VERSION}.git${COMMIT}
  elif [ "$PACKAGE_NAME" == "emby-server-dev" ]; then
    VERSION=$(git --no-pager log --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $2}')
    COMMIT=$(git log -n 1 --pretty=format:"%h")
    VERSION=${VERSION}.git${COMMIT}
  else
    VERSION=$(git --no-pager log master --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $2}')
  fi
  # debianize source
  prep_debfiles
  mv /var/cache/buildarea/debfiles /var/cache/buildarea/emby-source/debian
  create_changelog
  produce_obsfiles
}

produce_obsfiles() {
# deliver deb files for obs
mkdir -p /pkg/obs
#cp /var/cache/buildarea/emby-source/debian/emby /pkg/obs/debian.emby
#cp /var/cache/buildarea/emby-source/debian/emby-server.conf /pkg/obs/debian.emby-server.conf
#cp /var/cache/buildarea/emby-source/debian/${PACKAGE_NAME}.emby-server.service /pkg/obs/debian.${PACKAGE_NAME}.emby-server.service
#cp /var/cache/buildarea/emby-source/debian/${PACKAGE_NAME}.emby-server.default /pkg/obs/debian.${PACKAGE_NAME}.emby-server.default
#cp /var/cache/buildarea/emby-source/debian/restart.sh /pkg/obs/debian.restart.sh

tar -zcvf /pkg/obs/debian.tar.gz debian
}

create_changelog() {
  DEBFULLNAME="HurricaneHrndz" \
    NAME="HurricaneHrndz" \
    DEBEMAIL="hurricanehrndz@techbyte.ca" \
    dch --create -v $VERSION --package $PACKAGE_NAME "Automatic build."
}

build_package() {
  cd /var/cache/buildarea/emby-source
  gbp buildpackage --git-ignore-branch --git-ignore-new --git-builder=debuild -i.git -I.git -uc -us
}

get_conflicts() {
  result=""
  for emby_package in "${EMBY_PACKAGES[@]}"
  do
    if [ "$PACKAGE_NAME" != "${emby_package}" ]; then
      result+="${emby_package}, "
    fi
  done
  echo "${result%, }"
}


PACKAGE_NAME=$1
case "$PACKAGE_NAME" in
  emby-server)
    build_emby $PACKAGE_NAME
    ;;
  emby-server-beta)
    build_emby $PACKAGE_NAME
    ;;
  emby-server-dev)
    build_emby $PACKAGE_NAME
    ;;
  *)
    exec $@
    ;;
esac
