#!/usr/bin/make -f

SHELL := /bin/bash

repo := "http://download.opensuse.org/tumbleweed/repo/oss/suse/x86_64"
all: armv7 aarch64
.PHONY: all armv7 aarch64 end

armv7: ARCH := "armv7"
aarch64: ARCH := "aarch64"
armv7 aarch64:
	@echo "Building $(ARCH)"
	$(eval img_name := $(shell curl -s http://download.opensuse.org/repositories/home:/emby:/docker/images/ --list-only | grep devel | sed -n s%".*>\(.*${ARCH}.*-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1))
	curl -L http://download.opensuse.org/repositories/home:/emby:/docker/images/$(img_name) -o rootfs.tar.xz
	$(eval rpm_name := $(shell curl -s $(repo)/ --list-only | grep qemu-linux | sed -n s%".*>\(qemu-linux-.*rpm\)</a>.*"%"\1"%p))
	curl -L $(repo)/$(rpm_name) -o qemu-linux-user.rpm
	@ if [[ $(ARCH) ==  "armv7" ]]; then \
		rpm2cpio qemu-linux-user.rpm | cpio -idmv "*qemu-arm*"; \
	  else \
		rpm2cpio qemu-linux-user.rpm | cpio -idmv "*qemu-aarch*"; \
	  fi
	docker build --rm=true --tag=emby/qemu-builder:$(ARCH) .
	docker push emby/qemu-builder:$(ARCH)
	docker rmi emby/qemu-builder:$(ARCH)
	rm rootfs.tar.xz
	rm qemu-linux-user.rpm
	rm -rf root/
	rm -rf usr/

end:
	@echo "Done!"
