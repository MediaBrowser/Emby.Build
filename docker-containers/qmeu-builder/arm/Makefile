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
		sed s%"^COPY\sbinfmt$$"%"COPY qemu-arm-binfmt /usr/bin/"% Dockerfile
		cp /usr/bin/qemu-arm . \
		sed s%"^COPY\sqemu$$"%"COPY qemu-arm /usr/bin/"% Dockerfile
	  else \
	    cp /usr/bin/qemu-aarch64-binfmt . \
		sed s%"^COPY\sbinfmt$$"%"COPY qemu-aarch64-binfmt /usr/bin/"% Dockerfile
	    cp /usr/bin/qemu-aarch64 . \
		sed s%"^COPY\sqemu$$"%"COPY qemu-aarch64 /usr/bin/"% Dockerfile
	  fi
	docker build --rm=true --tag=emby/qemu-builder:$(ARCH) .
	docker push emby/qemu-builder:$(ARCH)
	docker rmi emby/qemu-builder:$(ARCH)
	rm rootfs.tar.xz
	git clean -f -d
	git reset --hard HEAD

end:
	@echo "Done!"
