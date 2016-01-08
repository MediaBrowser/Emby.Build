all: build

IMG_BUILD_USER=emby
ifdef BUILD_USER
IMG_BUILD_USER=${BUILD_USER}
endif

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build             - build the emby-sever base image"
	@echo "   2. make clean             - remove the emby-sever base image and containers"
	@echo "   3. make install           - install emby-sever wrapper script for docker"
	@echo "   4. make emby-server       - build emby-server image and run"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${IMG_BUILD_USER}/emby-server" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${IMG_BUILD_USER}/emby-server" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build --rm=true --tag=${IMG_BUILD_USER}/emby-server .

emby-server: build

install: clean build
	@docker run -it --rm -v /usr/local/bin:/target emby/emby-server install_emby

service: clean build
	@docker run -it --rm -v /usr/local/bin:/target emby/emby-server install_emby
	@docker run -it --rm -v /etc/systemd/system:/target emby/emby-server install_service
