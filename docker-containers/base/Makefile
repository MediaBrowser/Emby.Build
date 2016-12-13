all: build

IMG_NAME="emby-base"

ifndef APP_REPO
APP_REPO=${USER}
endif

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make base             - build the emby-sever base image"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${APP_REPO}/${IMG_NAME}" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${APP_REPO}/${IMG_NAME}" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build \
		--rm=true \
		--tag=${APP_REPO}/${IMG_NAME} .

base: build
