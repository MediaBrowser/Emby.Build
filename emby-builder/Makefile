all: build

current_dir := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VOLUMES = \
		  --volume=$(current_dir):/pkg \
		  --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw

ENV_VARS = \
		   --env="USER_UID=$(shell id -u)" \
		   --env="USER_GID=$(shell id -g)" \
		   --env="BUILD_USER=${USER}"

PORTS = \
		-p 8096:8096

DIST = "debian/jessie"

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make emby-server           - build emby-server debian package"
	@echo "   2. make emby-server-beta      - build emby-server-beta debian package"
	@echo "   3. make emby-server-dev       - build emby-server-dev debian package"
	@echo "   4. make bash                  - bash login"
	@echo "   5. make build                 - build emby-builder image"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${USER}/emby-builder" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${USER}/emby-builder" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build --rm=true --tag=${USER}/emby-builder -f ./${DIST}/Dockerfile .

emby-server emby-server-beta emby-server-dev bash: build
	@echo "Starting container to build $1 package."
	@docker run -it --rm \
		--cap-add=SYS_ADMIN \
		${PORTS} \
		${ENV_VARS} \
		${VOLUMES} \
		${USER}/emby-builder:latest $@

test:
	@echo "Starting container to thoroughly test package."
	@echo "run docker exec to enter container."
	@docker run -d \
		--cap-add=SYS_ADMIN \
		--entrypoint /sbin/init \
		${PORTS} \
		${ENV_VARS} \
		${VOLUMES} \
		${USER}/emby-builder:latest
