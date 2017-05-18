#!/bin/bash

binfmt_misc="/proc/sys/fs/binfmt_misc"

unregister() {
  if [[ -d "$binfmt_misc" ]]; then
    echo "Removing all binfmt entries..."
    cd $binfmt_misc
    for file in *; do
      case "${file}" in
        status|register)
        ;;
      *)
        echo -1 > "${file}"
        ;;
      esac
    done
  else
    echo "No binfmt support in the kernel." >&2
  fi
}

if [[ ! -d $binfmt_misc ]]; then
  echo "No binfmt support in the kernel."
  echo "  Try: '/sbin/modprobe binfmt_misc' from the host"
  exit 1
fi


if [[ ! -f $binfmt_misc/register ]]; then
  mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
fi


if [[ $# -gt 0 ]]; then
  options=$(getopt -o r -l remove -- "$@")
  eval set -- "$options"
  while true ; do
    case "$1" in
      -r|--remove)
        unregister
        ;;
      *)
        break
        ;;
    esac
    shift
  done
else
  exec /usr/sbin/qemu-binfmt-conf.sh -c yes
fi
