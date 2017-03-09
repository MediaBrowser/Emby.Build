FROM opensuse/amd64:tumbleweed
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

ENV LANG="en_US.UTF-8" s6_overlay_version="1.19.1.1"

RUN zypper --non-interactive ar -f -n repo-emby http://download.opensuse.org/repositories/home:emby/openSUSE_Tumbleweed repo-emby \
 && zypper --gpg-auto-import-keys ref \
 && zypper --non-interactive update --no-recommends \
 && zypper --non-interactive in --no-recommends \
	at \
	ca-certificates{,-cacert,-mozilla} \
	curl \
	dejavu-fonts \
	embymagick \
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
 && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-amd64.tar.gz -o /tmp/s6-overlay-amd64.tar.gz \
 && tar zvxf /tmp/s6-overlay-amd64.tar.gz -C / \
 && curl -L http://johnvansickle.com/ffmpeg/releases/ffmpeg-3.2.4-64bit-static.tar.xz -o /tmp/ffmpeg.tar.xz \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffmpeg" --strip-components=1  \
 && tar -C /bin --extract --file=/tmp/ffmpeg.tar.xz --wildcards "*/ffprobe" --strip-components=1  \
 && rpm -e --nodeps --allmatches --noscripts \
	`rpm -qa | grep aaa_base` \
	`rpm -qa | grep acl | grep -v lib` \
	`rpm -qa | grep branding-openSUSE` \
	`rpm -qa | grep cpio` \
	`rpm -qa | grep cryptsetup` \
	`rpm -qa | grep dracut` \
	`rpm -qa | grep fipscheck` \
	`rpm -qa | grep kbd` \
	`rpm -qa | grep kmod` \
	`rpm -qa | grep mapper` \
	`rpm -qa | grep ncurses-utils` \
	`rpm -qa | grep openSUSE-release` \
	`rpm -qa | grep perl` \
	`rpm -qa | grep pigz` \
	`rpm -qa | grep pinentry` \
	`rpm -qa | grep pkg-config` \
	`rpm -qa | grep qrencode` \
	`rpm -qa | grep sg3_utils` \
	cpio \
	curl \
 && zypper --non-interactive al dbus-1 kbd kmod systemd systemd-presets-branding-openSUSE udev openSUSE-release-ftp \
 && zypper cc --all \
 && rm -rf /var/cache/zypp* \
 && rm -rf /tmp/* \
 && rm -rf /var/log/* \
 && cd /usr/lib/locale \
 && ls | grep -ve "en_US*" | xargs rm -rf \
 && cd /usr/share/locale \
 && find -name '*.mo' | grep -ve "en_US*" | xargs rm -rf

COPY root /
