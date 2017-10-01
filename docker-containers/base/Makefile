#!/usr/bin/make -f

SHELL := /bin/bash
IMG_NAME := "emby-base"
IMG_REPO := "emby"

root_repo := "http://download.opensuse.org/repositories/home:/emby:/docker/images/"
qemu_repo := "http://download.opensuse.org/tumbleweed/repo/oss/suse/x86_64"

all: armv7 aarch64 x86_64
.PHONY: all armv7 aarch64 x86_64 clean end


start: FORCE
	@ echo "Building emby base image for $(ARCH)"
	$(eval BUILDDIR := /var/tmp/$(IMG_REPO)_$(IMG_NAME)_$(ARCH))
	@ if  [[ -d $(BUILDDIR) ]]; then \
		rm -rf $(BUILDDIR); \
	fi
	mkdir -p $(BUILDDIR)

download_source: FORCE
	$(eval rootfs_file := $(shell curl -s $(root_repo) --list-only | sed -n s%".*>\(emby-base.*${ARCH}.*-.*tar.xz\)</a>.*"%"\1"%p | sort -i | head -1))
	curl -L $(root_repo)/$(rootfs_file) -o $(BUILDDIR)/temp.tar.xz

prep_vars: FORCE
	$(eval is_new_format := $(shell tar tvf $(BUILDDIR)/temp.tar.xz | awk 'BEGIN{ cnt=0; } { if ( $$6 == "manifest.json" ) cnt=1; } END{ print cnt }'))
	$(eval rpm_name := $(shell curl -s $(qemu_repo)/ --list-only | grep qemu-linux | sed -n s%".*>\(qemu-linux-.*rpm\)</a>.*"%"\1"%p | tail -1))

armv7: ARCH := "armv7"
aarch64: ARCH := "aarch64"
x86_64: ARCH := "x86_64"
armv7 aarch64 x86_64: start download_source prep_vars
	@ if [[ $(is_new_format) -eq 1  ]]; then \
		tar xvf $(BUILDDIR)/temp.tar.xz; \
		rm $(BUILDDIR)/temp.tar.xz; \
		find $(BUILDDIR) -maxdepth 1 -type f -size -10M -delete; \
		find $(BUILDDIR) -maxdepth 1 -type f -size +40M -print0 | xargs -0 -I {} mv {} $(BUILDDIR)/rootfs.tar.xz; \
	else \
		mv $(BUILDDIR)/temp.tar.xz $(BUILDDIR)/rootfs.tar.xz; \
	fi
	cp Dockerfile $(BUILDDIR)
	cp -r overlay-$(ARCH) $(BUILDDIR)/overlay-$(ARCH)
	cp -r overlay-common $(BUILDDIR)/overlay-common
	mkdir -p $(BUILDDIR)/usr/bin
	curl -L $(qemu_repo)/$(rpm_name) -o $(BUILDDIR)/qemu-linux-user.rpm
	@ if [[ $(ARCH) ==  "armv7" ]]; then \
		rpm2cpio $(BUILDDIR)/qemu-linux-user.rpm | cpio -D $(BUILDDIR) -idmv "*qemu-arm" "*qemu-arm-*"; \
		if [[ ! -e /proc/sys/fs/binfmt_misc/qemu-arm ]]; then \
			docker run --rm --privileged emby/qemu-register:latest; \
		fi \
	fi
	@ if [[ $(ARCH) ==  "aarch64" ]]; then \
		rpm2cpio $(BUILDDIR)/qemu-linux-user.rpm | cpio -D $(BUILDDIR) -idmv "*qemu-aarch*"; \
		if [[ ! -e /proc/sys/fs/binfmt_misc/qemu-aarch64 ]]; then \
			docker run --rm --privileged emby/qemu-register:latest; \
		fi \
	fi
	@ if [[ $(ARCH) ==  "x86_64" ]]; then \
		curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -o $(BUILDDIR)/ffmpeg.tar.xz; \
	else \
		curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-32bit-static.tar.xz -o $(BUILDDIR)/ffmpeg.tar.xz; \
	fi
	tar -C $(BUILDDIR)/usr/bin -xf $(BUILDDIR)/ffmpeg.tar.xz --wildcards "*/ffmpeg" --strip-components=1
	tar -C $(BUILDDIR)/usr/bin -xf $(BUILDDIR)/ffmpeg.tar.xz --wildcards "*/ffprobe" --strip-components=1
	cd $(BUILDDIR) && \
	docker build --build-arg ARCH=$(ARCH) --rm=true --tag=$(IMG_REPO)/$(IMG_NAME):$(ARCH) .
	@ if [[ $(ARCH) ==  "x86_64" ]]; then \
		docker tag $(IMG_REPO)/$(IMG_NAME):$(ARCH) $(IMG_REPO)/$(IMG_NAME):latest; \
	fi
	rm -rf $(BUILDDIR)

push:
	docker push $(IMG_REPO)/$(IMG_NAME)

end:
	@echo "Done!"

FORCE:
