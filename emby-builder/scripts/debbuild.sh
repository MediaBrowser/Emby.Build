#!/bin/bash
set -e

EMBY_PACKAGES=(mediabrowser emby emby-server-beta emby-server-dev emby-server)
PACKAGE_NAME=""
VERSION=""
COMMIT=""

build_emby() {
  prep_debfiles
  prep_source
  create_changelog
  build_package
}

prep_debfiles() {
  # rename package
  sed -i -e s%"Package: emby-server"%"Package: ${PACKAGE_NAME}"%1 /var/cache/debfiles/control
  sed -i -e s%"Source: emby-server"%"Source: ${PACKAGE_NAME}"%1 /var/cache/debfiles/control
  # update conflicts, breaks and replaces
  conflicting_packages="$(get_conflicts $PACKAGE_NAME)"
  sed -i -e s%"\(Replaces: \).*$"%"\1${conflicting_packages}"%1 /var/cache/debfiles/control
  sed -i -e s%"\(Breaks: \).*$"%"\1${conflicting_packages}"%1 /var/cache/debfiles/control
  sed -i -e s%"\(Conflicts: \).*$"%"\1${conflicting_packages}"%1 /var/cache/debfiles/control

  # prep init scripts
  mv /var/cache/debfiles/emby-server.upstart /var/cache/debfiles/${PACKAGE_NAME}.emby-server.upstart
  mv /var/cache/debfiles/emby-server.init /var/cache/debfiles/${PACKAGE_NAME}.emby-server.init
  mv /var/cache/debfiles/emby-server.service /var/cache/debfiles/${PACKAGE_NAME}.emby-server.service
  mv /var/cache/debfiles/emby-server.default /var/cache/debfiles/${PACKAGE_NAME}.emby-server.default

  # fix overrides
  sed -i -e s%"emby-server source"%"${PACKAGE_NAME} source"%g /var/cache/debfiles/source.lintian-overrides
}

prep_source() {
	if [ "$PACKAGE_NAME" == "emby-server-dev" ] || [ "$PACKAGE_NAME" == "emby-server-beta" ]; then
		cd /var/cache/emby-source && git checkout dev
	fi
	COMMIT=$(git --no-pager log --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $1}')
	VERSION=$(git --no-pager log --oneline --all  | grep -e '^.\{7\}\s3.*'|head -1|awk '{print $2}')
	# add short commit hash to beta and dev.
	if [ "$PACKAGE_NAME" == "emby-server-beta" ]; then
		cd /var/cache/emby-source && git checkout $COMMIT
		VERSION=${VERSION}.git${COMMIT}
	elif [ "$PACKAGE_NAME" == "emby-server-dev" ]; then
		COMMIT=$(git log -n 1 --pretty=format:"%h")
		VERSION=${VERSION}.git${COMMIT}
	fi
  # debianize source
	mv /var/cache/debfiles /var/cache/emby-source/debian
}

create_changelog() {
  DEBFULLNAME="HurricaneHrndz" \
    NAME="HurricaneHrndz" \
    DEBEMAIL="hurricanehrndz@techbyte.ca" \
    dch --create -v $VERSION --package $PACKAGE_NAME "Automatic build."
}

build_package() {
  cd /var/cache/emby-source
  gbp buildpackage --git-ignore-branch --git-ignore-new --git-builder=debuild -i.git -I.git -uc -us -b
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
