FROM opensuse/amd64:tumbleweed
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

ENV LANG="en_US.UTF-8" s6_overlay_version="1.18.1.5"

RUN zypper --non-interactive ar -f -n repo-emby http://download.opensuse.org/repositories/home:emby/openSUSE_Tumbleweed repo-emby \
 && zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive update --no-recommends \
 && zypper --non-interactive in --no-recommends \
	at \
	ca-certificates{,-cacert,-mozilla} \
	curl \
	embymagick \
	ghostscript-fonts-other \
	ghostscript-fonts-std \
	glibc-locale \
	libembysqlite3-0 \
	libHX28 \
	mono-core \
	mono-data \
	mono-data-sqlite \
	mono-extras \
	mono-mvc \
	mono-wcf \
	mono-wcf \
	mono-web \
	mono-winfxcore \
	sudo \
	tar \
	timezone \
	xz \
 && curl -sL https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-amd64.tar.gz -o /tmp/s6-overlay-amd64.tar.gz \
 && tar zxf /tmp/s6-overlay-amd64.tar.gz -C / \
 && curl -sL http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -o /tmp/ffmpeg.tar.xz \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffmpeg" --strip-components=1  \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffprobe" --strip-components=1  \
 && rpm -e --nodeps --allmatches --noscripts \
	cpio \
	curl \
	tar \
	xz \
 && zypper --non-interactive al dbus-1 kbd kmod systemd systemd-presets-branding-openSUSE udev \
 && zypper cc --all \
 && rm -rf /var/cache/zypp* \
 && rm -rf /tmp/* \
 && rm -rf /var/log/* \
 && cd /usr/lib/locale \
 && ls | grep -ve "en_US*" | xargs rm -rf \
 && cd /usr/share/locale \
 && find -name '*.mo' | grep -ve "en_US*" | xargs rm -rf
