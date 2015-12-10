#!/usr/bin/with-contenv bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

EMBYSERVER_USER=${EMBYSERVER_USER:-emby}
EMBYSERVER_REPO=${EMBYSERVER_REPO:-emby}

install_emby-server() {
  echo "Installing Emby Server..."
  install -m 0755 /var/cache/scripts/emby-server /target/
  if [ "${EMBYSERVER_USER}" != "emby" ] && [ -n "${EMBYSERVER_USER}" ]; then
    echo "Updating user to ${EMBYSERVER_USER}..."
    sed -i -e s%"EMBYSERVER_USER:-emby"%"EMBYSERVER_USER:-${EMBYSERVER_USER}"%1 /target/emby-server
  fi
  exec s6-svscanctl -t /var/run/s6/services
}

install_emby-server_service() {
  echo "Installing Emby Service..."
  install -m 0755 /var/cache/emby-server/emby-server.service /target/
  exec s6-svscanctl -t /var/run/s6/services
}

uninstall_emby-server() {
  echo "Uninstalling Emby Server..."
  rm -rf /target/emby-server
  exec s6-svscanctl -t /var/run/s6/services
}

case "$1" in
  install)
    install_emby-server
    ;;
  install_service)
    install_emby-server_service
    ;;
  uninstall)
    uninstall_emby-server
    ;;
  bash)
    exec bash
    ;;
  *)
    exec $@
    ;;
esac
