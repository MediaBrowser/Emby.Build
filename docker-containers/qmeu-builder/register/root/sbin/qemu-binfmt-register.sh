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
  while getopts ":r" opt; do
    case $opt in
      r)
        unregister
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
  done
else
  exec /usr/sbin/qemu-binfmt-conf.sh
fi
