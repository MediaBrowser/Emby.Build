#!/bin/bash

update_release() {
	sed -i -e 's:emby-server-beta\ source:emby-server\ source:' source.lintian-overrides
}
