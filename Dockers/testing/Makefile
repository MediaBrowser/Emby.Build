all: build

IMG_BUILD_USER=emby
ifdef BUILD_USER
IMG_BUILD_USER=${BUILD_USER}
endif

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make embysever             - build the emby-sever base image"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${IMG_BUILD_USER}/embyserver" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${IMG_BUILD_USER}/embyserver" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

build:
	@docker build --rm=true --tag=${IMG_BUILD_USER}/embyserver .

embyserver: build
