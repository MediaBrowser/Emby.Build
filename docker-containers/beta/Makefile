#!/usr/bin/make -f

SHELL := /bin/bash
IMG_NAME := embyserver_beta
IMG_REPO := emby

.PHONY: all armv7 aarch64 x86_64 end
all: armv7 aarch64 x86_64

x86_64: ARCH := x86_64
armv7: ARCH := armv7
aarch64: ARCH := aarch64
x86_64 armv7 aarch64:
	$(eval VERSION=$(shell curl -sL https://github.com/mediaBrowser/Emby/releases.atom | grep -A 1 -e 'link.*alternate' | grep -e '    <' | sed 'N;s/\n/ /' | grep 'beta' | head -1 | sed 's%.*/tag/\([^"]*\).*%\1%'))
	@ echo "Building emby-server  image for $(ARCH)"
	$(eval BUILDDIR := /var/tmp/$(IMG_REPO)_$(IMG_NAME)_$(ARCH))
	@ if  [[ -d $(BUILDDIR) ]]; then \
		rm -rf $(BUILDDIR); \
	fi
	mkdir -p $(BUILDDIR)
	cp Dockerfile $(BUILDDIR)
	sed -i s'%\(emby/emby-base[:]\).*%\1$(ARCH)%' $(BUILDDIR)/Dockerfile
	cd $(BUILDDIR) && \
	docker build --build-arg ARCH=$(ARCH) --rm=true --tag=$(IMG_REPO)/$(IMG_NAME):$(ARCH) .
	docker tag $(IMG_REPO)/$(IMG_NAME):$(ARCH) $(IMG_REPO)/$(IMG_NAME):$(ARCH)_$(VERSION)
	@ if [[ $(ARCH) ==  "x86_64" ]]; then \
		docker tag $(IMG_REPO)/$(IMG_NAME):$(ARCH) $(IMG_REPO)/$(IMG_NAME):latest; \
	fi
	rm -rf $(BUILDDIR)

push:
	docker push $(IMG_REPO)/$(IMG_NAME)

end:
	@echo "Done!"
