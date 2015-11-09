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
HOME_PATH=/usr/lib/emby-server
PROGRAMDATA=/config
HOME_CURRENT_USER=`ls -lad $HOME_PATH | awk '{print $3}'`
DATA_CURRENT_USER=`ls -lad $PROGRAMDATA | awk '{print $3}'`

if [ "$HOME_CURRENT_USER" != "$USER" ]; then
    chown -R "${USER}:users $DAEMON_PATH"
fi

if [ "$DATA_CURRENT_USER" != "$USER" ]; then
    chown -R "$USER":users "$PROGRAMDATA"
fi

# Check if user wants auto updates
if [ "$AUTO_UPDATE" = "true" ]; then
    echo "* 3 * * * /Update.sh" > /etc/cron.d/cron.conf
fi

chown -R nobody:users /home/
chmod +x /Update.sh
chmod +x /Restart.sh
EOT

# Sudoers 
cat <<'EOT' > /etc/sudoers.d/emby
#Allow emby to start, stop and restart itself
nobody ALL=(ALL) NOPASSWD: /usr/bin/sv *
#Allow the server to mount iso images
nobody ALL=(ALL) NOPASSWD: /bin/mount
nobody ALL=(ALL) NOPASSWD: /bin/umount

Defaults:nobody !requiretty
EOT

# Restart
cat <<'EOT' > /Restart.sh
#!/bin/bash

sudo sv restart emby
EOT


# Updates
cat <<'EOT' > /Update.sh
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

cd /usr/lib/emby-server/
exec env MONO_THREADS_PER_CPU=100 MONO_GC_PARAMS=nursery-size=64m /sbin/setuser nobody mono-sgen /usr/lib/emby-server/MediaBrowser.Server.Mono.exe \
                                -programdata /config \
                                -ffmpeg $(which ffmpeg) \
                                -ffprobe $(which ffprobe) \
				-restartpath "/Restart.sh" \
				-restartargs ""
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/*
