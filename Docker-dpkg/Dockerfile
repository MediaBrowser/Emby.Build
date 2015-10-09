FROM hurricane/jessie

RUN apt-get update \
 && apt-get install -y virt-manager ssh-client ssh-askpass \
		hicolor-icon-theme libcanberra-gtk3-module

COPY scripts/ /var/cache/virt-manager/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
