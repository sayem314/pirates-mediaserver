#!/bin/bash
#
# sonarr-updater by @sayem314
#

# Global value
user="mediaserver"
installdir="/opt/$user"

# working directory
cd $installdir || exit

# stop sonarr first
service sonarr stop

echo "Updating sonarr"
wget http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz
tar -xzf NzbDrone.master.tar.gz
rm -f NzbDrone.master.tar.gz
chown -R $user:$user NzbDrone

# start sonarr now
service sonarr start

echo "Update finished."
