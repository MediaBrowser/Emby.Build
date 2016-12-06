all: build

current_dir := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
current_s6_overlay := $(shell curl -sSL https://github.com/just-containers/s6-overlay/releases.atom | sed -n s/"^\(\s\+<title>\)\(v[^<]*\).*$$"/"\2"/p | head -1)
tumbleweed_root = "https://github.com/openSUSE/docker-containers/blob/master/openSUSE-Tumbleweed/root.tar.bz2?raw=true"
container_dir := $(shell dirname $(shell dirname $(shell dirname $(current_dir))))

build: clean
	curl -sSL ${tumbleweed_root} -o root.tar.bz2
	curl -sSOL https://github.com/just-containers/s6-overlay/releases/download/$(current_s6_overlay)/s6-overlay-armhf.tar.gz
	cp -r $(container_dir)/stable/root $(current_dir)
	tar -C $(current_dir)/root -xf root.tar.bz2
	tar -C $(current_dir)/root -xf s6-overlay-armhf.tar.gz
	cp $(current_dir)/04-ffmpeg-onetime $(current_dir)/root/etc/cont-init.d/
	rm $(current_dir)/root.tar.bz2
	rm $(current_dir)/root/etc/zypp/repos.d/*
	cp $(current_dir)/emby.repo $(current_dir)/root/etc/zypp/repos.d/
	cp $(current_dir)/oss.repo $(current_dir)/root/etc/zypp/repos.d/
	tar -C $(current_dir)/root -cjf $(current_dir)/root.tar.bz2 .
ifneq ("$(wildcard $(current_dir)/s6-overlay-armhf.tar.gz)","")
	rm $(current_dir)/s6-overlay-armhf.tar.gz
endif
ifneq ("$(wildcard $(current_dir)/root)","")
	rm -rf $(current_dir)/root
endif


clean:
ifneq ("$(wildcard $(current_dir)/root.tar.bz2)","")
	rm $(current_dir)/root.tar.bz2
endif
ifneq ("$(wildcard $(current_dir)/s6-overlay-armhf.tar.gz)","")
	rm $(current_dir)/s6-overlay-armhf.tar.gz
endif
ifneq ("$(wildcard $(current_dir)/root)","")
	rm -rf $(current_dir)/root
endif
