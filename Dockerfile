# For testing with Travis-CI only
# Build at your own risk

# use latest debian
FROM debian:stable-slim

# install some required repo
RUN apt-get update -qq
RUN apt-get install sudo wget udev -qqy

# set working directory
WORKDIR /opt

# disable swap
ENV SWAP=no

# copy repo to docker
ADD . /opt/

# run script
RUN ./mono/mono-install.sh \
	&& ./jackett/jackett-install.sh \
	&& ./jackett/jackett-update.sh \
	&& ./qbittorrent/qbittorrent-install.sh \
	&& ./sonarr/sonarr-install.sh \
	&& ./sonarr/sonarr-update.sh \
	&& ./radarr/radarr-install.sh \
	&& ./radarr/radarr-update.sh \
	&& ./plex/plex-install.sh

# set default user
USER mediaserver

# entrypoint is bash
ENTRYPOINT ["/bin/bash"]
