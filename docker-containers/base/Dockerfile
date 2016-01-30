FROM opensuse:tumbleweed
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

ENV LANG="en_US.UTF-8" s6_overlay_version="1.17.1.1"

RUN zypper addrepo http://download.opensuse.org/repositories/home:emby/openSUSE_Tumbleweed/home:emby.repo \
 && zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive update --no-recommends \
 && zypper --non-interactive in --no-recommends ca-certificates{,-cacert,-mozilla} \
	embymagick \
	mono-core \
	mono-wcf \
	sqlite \
	sudo \
	glibc-locale \
	timezone \
	curl \
	tar \
	xz \
 && curl -sL https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-amd64.tar.gz -o /tmp/s6-overlay-amd64.tar.gz \
 && tar zxf /tmp/s6-overlay-amd64.tar.gz -C / \
 && curl -sL http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -o /tmp/ffmpeg.tar.xz \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffmpeg" --strip-components=1  \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffprobe" --strip-components=1  \
 && rpm -e --nodeps --allmatches --noscripts \
	kmod \
	pkg-config \
	tar \
	curl \
	xz \
	cpio \
	mono-winforms \
 && zypper cc --all \
 && rm -rf /var/cache/zypp* \
 && rm -rf /tmp/* \
 && rm -rf /var/log/* \
 && cd /usr/lib/locale \
 && ls | grep -ve "en_US*" | xargs rm -rf \
 && cd /usr/share/locale \
 && find -name '*.mo' | grep -ve "en_US*" | xargs rm -rf
