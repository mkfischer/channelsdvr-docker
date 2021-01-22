FROM ubuntu:focal-20210119
ARG BUILD_DATE
ARG VERSION
ARG CHANNELS_RELEASE
LABEL build_version="fish version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mkfischer1970@icloud.com"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN echo "**** install stuff ****" \
  && apt update \
  && apt install wget \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
  && apt update \
  && apt install -y --no-install-recommends google-chrome-stable \
  && useradd -msd /bin/bash /media/dvr channeluser \
  && curl -f -s https://getchannels.com/dvr/setup.sh | DOWNLOAD_ONLY=1 sh \
  && usermod -d /media/dvr channeluser \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8089/tcp 1900/udp
VOLUME /media-dvr