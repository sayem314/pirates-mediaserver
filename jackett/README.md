# Jackett
======

About
-----

Jackett works as a proxy server: it translates queries from apps (Sonarr, Radarr, SickRage, CouchPotato, Mylar, DuckieTV, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.

Jackett is now the optional legacy choice of pirates-mediaserver. New installs
get Prowlarr by default, install Jackett explicitly with `JACKETT=yes`.

Install
-------

Just execute below code to install.

`wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/jackett/jackett-install.sh -O - -o /dev/null|bash`


Update
------

Just execute below code to update.

`wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/jackett/jackett-update.sh -O - -o /dev/null|bash`
