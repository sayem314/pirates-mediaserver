#!/bin/bash
# mono-installer by @sayem314

# check if installed
if [[ -e /usr/bin/mono ]]; then
	echo "Mono is already installed."
	exit
fi

echo "Installing mono. Please wait!"
# Detecting apt-get/yum
if hash apt-get 2>/dev/null; then
	apt-get install lsb-release curl dirmngr -qy
	CODENAME=$(cat /etc/*-release | grep "VERSION_ID=" | cut -f1 -d'.'| cut -f2 -d'"')
	OSNAME=$(lsb_release -i | awk 'NF{ print $NF }' | tr '[:upper:]' '[:lower:]')
	if [[ $CODENAME -ge 7 ]]; then
		RELEASENAME=$(lsb_release -c | awk 'NF{ print $NF }')
		apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb http://download.mono-project.com/repo/$OSNAME $RELEASENAME main" | tee /etc/apt/sources.list.d/mono-official.list
		apt-get update
		apt-get install mono-devel -qy
		apt-get install libmono-cil-dev mediainfo sqlite3 -qy
	fi
	echo "Install finished."

# CentOS is experimental
elif hash yum 2>/dev/null; then
	yum update
	yum install yum-utils curl -qy
	MAJOR=$(lsb_release -i | awk 'NF{ print $NF }' | tr '[:upper:]' '[:lower:]')
	if [[ $CODENAME -ge 6 ]]; then
		rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
		yum-config-manager --add-repo http://download.mono-project.com/repo/centos$MAJOR/
		yum install mono-devel -qy
		yum install libmono-cil-dev mediainfo sqlite3 -qy
	fi
	echo "Install finished."
else
	echo "unsupported or unknown architecture"
fi
