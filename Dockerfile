# For testing with travis only
# Build at your own risk

FROM debian:stable-slim

RUN apt-get update -qq
RUN apt-get install sudo wget udev -qqy

WORKDIR /opt
ENV SWAP=no

ADD * /opt/

RUN ./mono/mono-install.sh \
	&& ./jackett/jackett-install.sh \
	&& ./jackett/jackett-update.sh \
	&& ./qbittorrent/qbittorrent-install.sh
	&& ./sonarr/sonarr-install.sh \
	&& ./sonarr/sonarr-update.sh \
	&& ./radarr/radarr-install.sh \
	&& ./radarr/radarr-update.sh
	&& ./plex/plex-install.sh

USER mediaserver
ENTRYPOINT ["/bin/bash"]
