#!/bin/bash
# plex-installer by @sayem314

echo "Installing plex. Please wait!"
# Detecting apt-get/yum
if hash apt-get 2>/dev/null; then
	# Detect architecture. We only support linux.
	if uname -m | grep -q 64; then
		wget -q https://downloads.plex.tv/plex-media-server-new/1.19.2.2737-b69929dab/debian/plexmediaserver_1.19.2.2737-b69929dab_amd64.deb
	elif uname -m | grep -q 86; then
		wget -q https://downloads.plex.tv/plex-media-server-new/1.19.2.2737-b69929dab/debian/plexmediaserver_1.19.2.2737-b69929dab_amd64.deb
	fi

	dpkg -i plexmediaserver*.deb
	rm -f plexmediaserver*.deb
	mkdir -p /var/plex/media
	chown plex:plex -R /var/plex/media
	echo "Install finished. Default port is 32400"
elif hash yum 2>/dev/null; then
	# Detect architecture. We only support linux.
	if uname -m | grep -q 64; then
		wget -q https://downloads.plex.tv/plex-media-server-new/1.19.2.2737-b69929dab/redhat/plexmediaserver-1.19.2.2737-b69929dab.x86_64.rpm
	elif uname -m | grep -q 86; then
		wget -q https://downloads.plex.tv/plex-media-server-new/1.19.2.2737-b69929dab/redhat/plexmediaserver-1.19.2.2737-b69929dab.i686.rpm
	fi

	yum install plexmediaserver*.rpm
	rm -f yum install plexmediaserver*.rpm
	systemctl enable plexmediaserver.service
	systemctl start plexmediaserver.service
	mkdir -p /var/plex/media
	chown plex:plex -R /var/plex/media
	echo "Install finished. Default port is 32400"
else
	echo "unsupported or unknown architecture"
fi
