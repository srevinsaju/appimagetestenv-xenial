FROM ubuntu:16.04
LABEL maintainer="srevinsaju@sugarlabs.org"
LABEL version="0.1"
LABEL description="AppImage QA test environment"
ARG DEBIAN_FRONTEND=noninteractive
ARG APPHOME="/home/appimage"

# create user
RUN apt update \
    && apt install -y sudo \
    && echo "appimage ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && useradd -m appimage \
    && usermod -aG sudo appimage

# install basic deps
RUN sudo apt-get -qqy install wget curl jq ruby-full build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip libz-dev \
    && OLDPATH=$(realpath .) \
    && mkdir /tmp/git -p && cd /tmp/git \
    && wget -q https://github.com/git/git/archive/v2.29.0.tar.gz \
    && tar -xf v2.29.0.tar.gz \
    && cd git-* && make prefix=/usr/local all \
    && sudo make prefix=/usr/local install \
    && cd "$OLDPATH" \
    && curl -sL https://deb.nodesource.com/setup_10.x | sudo bash \
    && sudo apt-get -y install nodejs \
    && gem install dupervisor -v 1.0.5 \
    && npm install -g asar

# install the desktop env stuff
RUN sudo apt-get -qq -y install imagemagick libasound2-dev pulseaudio-utils alsa-utils alsa-oss libjack0 desktop-file-utils xmlstarlet xterm xvfb icewm x11-utils x11-apps netpbm xdotool libgl1-mesa-dri libgl1-mesa-dev mesa-utils libosmesa6 libsdl1.2-dev fonts-wqy-microhei libfile-mimeinfo-perl libx11-xcb1 libxcb-xkb1 libxcb-* libxcb-render-util0 libxkbcommon-x11-0 libxkbcommon0

RUN mkdir $APPHOME/.icewm \
    && echo "ShowTaskBar = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarAutoHide = 1" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowWorkspaces = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowAllWindows = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowClock = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowMailboxStatus = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowCPUStatus = 0" > $APPHOME/.icewm/preferences \
    && echo "TaskBarShowWindowListMenu = 0" > $APPHOME/.icewm/preferences 

CMD ["/bin/bash"]
