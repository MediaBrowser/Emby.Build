FROM sameersbn/ubuntu:14.04.20150825

RUN apt-get update \
 && apt-get install -y virt-manager ssh-client ssh-askpass \
		hicolor-icon-theme libcanberra-gtk3-module \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX

COPY scripts/ /var/cache/virt-manager/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
