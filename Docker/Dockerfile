# Emby Server
# Contributors: gfjardim <gfjardim@gmail.com>
FROM phusion/baseimage:0.9.16
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>


#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
# these are done first because they are unlikely to change.
# this helps the docker layers work for you on future rebuilds

# install wget so we can get setu the repos
RUN apt-get update -qq && apt-get install -qy --force-yes wget && apt-get clean -y


# Repositories
RUN wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_14.04/Release.key | apt-key add - && \
    echo 'deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/emby.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe multiverse restricted' > /etc/apt/sources.list && \
    echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main universe multiverse restricted' >> /etc/apt/sources.list && \
    add-apt-repository ppa:mc3man/trusty-media

# Use mirrors
# sed -i -e "s#http://[^\s]*archive.ubuntu[^\s]* #mirror://mirrors.ubuntu.com/mirrors.txt #g" /etc/apt/sources.list

# Install Dependencies
RUN apt-get update -qq && apt-get clean -y
RUN apt-get install -qy --force-yes mono-runtime \
                                mediainfo \
                                libsqlite3-dev \
                                libc6-dev \
                                ffmpeg \
                                imagemagick-6.q8 \
                                libmagickwand-6.q8-2 \
                                libmagickcore-6.q8-2 \
                                sudo \
                                emby-server && \
    apt-get clean -y



#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# Set correct environment variables
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

#########################################
##         RUN INSTALL SCRIPT          ##
#########################################
COPY ./install.sh /tmp/
RUN chmod +x /tmp/install.sh && /tmp/install.sh && rm /tmp/install.sh
#########################################
##         EXPORTS AND VOLUMES         ##
#########################################
VOLUME /config 
EXPOSE 8096 8920 7359/udp 1900/udp
