#!/bin/bash
#
# jackett-updater by @sayem314
#

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop jackett first
service jackett stop

echo "Updating jackett. Please wait!"
wget -q "$( wget -qO- https://api.github.com/repos/Jackett/Jackett/releases | grep Jackett.Binaries.Mono.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )"
rm -rf Jackett
tar -xzf Jackett.Binaries.Mono.tar.gz
rm -f Jackett.Binaries.Mono.tar.gz
chown -R $user:$user Jackett

# start jackett now
service jackett start

echo "Update finished."