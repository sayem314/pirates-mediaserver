#!/bin/bash
# radarr-updater by @sayem314

# Radarr v6 is a native .NET application, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop radarr first
service radarr stop
sleep 3

echo "Updating radarr. Please wait!"
wget -q "$(wget -qO- https://api.github.com/repos/Radarr/Radarr/releases | grep -oE 'https://[^"]*Radarr\.develop\.[0-9.]+\.linux-core-x64\.tar\.gz' | head -1)" || exit
tar -xzf Radarr.develop.*.linux-core-x64.tar.gz
rm -f Radarr.develop.*.linux-core-x64.tar.gz
chown -R $user:$user Radarr

# start radarr now
service radarr start

echo "Update finished."
