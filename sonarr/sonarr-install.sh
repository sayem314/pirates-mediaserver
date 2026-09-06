#!/bin/bash
# sonarr-installer by @sayem314

# Sonarr v4 is a native .NET 6 application, no mono required

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
if [[ -e $installdir/Sonarr/Sonarr ]]; then
	echo "Sonarr is already installed."
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

echo "Installing sonarr. Please wait!"
wget -q "$(wget -qO- https://api.github.com/repos/Sonarr/Sonarr/releases | grep -oE 'https://[^"]*Sonarr\.develop\.[0-9.]+\.linux-x64\.tar\.gz' | head -1)" || exit
tar -xzf Sonarr.develop.*.linux-x64.tar.gz
rm -f Sonarr.develop.*.linux-x64.tar.gz
chown -R $user:$user Sonarr

# Create startup service
if [[ -d /run/systemd/system ]]; then
	echo "Creating systemd service"
	cat > /etc/systemd/system/sonarr.service <<EOF
[Unit]
Description=Sonarr Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/Sonarr
Type=simple
User=$user
ExecStart=$installdir/Sonarr/Sonarr -nobrowser
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
	chmod 0644 /etc/systemd/system/sonarr.service
	systemctl daemon-reload
	systemctl enable sonarr
	service sonarr start
fi

echo "Install finished. Default port is 8989"
