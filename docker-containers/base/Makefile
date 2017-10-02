#!/usr/bin/make -f
SHELL:=/usr/bin/env bash

IMG_NAME := emby-base
IMG_REPO := emby

.PHONY: all
all: armv7 aarch64 x86_64

armv7: ARCH := "armv7"
aarch64: ARCH := "aarch64"
x86_64: ARCH := "x86_64"
.PHONY: armv7 aarch64 x86_64
armv7 aarch64 x86_64:
	@chmod +x "./utils/docker-build.sh"; sync;
	@export DOCKER_BUILD_SRC_PATH=${PWD}; \
	"./utils/docker-build.sh" $(ARCH)

.PHONY: push
push:
	docker push $(IMG_REPO)/$(IMG_NAME)

.PHONY: end
end:
	@echo "Done!"
