all: build

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

ENV_VARS= \
	--env="USER_UID=$(shell id -u)" \
	--env="USER_GID=$(shell id -g)" \
	--env="DISPLAY" \
	--env="XAUTHORITY=${XAUTH}"

VOLUMES= \
	--volume=${XSOCK}:${XSOCK} \
	--volume=${XAUTH}:${XAUTH}

ENV_INSTL_USER=\
	--env="VIRT_MANAGER_USER=${USER}"

ifdef VIRT_MANAGER_DATA
ENV_INSTL_DATA= \
	--env="VIRT_MANAGER_DATA=${VIRT_MANAGER_DATA}"
endif

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build            - build the virt-manager image"
	@echo "   2. make install          - install virt-manager wrappers"
	@echo "   3. make virt-manager     - launch virt-manager"
	@echo "   4. make bash             - bash login"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${USER}/virt-manager" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${USER}/virt-manager" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build --rm=true --tag=${USER}/virt-manager .

install uninstall: build
	@docker run -it --rm \
		--volume=/usr/local/bin:/target \
		${ENV_INSTL_DATA} \
		${ENV_INSTL_USER} \
		${USER}/virt-manager:latest $@

virt-manager bash:
	@touch ${XAUTH}
	@auth nlist :0 | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -
	docker run -it --rm \
		${ENV_VARS} \
		${VOLUMES} \
		${USER}/virt-manager:latest $@
