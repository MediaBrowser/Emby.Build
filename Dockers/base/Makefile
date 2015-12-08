all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make base             - build the emby-sever base image"
	@echo ""

clean:
	@docker rm -f `docker ps -a | grep "${USER}/emby-base" | awk '{print $$1}'` > /dev/null 2>&1 || exit 0
	@docker rmi `docker images  | grep "${USER}/emby-base" | awk '{print $$3}'` > /dev/null 2>&1 || exit 0

base:
	@docker build --rm=true --tag=${USER}/emby-base .
