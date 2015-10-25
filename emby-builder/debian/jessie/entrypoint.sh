#!/bin/bash
set -e

case "$1" in
	emby-server)
		;;
	emby-server-beta)
		;;
	emby-server-dev)
		;;
	*)
		exec $@
		;;
esac
