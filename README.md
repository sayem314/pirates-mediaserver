Pirates Mediaserver
=======

About
-----

This repository contains scripts for setting up a private media-server. This script can install Plex, Sonarr, Radarr and Jackett on the fly.

Requirements
------------

At this moment only following distros are supported.

| Debian  | Ubuntu |
|:---:|:---:|
| Wheezy (7.x) | Xenial Xerus (16.04.x) |
| Jessie (8.x) | Trusty Tahr (14.04.x) |
| Stretch (9.x) | Precise Pangolin (12.04.x) |

Install
-------

Just execute below code to install them all.

`wget https://git.io/setup.sh -O - -o /dev/null|bash`

To exclude certain apps follow these instructions:

### Step 1
Download script: `wget https://git.io/setup.sh -O setup.sh`

Make it executable: `chmod +x setup.sh`

### Step 2
Now use variable like this: `PLEX=no JACKETT=No ./setup.sh`

This will install everything else except Plex and Jackett. Hope this explain basic usage.
