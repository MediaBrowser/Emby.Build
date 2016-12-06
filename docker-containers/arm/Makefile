img_name := $(shell curl -s http://download.opensuse.org/repositories/home:/emby:/docker/images/ --list-only | sed -n s%".*>\(.*${ARCH}-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1)

%: build_armv7l


build_armv7l: ARCH = "armv7l"
build_armv7l:
	curl -sSLO http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name)

build_aarch64: ARCH = "aarch64"
build_aarch64:
	curl -sSLO http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name)
