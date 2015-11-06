#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Configure user nobody to match unRAID's settings
export DEBIAN_FRONTEND="noninteractive"
groupmod -g 100 users
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################
# Config
cat <<'EOT' > /etc/my_init.d/config.sh
#!/bin/bash
# Fix the timezone
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

# Adjust UID and GID of nobody with environmet variables
USER_ID=${MB_USER_ID:-99}
GROUP_ID=${MB_GROUP_ID:-100}
AUTO_UPDATE=${AUTO_UPDATES_ON=-false}
groupmod -g $GROUP_ID users
usermod -u $USER_ID nobody
usermod -g $GROUP_ID nobody
usermod -d /home nobody

# Set right permission for directories
USER="nobody"
PROGRAMDATA=/config
HOME_CURRENT_USER=`ls -lad $HOME_PATH | awk '{print $3}'`
DATA_CURRENT_USER=`ls -lad $PROGRAMDATA | awk '{print $3}'`

if [ "$DATA_CURRENT_USER" != "$USER" ]; then
    chown -R "$USER":users "$PROGRAMDATA"
fi

# Check if user wants auto updates
if [ "$AUTO_UPDATE" = "true" ]; then
    echo "* 3 * * * /Update.sh" > /etc/cron.d/cron.conf
fi

chown -R nobody:users /home/
chmod +x /Update.sh
EOT

# Updates
cat <<'EOT' > /Update.sh
#!/bin/bash
#!/bin/bash
sv stop emby
apt-get update -qq
apt-get install --only-upgrade -qy --force-yes mono-runtime emby-server
sv start emby
EOT

# Emby Server
mkdir -p /etc/service/emby
cat <<'EOT' > /etc/service/emby/run
#!/bin/bash
umask 000

cd /opt/emby-server/
exec env MONO_THREADS_PER_CPU=100 MONO_GC_PARAMS=nursery-size=64m /sbin/setuser nobody mono-sgen /usr/lib/emby-server/bin/MediaBrowser.Server.Mono.exe \
                                -programdata /config \
                                -ffmpeg $(which ffmpeg) \
                                -ffprobe $(which ffprobe)
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
# Install repos
apt-get update -qq
apt-get install -qy --force-yes wget

# Repositories
wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_14.04/Release.key | apt-key add -
echo 'deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/emby-server-beta.list
echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe multiverse restricted' > /etc/apt/sources.list
echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main universe multiverse restricted' >> /etc/apt/sources.list
add-apt-repository ppa:mc3man/trusty-media

# Use mirrors
# sed -i -e "s#http://[^\s]*archive.ubuntu[^\s]* #mirror://mirrors.ubuntu.com/mirrors.txt #g" /etc/apt/sources.list

# Install Dependencies
apt-get update -qq
apt-get install -qy --force-yes mono-runtime \
                                mediainfo \
                                wget \
                                libsqlite3-dev \
                                libc6-dev \
                                ffmpeg \
                                imagemagick-6.q8 \
                                libmagickwand-6.q8-2 \
                                libmagickcore-6.q8-2 \
                                emby-server-beta

#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*
