#!/bin/bash
# jackett-updater by @sayem314

# Jackett ships native .NET builds, no mono required

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop jackett first
service jackett stop
sleep 3

echo "Updating jackett. Please wait!"
wget -q "https://github.com/Jackett/Jackett/releases/latest/download/Jackett.Binaries.LinuxAMDx64.tar.gz" || exit
rm -rf Jackett
tar -xzf Jackett.Binaries.LinuxAMDx64.tar.gz
rm -f Jackett.Binaries.LinuxAMDx64.tar.gz
chown -R $user:$user Jackett

# start jackett now
service jackett start

echo "Update finished."
