%global name emby-server-dev
%global release 0
%global data_dir /var/lib/emby-server
%global install_dir /usr/lib/emby-server
%global user_group media
%global admin_group emby
%global user emby

Name:           %{name}
Version:        3.12
Release:        %{release}
Summary:        Emby is a home media server built on top of other popular open source technologies such as Service Stack, jQuery, jQuery mobile, and Mono.
Vendor:         Emby
Group:          Applications/Multimedia
BuildArch:      noarch
License:        GPL
URL:            http://emby.media/
Source0:        %{name}-%{version}.tar.gz
Source1:		redhat.default.emby-server.conf
Source2: 		redhat.emby
Source3:		redhat.emby-server
Source4:		redhat.emby-server.conf
Source5:		redhat.emby-server.service
Source6:		redhat.emby-server.sh
Source7:		redhat.restart.sh
BuildRequires:	mono-xbuild >= 4.0.0
BuildRequires:	mono-devel >= 4.0.0
#BuildRequires:	ImageMagick-libs >= 6.9.0
BuildRequires:	libMagickWand-6_Q8-2
%if 0%{?suse_version} >= 1315
BuildRequires:	libmediainfo0
BuildRequires:	pkgconfig(systemd)
BuildRequires:  shadow
BuildRequires:  dummy-release
BuildRequires:  lsb-release
Requires:		libmediainfo0
#Requires(pre):  shadow
#Requires(pre):  lsb-release
#Requires(pre):  dummy-release
%else
BuildRequires:	libmediainfo
Requires:		libmediainfo
%endif
Requires:		sqlite >= 3.8.2
Requires:		mono-core >= 4.0.0
Requires:		mono-wcf >= 4.0.0
#Requires:		ImageMagick >= 6.9.0
Requires:		libMagickWand-6_Q8-2
%if 0%{?suse_version} >= 1315
Requires:		lsb-release
%else
Requires:		redhat-lsb-core
%endif
AutoReqProv:	no
Obsoletes:      MediaBrowserServer , MediaBrowserServer-dev, emby-server-core 
Conflicts:		emby-server, emby-server-beta

%description
Emby (formely known as Media Browser) is a home media server built on top of other popular open source technologies such as Service Stack, jQuery, jQuery mobile, and Mono.
It features a REST-based api with built-in documention to facilitate client development. We also have client libraries for our api to enable rapid development.

%prep
%setup -c -n %{name}-%{version}-build -q
mkdir -p ./etc/default ./etc/init.d ./etc/sudoers.d ./usr/lib/emby-server ./usr/lib/systemd/system
cp %{_sourcedir}/redhat.default.emby-server.conf ./etc/default/emby-server.conf
cp %{_sourcedir}/redhat.emby ./etc/sudoers.d/emby
cp %{_sourcedir}/redhat.emby-server.conf ./etc/emby-server.conf
%if 0%{?centos_version} == 600
	cp %{_sourcedir}/redhat.emby-server ./etc/init.d/emby-server
	chmod 0755 ./etc/init.d/emby-server
%else
	cp %{_sourcedir}/redhat.emby-server.service ./usr/lib/systemd/system/emby-server.service
	chmod 0444 ./usr/lib/systemd/system/emby-server.service	
%endif
cp %{_sourcedir}/redhat.emby-server.sh ./usr/lib/emby-server/emby-server.sh
chmod 0755 ./usr/lib/emby-server/emby-server.sh
cp %{_sourcedir}/redhat.restart.sh ./usr/lib/emby-server/restart.sh
chmod 0755 ./usr/lib/emby-server/restart.sh

