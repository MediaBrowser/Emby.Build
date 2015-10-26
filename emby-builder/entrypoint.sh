#!/bin/bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
BUILD_USER=${BUILD_USER:-build_user}

EMBY_PACKAGES=(mediabrowser emby emby-server-beta emby-server-dev emby-server)
PACKAGE_NAME=""
VERSION=""
COMMIT=""


create_user() {
  # ensure home directory is owned by user
  # and that the profile files exist
  if [[ -d /home/${BUILD_USER} ]]; then
    chown ${USER_UID}:${USER_GID} /home/${BUILD_USER}
    # copy user files from /etc/skel
    cp /etc/skel/.bashrc /home/${BUILD_USER}
    cp /etc/skel/.bash_logout /home/${BUILD_USER}
    cp /etc/skel/.profile /home/${BUILD_USER}
    chown ${USER_UID}:${USER_GID} \
    /home/${BUILD_USER}/.bashrc \
    /home/${BUILD_USER}/.profile \
    /home/${BUILD_USER}/.bash_logout
  fi
  # create group with USER_GID
  if ! getent group ${BUILD_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${BUILD_USER} > /dev/null 2>&1
  fi
  # create user with USER_UID
  if ! getent passwd ${BUILD_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Containerized App User' ${BUILD_USER}
  fi
}

build_emby() {
  prep_debfiles
  download_source
  create_changelog
  cd /var/cache/emby-source
  export DEBFULLNAME="HurricanHrndz <hurricanehrndz@techbyte.ca>"
  gbp buildpackage --git-ignore-branch --git-ignore-new --git-builder=debuild -i.git -I.git -uc -us -b
}

prep_debfiles() {
  # rename package
  sed -i -e s%"Package: emby-server"%"Package: ${PACKAGE_NAME}"%1 /var/cache/debfiles/control
  sed -i -e s%"Source: emby-server"%"Source: ${PACKAGE_NAME}"%1 /var/cache/debfiles/control
  # update conflicts, breaks and replaces
  conflicting_packages="$(clean_packages $PACKAGE_NAME)"
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

download_source() {
	mkdir -p /var/cache/emby-source
	git clone https://github.com/MediaBrowser/Emby.git /var/cache/emby-source
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
	mv /var/cache/debfiles /var/cache/emby-source/debian
}

create_changelog() {
	dch --create -v $VERSION --package $PACKAGE_NAME "Automatic build."
}

clean_packages() {
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
create_user
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

exec bash
