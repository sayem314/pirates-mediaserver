# For testing with CI only
# Build at your own risk

# use latest debian
FROM debian:stable-slim

# install some required packages
RUN apt-get update -qq \
	&& apt-get install -qqy sudo wget ca-certificates udev avahi-daemon procps \
	&& rm -rf /var/lib/apt/lists/*

# set working directory
WORKDIR /opt

# disable swap
ENV SWAP=no

# copy repo to docker
ADD . /opt/

# install each app in its own layer
RUN ./prowlarr/prowlarr-install.sh
RUN ./qbittorrent/qbittorrent-install.sh
RUN ./sonarr/sonarr-install.sh
RUN ./radarr/radarr-install.sh
RUN ./plex/plex-install.sh

# set default user
USER mediaserver

# entrypoint is bash
ENTRYPOINT ["/bin/bash"]
