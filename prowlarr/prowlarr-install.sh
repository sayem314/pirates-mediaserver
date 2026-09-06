#!/bin/bash
# prowlarr-installer by @sayem314

# Prowlarr v2 is a native .NET application, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# check if installed
if [[ -e $installdir/Prowlarr/Prowlarr ]]; then
	echo "Prowlarr is already installed."
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

# working directory
cd $installdir || exit

echo "Installing prowlarr. Please wait!"
wget -q "$(wget -qO- https://api.github.com/repos/Prowlarr/Prowlarr/releases | grep -oE 'https://[^"]*Prowlarr\.develop\.[0-9.]+\.linux-core-x64\.tar\.gz' | head -1)" || exit
tar -xzf Prowlarr.develop.*.linux-core-x64.tar.gz
rm -f Prowlarr.develop.*.linux-core-x64.tar.gz
chown -R $user:$user Prowlarr

# Create startup service
if [[ -d /run/systemd/system ]]; then
	echo "Creating systemd service"
	cat > /etc/systemd/system/prowlarr.service <<EOF
[Unit]
Description=Prowlarr Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/Prowlarr
Type=simple
User=$user
ExecStart=$installdir/Prowlarr/Prowlarr -nobrowser
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
	chmod 0644 /etc/systemd/system/prowlarr.service
	systemctl daemon-reload
	systemctl enable prowlarr
	service prowlarr start
fi

echo "Install finished. Default port is 9696"
