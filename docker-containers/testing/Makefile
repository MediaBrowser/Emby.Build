all: build

APP_NAME="emby-server"

ifndef APP_REPO
APP_REPO=${USER}
endif

ENV_VARS= \
	--env="APP_REPO=${APP_REPO}" \
	--env="APP_USER=${USER}"

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build             - build the ${APP_NAME} base image"
	@echo "   2. make clean             - remove the ${APP_NAME} base image and containers"
	@echo "   3. make install           - install ${APP_NAME} wrapper script for docker"
	@echo "   4. make ${APP_NAME}       - build ${APP_NAME} image and run"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${APP_REPO}/${APP_NAME}" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${APP_REPO}/${APP_NAME}" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build --rm=true --tag=${APP_REPO}/${APP_NAME} .

emby-server: clean build

instl uninstl: clean build
	@docker run -it --rm \
		-v /usr/local/bin:/target \
		${ENV_VARS} \
		${APP_REPO}/${APP_NAME} $@
