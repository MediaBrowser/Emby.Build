#!/usr/bin/make -f

all: armv7 aarch64
.PHONY: all armv7 aarch64 end

armv7: ARCH := "armv7"
aarch64: ARCH := "aarch64"
armv7 aarch64:
	@echo "Building $(ARCH)"
	$(eval img_name := $(shell curl -s http://download.opensuse.org/repositories/home:/emby:/docker/images/ --list-only | grep devel | sed -n s%".*>\(.*${ARCH}-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1))
	curl -sSL http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name) -o rootfs.tar.xz
	@ if [[ $(ARCH) ==  "armv7" ]]; then \
		cp /usr/bin/qemu-arm-binfmt . \
		cp /usr/bin/qemu-arm . \
	  else \
	    cp /usr/bin/qemu-aarch64-binfmt . \
	    cp /usr/bin/qemu-aarch64 . \
	  fi
	docker build --rm=true --tag=emby/devel:$(ARCH) .
	docker push emby/devel:$(ARCH)
	docker rmi emby/devel:$(ARCH)
	rm rootfs.tar.xz

end:
	@echo "Done!"
