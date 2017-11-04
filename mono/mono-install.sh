#!/bin/bash
#
# mono-installer by @sayem314
#

echo "Installing mono"
# Detecting apt-get/yum
if hash apt-get 2>/dev/null; then
	apt-get install lsb-release curl dirmngr -qqy
	CODENAME=$(cat /etc/*-release | grep "VERSION_ID=" | cut -f1 -d'.'| cut -f2 -d'"')
	OSNAME=$(lsb_release -i | awk 'NF{ print $NF }' | tr '[:upper:]' '[:lower:]')
	if [[ $CODENAME -ge 7 ]]; then
		RELEASENAME=$(lsb_release -c | awk 'NF{ print $NF }')
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb http://download.mono-project.com/repo/$OSNAME $RELEASENAME main" | tee /etc/apt/sources.list.d/mono-official.list
		apt-get update
		apt-get install mono-devel -qqy
		apt-get install libmono-cil-dev mediainfo sqlite3 -qqy
	fi
	echo "Install finished."
else
	echo "unsupported or unknown architecture"
fi
