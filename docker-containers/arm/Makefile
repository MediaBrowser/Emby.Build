#!/usr/bin/make -f

all: armv7l aarch64
.PHONY: all armv7l aarch64 end

armv7l: ARCH := "armv7l"
aarch64: ARCH := "aarch64"
armv7l aarch64:
	@echo "Building $(ARCH)"
	$(eval img_name := $(shell curl -s http://download.opensuse.org/repositories/home:/emby:/docker/images/ --list-only | sed -n s%".*>\(.*${ARCH}-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1))
	curl -sSL http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name) -o rootfs.tar.xz
	sed -i s/"\(TAG_NAME=\)\([^ ]*\)"/"\1$(ARCH)"/ Dockerfile
	docker build --rm=true --tag=emby/embyserver:$(ARCH) .
	docker push emby/embyserver:$(ARCH)
	docker rmi emby/embyserver:$(ARCH)
	rm rootfs.tar.xz

end:
	@echo "Done!"
