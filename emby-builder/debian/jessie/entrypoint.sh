#!/bin/bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
VIRT_MANAGER_USER=${VIRT_MANAGER_USER:-virtman}

install_virt_manager() {
  echo "Installing virt-manager..."
  install -m 0755 /var/cache/virt-manager/virt-manager /target/
  if [ "${VIRT_MANAGER_USER}" != "virtman" ] && [ -n "${VIRT_MANAGER_USER}" ]; then
    echo "Updating user to ${VIRT_MANAGER_USER}..."
    sed -i -e s%"-virtman"%"-${VIRT_MANAGER_USER}"%1 /target/virt-manager
  fi
  if [[ -n "${VIRT_MANAGER_DATA}" ]]; then
    echo "Updating user volumes..."
    sed -i -e s%"VIRT_MANAGER_DATA=.*$"%"VIRT_MANAGER_DATA\=${VIRT_MANAGER_DATA}"% \
    /target/virt-manager
  fi
}

uninstall_virt_manager() {
  echo "Uninstalling virt-manager wrapper..."
  rm -rf /target/virt-manager-wrapper
  echo "Uninstalling virt-manager..."
  rm -rf /target/virt-manager
}

create_user() {
  # ensure home directory is owned by user
  # and that the profile files exist
  if [[ -d /home/${VIRT_MANAGER_USER} ]]; then
    chown ${USER_UID}:${USER_GID} /home/${VIRT_MANAGER_USER}
    # copy user files from /etc/skel
    cp /etc/skel/.bashrc /home/${VIRT_MANAGER_USER}
    cp /etc/skel/.bash_logout /home/${VIRT_MANAGER_USER}
    cp /etc/skel/.profile /home/${VIRT_MANAGER_USER}
    chown ${USER_UID}:${USER_GID} \
    /home/${VIRT_MANAGER_USER}/.bashrc \
    /home/${VIRT_MANAGER_USER}/.profile \
    /home/${VIRT_MANAGER_USER}/.bash_logout
  fi
  # create group with USER_GID
  if ! getent group ${VIRT_MANAGER_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${VIRT_MANAGER_USER} 2> /dev/null
  fi
  # create user with USER_UID
  if ! getent passwd ${VIRT_MANAGER_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Containerized App User' ${VIRT_MANAGER_USER}
  fi
}

launch_virt_manager() {
  cd /home/${VIRT_MANAGER_USER}
  if [ -f /home/${VIRT_MANAGER_USER}/.virt-manager/id_virt-manager ]; then
    mkdir -p /home/${VIRT_MANAGER_USER}/.ssh
	chown ${VIRT_MANAGER_USER}:${VIRT_MANAGER_USER} /home/${VIRT_MANAGER_USER}/.ssh
    cp /home/${VIRT_MANAGER_USER}/.virt-manager/id_virt-manager /home/${VIRT_MANAGER_USER}/.ssh/id_rsa
	chmod 600 /home/${VIRT_MANAGER_USER}/.ssh/id_rsa
	chown ${VIRT_MANAGER_USER}:${VIRT_MANAGER_USER} /home/${VIRT_MANAGER_USER}/.ssh/id_rsa
  fi
  exec sudo -HEu ${VIRT_MANAGER_USER} $@ --no-fork ${extra_opts}
}

case "$1" in
  install)
    install_virt_manager
    ;;
  uninstall)
    uninstall_virt_manager
    ;;
  virt-manager)
    create_user
    launch_virt_manager $@
    ;;
  *)
    exec $@
    ;;
esac
