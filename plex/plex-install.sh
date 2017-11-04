#!/bin/bash
#
# plex-installer by @sayem314
#

echo "Installing plex"
# Detecting apt-get/yum
if hash apt-get 2>/dev/null; then
	# Detect architecture. We only support linux.
	if [[ -n "$(uname -m | grep 64)" ]]; then
		wget https://downloads.plex.tv/plex-media-server/1.9.4.4325-1bf240a65/plexmediaserver_1.9.4.4325-1bf240a65_amd64.deb

	elif [[ -n "$(uname -m | grep 86)" ]]; then
		wget https://downloads.plex.tv/plex-media-server/1.9.4.4325-1bf240a65/plexmediaserver_1.9.4.4325-1bf240a65_i386.deb
	fi
	dpkg -i plexmediaserver*.deb
	rm -f plexmediaserver*.deb
	mkdir -p /var/plex/media
	chown plex:plex -R /var/plex/media
	echo "Install finished. Default port is 32400"
elif hash yum 2>/dev/null; then
	# Detect architecture. We only support linux.
	if [[ -n "$(uname -m | grep 64)" ]]; then
		wget https://downloads.plex.tv/plex-media-server/1.9.4.4325-1bf240a65/plexmediaserver-1.9.4.4325-1bf240a65.x86_64.rpm
	elif [[ -n "$(uname -m | grep 86)" ]]; then
		wget https://downloads.plex.tv/plex-media-server/1.9.4.4325-1bf240a65/plexmediaserver-1.9.4.4325-1bf240a65.i386.rpm

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
