#!/bin/bash
# radarr-updater by @sayem314

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop radarr first
service radarr stop

echo "Updating radarr. Please wait!"
wget -q "$( wget -qO- https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )"
tar -xzf Radarr.develop.*.linux.tar.gz
rm -f Radarr.develop.*.linux.tar.gz
chown -R $user:$user Radarr

# start radarr now
service radarr start

echo "Update finished."