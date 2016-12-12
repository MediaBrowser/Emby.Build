#!/usr/bin/make -f

all: armv7l aarch64
.PHONY: all armv7l aarch64 end

armv7l: ARCH := "armv7l"
aarch64: ARCH := "aarch64"
armv7l aarch64:
	@echo "Building $(ARCH)"
	$(eval img_name := $(shell curl -s http://download.opensuse.org/repositories/home:/emby:/docker/images/ --list-only | grep devel | sed -n s%".*>\(.*${ARCH}-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1))
	curl -sSL http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name) -o rootfs.tar.xz
	docker build --rm=true --tag=emby/devel:$(ARCH) .
	docker push emby/devel:$(ARCH)
	docker rmi emby/devel:$(ARCH)
	rm rootfs.tar.xz

end:
	@echo "Done!"
