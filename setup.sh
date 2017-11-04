#!/bin/bash
#
# mediserver-installer by @sayem314
# https://github.com/sayem314/pirates-mediaserver
#

# Check root access
if [[ "$EUID" -ne 0 ]]; then
	echo "  Sorry, you need to run this as root"
	exit
fi

# We will calculate how much swap we would need
# Create swap file to prevent out of memory errors
# Do not create swap if system has 1GB or more RAM
if [[ $SWAP != "no" ]]; then
	tram=$( free -m | grep Mem | awk 'NR=1 {print $2}' )
	if [[ "$tram" -lt 950 ]]; then
		tswap=$( cat /proc/meminfo | grep SwapTotal | awk 'NR=1 {print $2$3}' )
		if [[ "$tswap" = '0kB' ]]; then
			echo "We will now create 1GB swapfile!"
			# Do not create if OpenVZ VPS
			if [[ ! -f /proc/user_beancounters ]]; then
				echo "Creating swap file, please wait"
				install -o root -g root -m 0600 /dev/null /swapfile
				dd if=/dev/zero of=/swapfile bs=1k count=1024k
				mkswap /swapfile
				swapon /swapfile
				echo "/swapfile       swap    swap    auto      0       0" | tee -a /etc/fstab
			else
				echo "Swap is not supported on OpenVZ. You might face problems."
				echo "Ask your provider to add swap or get higher RAM server."
				sleep 5
			fi
		fi
	fi
fi

# install mono if not exist
hash mono 2>/dev/nul || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/mono/mono-install.sh -O - -o /dev/null|bash

# install directory
DIR="/opt/mediaserver"

# Install sonarr
if [[ $SONARR != "no" ]]; then
	[[ -e $DIR/NzbDrone/NzbDrone.exe ]] || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/sonarr/sonarr-install.sh -O - -o /dev/null|bash
else
	echo "Sonarr installation skipped."
fi

# Install radarr
if [[ $RADARR != "no" ]]; then
	[[ -e $DIR/Radarr/Radarr.exe ]] || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/radarr/radarr-install.sh -O - -o /dev/null|bash
else
	echo "Radarr installation skipped."
fi

# Install jackett
if [[ $JACKETT != "no" ]]; then
	[[ -e $DIR/Jackett/JackettConsole.exe ]] || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/jackett/jackett-install.sh -O - -o /dev/null|bash
else
	echo "Jackett installation skipped."
fi

# Install qbittorrent
if [[ $QBITTORRENT != "no" ]]; then
	[[ -e /usr/bin/qbittorrent-nox ]] || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/qbittorrent/qbittorrent-install.sh -O - -o /dev/null|bash
else
	echo "qBittorrent installation skipped."
fi

# Install plex
if [[ $PLEX != "no" ]]; then
	[[ -d /usr/lib/plexmediaserver ]] || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/plex/plex-install.sh -O - -o /dev/null|bash
else
	echo "plex installation skipped."
fi
