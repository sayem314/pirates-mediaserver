#!/bin/bash
# prowlarr-updater by @sayem314

# Prowlarr v2 is a native .NET application, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop prowlarr first
service prowlarr stop
sleep 3

echo "Updating prowlarr. Please wait!"
wget -q "$(wget -qO- https://api.github.com/repos/Prowlarr/Prowlarr/releases | grep -oE 'https://[^"]*Prowlarr\.develop\.[0-9.]+\.linux-core-x64\.tar\.gz' | head -1)" || exit
tar -xzf Prowlarr.develop.*.linux-core-x64.tar.gz
rm -f Prowlarr.develop.*.linux-core-x64.tar.gz
chown -R $user:$user Prowlarr

# start prowlarr now
service prowlarr start

echo "Update finished."
