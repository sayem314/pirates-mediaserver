#!/bin/bash
# plex-installer by @sayem314

echo "Installing plex. Please wait!"

# Resolve the latest release from the official Plex downloads feed
plex_json=$(wget -qO- https://plex.tv/api/downloads/5.json) || exit

if [[ ! $(uname -m) == "x86_64" ]]; then
	echo "unsupported architecture: $(uname -m). Plex only ships 64-bit builds." >&2
	exit 1
fi

# Detecting apt-get/yum
if hash apt-get 2>/dev/null; then
	plex_url=$(grep -oE 'https://downloads.plex.tv/plex-media-server-new/[^"]*debian/plexmediaserver_[^"]*_amd64\.deb' <<<"$plex_json" | head -1)
	[[ -n $plex_url ]] || { echo "Could not resolve the latest plex debian package" >&2; exit 1; }

	wget -q "$plex_url" || exit
	apt-get install -y ./plexmediaserver*.deb || dpkg -i plexmediaserver*.deb
	rm -f plexmediaserver*.deb
	mkdir -p /var/plex/media
	chown plex:plex -R /var/plex/media
	echo "Install finished. Default port is 32400"
elif hash yum 2>/dev/null; then
	plex_url=$(grep -oE 'https://downloads.plex.tv/plex-media-server-new/[^"]*redhat/plexmediaserver[^"]*\.x86_64\.rpm' <<<"$plex_json" | head -1)
	[[ -n $plex_url ]] || { echo "Could not resolve the latest plex rpm package" >&2; exit 1; }

	wget -q "$plex_url" || exit
	yum localinstall -y plexmediaserver*.rpm
	rm -f plexmediaserver*.rpm
	if [[ -d /run/systemd/system ]]; then
		systemctl enable plexmediaserver.service
		systemctl start plexmediaserver.service
	fi
	mkdir -p /var/plex/media
	chown plex:plex -R /var/plex/media
	echo "Install finished. Default port is 32400"
else
	echo "unsupported or unknown architecture"
fi
