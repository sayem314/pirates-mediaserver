# Pirates Mediaserver [![CI](https://github.com/sayem314/pirates-mediaserver/actions/workflows/ci.yml/badge.svg)](https://github.com/sayem314/pirates-mediaserver/actions/workflows/ci.yml)

## About

This repository contains scripts for setting up a private media-server. This script can install Plex, Sonarr, Radarr, Prowlarr, Jackett and qBittorrent on the fly.

Prowlarr is the default indexer and replaces Jackett for new installs.
Jackett stays available as an optional legacy alternative, enable it with `JACKETT=yes`.

Every installer always fetches the latest upstream release at install time:

| App | Source | Needs mono |
| :-- | :----- | :--------- |
| Sonarr v4 | [Sonarr/Sonarr releases](https://github.com/Sonarr/Sonarr/releases) | no |
| Radarr v6 | [Radarr/Radarr releases](https://github.com/Radarr/Radarr/releases) | no |
| Prowlarr v2 (default indexer) | [Prowlarr/Prowlarr releases](https://github.com/Prowlarr/Prowlarr/releases) | no |
| Jackett (optional) | [Jackett/Jackett releases](https://github.com/Jackett/Jackett/releases) | no |
| qBittorrent | [qbittorrent-nox-static releases](https://github.com/userdocs/qbittorrent-nox-static/releases) | no |
| Plex | [plex.tv downloads feed](https://www.plex.tv/media-server-downloads/) | no |

All apps are native .NET builds now, so mono is no longer installed or required.

## Requirements

At this moment only following distros are supported.

|   Debian    |    Ubuntu    |    CentOS    |
| :---------: | :----------: | :----------: |
| Recommended |   LTS Only   | Experimental |
|    12-13    |  22.04-26.04 |      9+      |

- 64-bit (x86_64 or arm64) system
- systemd for the generated services

## Install

Just execute below code to install them all.

`wget https://git.io/setup.sh -O - -o /dev/null|bash`

To exclude certain apps follow these instructions:

### Step 1

Download script: `wget https://git.io/setup.sh -O setup.sh`

Make it executable: `chmod +x setup.sh`

### Step 2

Now use variable like this: `PLEX=no PROWLARR=no JACKETT=yes ./setup.sh`

This will install everything except Plex and Prowlarr, plus the optional
Jackett. Every app except Jackett is enabled by default, Jackett needs
`JACKETT=yes` to install. Hope this explain basic usage.

_There is also specific install and update instruction available on each folder_

## Updates

Sonarr, Radarr and Jackett keep updating themselves from their web interfaces.
You can also rerun the per-folder `*-update.sh` scripts to pull the latest release manually.

## Docker

The repository ships a Dockerfile that runs every installer inside `debian:stable-slim`.
Build it with:

`docker build -t mediaserver .`

## Notes for old installs

Installations made with the 2020 scripts (Sonarr v2 in `NzbDrone`, mono based
Radarr/Jackett) are not migrated. The new installers place apps in
`/opt/mediaserver/Sonarr`, `/opt/mediaserver/Radarr`, `/opt/mediaserver/Prowlarr`
and `/opt/mediaserver/Jackett`.
Stop and disable the old services before switching over, then move any library
data you want to keep.
