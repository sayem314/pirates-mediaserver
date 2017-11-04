# For testing with travis only
# Build at your own risk

FROM debian:stable-slim

RUN apt-get update -y
RUN apt-get install sudo wget udev -y

WORKDIR /opt
ENV SWAP=no

RUN wget https://raw.githubusercontent.com/sayem314/pirates-mediaserver/master/setup.sh -O - -o /dev/null|bash 

USER mediaserver
ENTRYPOINT ["/bin/bash"]
