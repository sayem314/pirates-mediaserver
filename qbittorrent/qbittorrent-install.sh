#!/bin/bash
# qbittorrent-installer by @sayem314

# Uses the static qbittorrent-nox build, always the latest upstream release

# Global value
user="mediaserver"
home="/opt/$user"

# check if installed
if [[ -e /usr/local/bin/qbittorrent-nox ]]; then
	echo "qbittorrent-nox is already installed."
	echo "It updates itself from the web interface."
	exit
fi

# Creating non-root user
echo "Creating user '$user'"
if id -u $user >/dev/null 2>&1; then
	echo "User '$user' already exists. Skipped!"
else
	useradd -r -m -s /bin/false $user
fi

echo "Installing qbittorrent-nox. Please wait!"
case "$(uname -m)" in
	x86_64) arch="x86_64" ;;
	aarch64) arch="aarch64" ;;
	armv7l) arch="armv7" ;;
	*)
		echo "Unsupported architecture: $(uname -m)" >&2
		exit 1
		;;
esac

wget -q -O /usr/local/bin/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/${arch}-qbittorrent-nox" || exit
chmod 755 /usr/local/bin/qbittorrent-nox

# Seed the config so the first start skips the wizard and uses fixed defaults
mkdir -p "$home/.config/qBittorrent" "$home/qBittorrent/Downloads" "$home/qBittorrent/tmp"
cat > "$home/.config/qBittorrent/qBittorrent.conf" <<EOF
[LegalNotice]
Accepted=true

[Preferences]
WebUI\\Port=9091
WebUI\\Username=admin
WebUI\\Password_ha1=@ByteArray($(echo -n "adminadmin" | md5sum | awk '{print $1}'))
EOF

chown -R $user:$user "$home/qBittorrent" "$home/.config"

# Create startup service
if [[ -d /run/systemd/system ]]; then
	echo "Creating systemd service"
	cat > /etc/systemd/system/qbittorrent.service <<EOF
[Unit]
Description=qBittorrent Daemon Service
After=network.target

[Service]
Type=simple
User=$user
ExecStart=/usr/local/bin/qbittorrent-nox
Restart=always
RestartSec=2
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
	chmod 0644 /etc/systemd/system/qbittorrent.service
	systemctl daemon-reload
	systemctl enable qbittorrent
	service qbittorrent start
fi

clear
echo "Install finished. Default settings:"
echo "User: admin"
echo "Password: adminadmin (a temporary password is printed to the service log if this one is rejected)"
echo "Port: 9091"
