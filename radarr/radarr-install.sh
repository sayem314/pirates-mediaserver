#!/bin/bash
# radarr-installer by @sayem314

# Radarr v6 is a native .NET application, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# native .NET builds need ICU for globalization, minimal systems lack it
if ! ldconfig -p 2>/dev/null | grep -q libicu; then
	echo "Installing ICU runtime"
	if hash apt-get 2>/dev/null; then
		apt-get update -qq
		apt-get install -yqq libicu-dev
	elif hash yum 2>/dev/null; then
		yum install -yq icu
	fi
fi

# check if installed
if [[ -e $installdir/Radarr/Radarr ]]; then
	echo "Radarr is already installed."
	exit
fi

# Creating non-root user
[[ -d $installdir ]] || mkdir -p "$installdir"
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
wget -q "$(wget -qO- https://api.github.com/repos/Radarr/Radarr/releases | grep -oE 'https://[^"]*Radarr\.develop\.[0-9.]+\.linux-core-x64\.tar\.gz' | head -1)" || exit
tar -xzf Radarr.develop.*.linux-core-x64.tar.gz
rm -f Radarr.develop.*.linux-core-x64.tar.gz
chown -R $user:$user Radarr

# Create startup service
if [[ -d /run/systemd/system ]]; then
	echo "Creating systemd service"
	cat > /etc/systemd/system/radarr.service <<EOF
[Unit]
Description=Radarr Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/Radarr
Type=simple
User=$user
ExecStart=$installdir/Radarr/Radarr -nobrowser
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
	chmod 0644 /etc/systemd/system/radarr.service
	systemctl daemon-reload
	systemctl enable radarr
	service radarr start
fi

echo "Install finished. Default port is 7878"
