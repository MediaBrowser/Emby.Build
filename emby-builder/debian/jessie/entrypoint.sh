#!/bin/bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
BUILD_USER=${BUILD_USER:-build_user}

EMBY_PACKAGES=(mediabrowser emby emby-server-beta emby-server-dev emby-server)


create_user() {
  # ensure home directory is owned by user
  # and that the profile files exist
  if [[ -d /home/${BUILD_USER} ]]; then
  ¦ chown ${USER_UID}:${USER_GID} /home/${BUILD_USER}
  ¦ # copy user files from /etc/skel
  ¦ cp /etc/skel/.bashrc /home/${BUILD_USER}
  ¦ cp /etc/skel/.bash_logout /home/${BUILD_USER}
  ¦ cp /etc/skel/.profile /home/${BUILD_USER}
  ¦ chown ${USER_UID}:${USER_GID} \
  ¦ /home/${BUILD_USER}/.bashrc \
  ¦ /home/${BUILD_USER}/.profile \
  ¦ /home/${BUILD_USER}/.bash_logout
  fi
  # create group with USER_GID
  if ! getent group ${BUILD_USER} >/dev/null; then
  ¦ groupadd -f -g ${USER_GID} ${BUILD_USER} 2>&1 /dev/null
  fi
  # create user with USER_UID
  if ! getent passwd ${BUILD_USER} >/dev/null; then
  ¦ adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
  ¦ ¦ --gecos 'Containerized App User' ${BUILD_USER}
  fi
}

build_emby() {
  prep_debfiles
}

prep_debfiles() {
  # rename package
  sed -i -e s%"Package: emby-server"%"Package: $1"%1 /var/cache/debfiles/control
  # update conflicts, breaks and replaces
  conflicting_pacakges=$(clean_packages $1)
  sed -i -e s%"\(Replaces: \).*$"%"\1${conflicting_pacakges}"%1 /var/cache/debfiles/control
  sed -i -e s%"\(Breaks: \).*$"%"\1${conflicting_pacakges}"%1 /var/cache/debfiles/control
  sed -i -e s%"\(Conflicts: \).*$"%"\1${conflicting_pacakges}"%1 /var/cache/debfiles/control

  # prep init scripts
  mv /var/cache/debfiles/emby-server.upstart /var/cache/debfiles/${1}.emby-server.upstart
  mv /var/cache/debfiles/emby-server.init /var/cache/debfiles/${1}.emby-server.init
  mv /var/cache/debfiles/emby-server.service /var/cache/debfiles/${1}.emby-server.service
  mv /var/cache/debfiles/emby-server.default /var/cache/debfiles/${1}.emby-server.default

  # fix overrides
  sed -i -e s%"emby-server source"%"${1} source"%g /var/cache/debfiles/source.lintian-overrides
}

clean_packages() {
  result=""
  for emby_package in "${EMBY_PACKAGES[@]}"
  do
    if [ "$i" != $1 ]; then
      result+="${i}, "
    fi
  done
  result=${result%, }
  return result
}

create_user
case "$1" in
	emby-server)
    build_emby $1
		;;
	emby-server-beta)
    build_emby $1
		;;
	emby-server-dev)
    build_emby $1
		;;
	*)
		exec $@
		;;
esac

exec bash
