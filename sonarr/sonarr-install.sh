#!/bin/bash
# sonarr-installer by @sayem314

# Global value
user="mediaserver"
installdir="/opt/$user"

# install mono if not exist
hash mono 2>/dev/null || wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/mono.sh -O - -o /dev/null|bash

# Creating non-root user
[[ -d $installdir ]] || mkdir -p $installdir
echo "Creating user '$user'"
if id -u $user >/dev/null 2>&1; then
	echo "User '$user' already exists. Skipped!"
else
	useradd -r -d $installdir -s /bin/false $user
	chown -R $user:$user $installdir
fi

# working directory
cd $installdir || exit

echo "Installing sonarr. Please wait!"
wget -q http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz || exit
tar -xzf NzbDrone.master.tar.gz
rm -f NzbDrone.master.tar.gz
chown -R $user:$user NzbDrone

# Create startup service
init=$(cat /proc/1/comm)
if [[ "$init" == "systemd" ]]; then
	echo "Creating systemd service"
	echo "[Unit]
Description=Sonarr Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/NzbDrone
Type=simple
User=$user
ExecStart=/usr/bin/mono NzbDrone.exe --NoRestart
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
"> /etc/systemd/system/sonarr.service
	chmod 0644 /etc/systemd/system/sonarr.service
	systemctl daemon-reload
	systemctl enable sonarr
	service sonarr start
fi

echo "Install finished. Default port is 8989"