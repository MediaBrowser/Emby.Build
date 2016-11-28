#!/bin/bash

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
BUILD_USER=${BUILD_USER:-build_user}

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
      --gecos 'Containerized App User' ${BUILD_USER} > /dev/null 2>&1
  fi
}

build_emby() {
  prep_debfiles
  echo "Building emby-server..."
  sudo -E -u $BUILD_USER /var/cache/scripts/debbuild.sh $PACKAGE_NAME
  /var/cache/scripts/test_emby.sh
  test_result=$?
  if [ "$test_result" == "0" ]; then
    echo "Package was built successfully."
    sudo -E -u $BUILD_USER /var/cache/scripts/deliver_deb.sh $PACKAGE_NAME
  else
    echo "Package was built, but test install failed, emby-server build is deffective."
    echo "Package will not be copied to destination."
    sudo -E -u $BUILD_USER /var/cache/scripts/deliver_deb.sh $PACKAGE_NAME
  fi
}

prep_debfiles() {
  # make sure $BUILD_USER owns files
  mkdir -p /var/cache/buildarea/emby-source
  chown -R $USER_UID:$USER_GID /var/cache/buildarea
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
# for testing
echo "To further test the package run make test and within the container install and start emby-server"
if [ "$DEBUG" == true ]; then
  exec bash
fi
