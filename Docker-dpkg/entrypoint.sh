#!/bin/bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
EMBY_SERVER_USER=${EMBY_SERVER_USER:-emby}

install_emby_server() {
# TODO Install emby server on target
	echo "Installing"
}

uninstall_emby_server() {
# TODO Uninstall emby server on target
	echo "Uninstalling"
}

create_user() {
  # ensure home directory is owned by user
  # and that the profile files exist
  if [[ -d /home/${EMBY_SERVER_USER} ]]; then
    chown ${USER_UID}:${USER_GID} /home/${EMBY_SERVER_USER}
    # copy user files from /etc/skel
    cp /etc/skel/.bashrc /home/${EMBY_SERVER_USER}
    cp /etc/skel/.bash_logout /home/${EMBY_SERVER_USER}
    cp /etc/skel/.profile /home/${EMBY_SERVER_USER}
    chown ${USER_UID}:${USER_GID} \
    /home/${EMBY_SERVER_USER}/.bashrc \
    /home/${EMBY_SERVER_USER}/.profile \
    /home/${EMBY_SERVER_USER}/.bash_logout
  fi
  # create group with USER_GID
  if ! getent group ${EMBY_SERVER_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${EMBY_SERVER_USER} 2> /dev/null
  fi
  # create user with USER_UID
  if ! getent passwd ${EMBY_SERVER_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Containerized App User' ${EMBY_SERVER_USER}
  fi
}

launch_virt_manager() {
  cd /home/${EMBY_SERVER_USER}
  exec sudo -HEu ${EMBY_SERVER_USER} $@ --no-fork ${extra_opts}
}

case "$1" in
  install)
    install_virt_manager
    ;;
  uninstall)
    uninstall_virt_manager
    ;;
  build-emby-server)
    create_user
    ;;
  *)
    exec $@
    ;;
esac
