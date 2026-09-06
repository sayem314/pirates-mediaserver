#!/bin/bash
# sonarr-updater by @sayem314

# Sonarr v4 is a native .NET 6 application, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop sonarr first
service sonarr stop
sleep 3

echo "Updating sonarr. Please wait!"
wget -q "$(wget -qO- https://api.github.com/repos/Sonarr/Sonarr/releases | grep -oE 'https://[^"]*Sonarr\.develop\.[0-9.]+\.linux-x64\.tar\.gz' | head -1)" || exit
tar -xzf Sonarr.develop.*.linux-x64.tar.gz
rm -f Sonarr.develop.*.linux-x64.tar.gz
chown -R $user:$user Sonarr

# start sonarr now
service sonarr start

echo "Update finished."