%build
buildLogs="%{install_dir}/bin/buildLogs.txt"
cd %{name}-%{version}
mkdir -p ..%{install_dir}/bin
xbuild /p:Configuration="Release Mono" /p:Platform="Any CPU" /t:clean MediaBrowser.Mono.sln  > ..$buildLogs
xbuild /p:Configuration="Release Mono" /p:Platform="Any CPU" /t:build MediaBrowser.Mono.sln  >> ..$buildLogs
mv MediaBrowser.Server.Mono/bin/Release\ Mono/* ..%{install_dir}/bin
cd ..
rm -rf %{name}-%{version}
cd .%{install_dir}/bin
rm -rf ./*.dylib

%pre
getent group %{user_group} >/dev/null || groupadd -r %{user_group}
getent group %{admin_group} >/dev/null || groupadd -r %{admin_group}
getent passwd %{user} >/dev/null || useradd -r -g %{admin_group} -d %{data_dir} -s /sbin/nologin -c "Account under which Emby runs" %{user}
usermod -aG %{user_group} %{user}
DISTRIBUTOR=$(lsb_release -i | cut -f 2)
RELEASE=$(lsb_release -r | cut -f 2 | cut -d . -f 1)
if [ "$DISTRIBUTOR" == "Fedora" ] && [ -f "/usr/lib/systemd/system/emby-server.service" ]; then
	systemctl stop emby-server > /dev/null
elif [ "$DISTRIBUTOR" == "CentOS" ]; then
	if [ "$RELEASE" == "6" ] && [ -f "/etc/init.d/emby-server" ]; then
		service emby-server stop > /dev/null
	elif [ "$RELEASE" == "7" ] && [ -f "/usr/lib/systemd/system/emby-server.service" ]; then
		systemctl stop emby-server > /dev/null
	fi
elif [ "$DISTRIBUTOR" == "SUSE LINUX" ] && [ -f "/usr/lib/systemd/system/emby-server.service" ]; then
	systemctl stop emby-server > /dev/null
fi

%install
mkdir -p %{buildroot}%{install_dir}
mkdir -p %{buildroot}%{data_dir}
cp -vR * %{buildroot}

%post
cd %{install_dir}/bin
imageWand=$(ldconfig -p | grep libMagickWand | head -n 1 | cut -d " " -f1)
imageWand=${imageWand//[[:blank:]]/}
mediainfolib=$(ldconfig -p | grep libmediainfo | head -n 1 | cut -d " " -f1)
mediainfolib=${mediainfolib//[[:blank:]]/}
sqlitelib=$(ldconfig -p | grep libsqlite3 | head -n 1 | cut -d " " -f1)
sqlitelib=${sqlitelib//[[:blank:]]/}
echo  "<configuration><dllmap dll=\"CORE_RL_Wand_.dll\" target=\"$imageWand\" os=\"linux\"/></configuration>" > ImageMagickSharp.dll.config
echo  "<configuration><dllmap dll=\"MediaInfo\" target=\"$mediainfolib\" os=\"linux\"/></configuration>" > MediaBrowser.MediaInfo.dll.config
echo  "<configuration><dllmap dll=\"sqlite3\" target=\"$sqlitelib\" os=\"linux\"/></configuration>" > System.Data.SQLite.dll.config
# Data migration script for users upgrading from older MediaBrowser/Emby packages to the new rebranded package
if [ -d "/var/opt/MediaBrowser" ] && [ ! -f "/var/opt/MediaBrowser/.already_imported" ]; then
	mv /var/lib/emby-server /var/lib/emby-server.default
	mkdir /var/lib/emby-server
	cp -a /var/opt/MediaBrowser/MediaBrowserServer/* /var/lib/emby-server
	chown emby.emby /var/lib/emby-server -R
	cp -a /var/lib/emby-server/data/library.db /var/lib/emby-server/data/librarydb.bak
	rm /var/lib/emby-server/data/library.db-shm
	rm /var/lib/emby-server/data/library.db-wal
	sqlite3 /var/lib/emby-server/data/library.db "UPDATE TypedBaseItems SET data = CAST(REPLACE(CAST(data AS TEXT), '/var/opt/MediaBrowser/MediaBrowserServer', '/var/lib/emby-server') AS BLOB)"
	touch /var/opt/MediaBrowser/.already_imported
elif [ -d "/var/opt/Emby" ] && [ ! -f "/var/opt/Emby/.already_imported" ]; then
	mv /var/lib/emby-server /var/lib/emby-server.default
	mkdir /var/lib/emby-server
	cp -a /var/opt/Emby/server/* /var/lib/emby-server/
	chown emby.emby /var/lib/emby-server -R
	cp -a /var/lib/emby-server/data/library.db /var/lib/emby-server/data/librarydb.bak
    rm /var/lib/emby-server/data/library.db-shm
    rm /var/lib/emby-server/data/library.db-wal
	sqlite3 /var/lib/emby-server/data/library.db "UPDATE TypedBaseItems SET data = CAST(REPLACE(CAST(data AS TEXT), '/var/opt/Emby/server', '/var/lib/emby-server') AS BLOB)"
	touch /var/opt/Emby/.already_imported
fi
DISTRIBUTOR=$(lsb_release -i | cut -f 2)
RELEASE=$(lsb_release -r | cut -f 2 | cut -d . -f 1)

echo "*******************************"
echo "DISTRIBUTOR: $DISTRIBUTOR"
echo "RELEASE: $RELEASE"
echo "*******************************"

if [ "$DISTRIBUTOR" == "Fedora" ] || [ "$DISTRIBUTOR" == "SUSE LINUX" ]; then
	systemctl daemon-reload > /dev/null
	#systemctl start emby-server > /dev/null
elif [ "$DISTRIBUTOR" == "CentOS" ]; then
	if [ "$RELEASE" == "6" ]; then
    	chkconfig --add emby-server > /dev/null
		#service emby-server start > /dev/null
	elif [ "$RELEASE" == "7" ]; then
    	systemctl daemon-reload > /dev/null
		#systemctl start emby-server > /dev/null
	fi
fi

%files
%{install_dir}
%attr(775,%{user},%{admin_group}) %{data_dir}
%{_sysconfdir}/default/emby-server.conf
%config(noreplace) %{_sysconfdir}/emby-server.conf
%if 0%{?centos_version} == 600
	%{_sysconfdir}/init.d/emby-server
%else
	/usr/lib/systemd/system/emby-server.service
%endif
%{_sysconfdir}/sudoers.d


%changelog
