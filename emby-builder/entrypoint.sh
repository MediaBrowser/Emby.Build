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
  prep_source
  exec sudo --preserve-env -u ${BUILD_USER} create_changelog
  exec sudo --preserve-env -u ${BUILD_USER} build_package
  exec sudo --preserve-env -u ${BUILD_USER} install_package
  exec sudo --preserve-env -u ${BUILD_USER} test_package
  exec sudo --preserve-env -u ${BUILD_USER} deliver_package
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
	mv /var/cache/debfiles /var/cache/emby-source/debian
	chown -R $USER_UID:$USER_GID /var/cache/emby-source
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

install_package() {
  dpkg -i /var/cache/*.deb
}

test_package() {
    /usr/bin/emby-server start &
	PID=$?
    sleep 120
	http_result="0"
	http_result=$(curl -sL -w "%{http_code}" "http://localhost:8096" -o /dev/null)
	if [ "$http_result" == "200" ]; then
		echo "Package was built successfully."
	else
		echo "Package is deffective."
	fi
    CPIDS=$(pgrep -P $PID)
    sleep 2 && kill -KILL $CPIDS
}

deliver_package() {
	cp /var/cache/*.deb /pkg
	# create obs files
	mkdir -p /pkg/obs
	mv /var/cache/emby-source/debian/emby /pkg/obs/debian.emby
	mv /var/cache/emby-source/debian/emby-server.conf /pkg/obs/debian.emby-server.conf
	mv /var/cache/emby-source/debian/${PACKAGE_NAME}.emby-server.service /pkg/obs/debian.${PACKAGE_NAME}.emby-server.service
	mv /var/cache/emby-source/debian/${PACKAGE_NAME}.emby-server.default /pkg/obs/debian.${PACKAGE_NAME}.emby-server.default
	mv /var/cache/emby-source/debian/restart.sh /pkg/obs/debian.restart.sh
	tar -cvzf /pkg/obs/debian.tar.gz /var/cache/emby-source/debian
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
