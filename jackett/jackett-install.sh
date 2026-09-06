#!/bin/bash
# jackett-installer by @sayem314

# Jackett ships native .NET builds, no mono required

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
if [[ -e $installdir/Jackett/jackett ]]; then
	echo "Jackett is already installed."
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

echo "Installing jackett. Please wait!"
wget -q "https://github.com/Jackett/Jackett/releases/latest/download/Jackett.Binaries.LinuxAMDx64.tar.gz" || exit
tar -xzf Jackett.Binaries.LinuxAMDx64.tar.gz
rm -f Jackett.Binaries.LinuxAMDx64.tar.gz
chown -R $user:$user Jackett

# Create startup service
if [[ -d /run/systemd/system ]]; then
	echo "Creating systemd service"
	cat > /etc/systemd/system/jackett.service <<EOF
[Unit]
Description=Jackett Daemon
After=network.target

[Service]
WorkingDirectory=$installdir/Jackett
Type=simple
User=$user
ExecStart=$installdir/Jackett/jackett_launcher.sh
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
	chmod 0644 /etc/systemd/system/jackett.service
	systemctl daemon-reload
	systemctl enable jackett
	service jackett start
fi

echo "Install finished. Default port is 9117"
