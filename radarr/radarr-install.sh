#!/bin/bash
#
# radarr-installer by @sayem314
#

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

echo "Installing radarr. Please wait!"
wget -q "$( wget -qO- https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )"
tar -xzf Radarr.develop.*.linux.tar.gz
rm -f Radarr.develop.*.linux.tar.gz
chown -R $user:$user Radarr

# Create startup service
init=$(cat /proc/1/comm)
if [[ "$init" == "systemd" ]]; then
	echo "Creating systemd service"
	echo "[Unit]
Description=Radrr Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/Radarr
Type=simple
User=$user
ExecStart=/usr/bin/mono Radarr.exe --NoRestart
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
"> /etc/systemd/system/radarr.service
	chmod 0644 /etc/systemd/system/radarr.service
	systemctl daemon-reload
	systemctl enable radarr
	service radarr start
fi

echo "Install finished. Default port is 7878"