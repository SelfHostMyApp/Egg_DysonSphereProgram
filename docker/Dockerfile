FROM debian:bullseye-slim

LABEL author="JamesonRGrieve" maintainer="jamesonrgrieve@gmail.com"

# Use non-interactive frontend to prevent hanging during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Create container user early
RUN useradd -m -d /home/container -s /bin/bash container && \
    ln -s /home/container/ /nonexistent

COPY ./dsp/ /usr/local/games/dsp/

RUN chown -R container:container /usr/local/games

# Set environment variables
ENV USER=container \
    HOME=/home/container \
    PROTON=/usr/share/Proton \
    WINEPREFIX=/home/container/.wine \
    WINEDLLOVERRIDES="mscoree,mshtml=" \
    DISPLAY=:99 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    DISPLAY_DEPTH=16 \
    AUTO_UPDATE=1 \
    XVFB=1 \
    # Newer Wine-GE-Proton release
    WINE_GE_VERSION="GE-Proton8-24"

# Consolidate package installations and repository setup
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    wget jq \
    gnupg2 \
    ca-certificates \
    gcc g++ libgcc1 libc++-dev gdb libc6 git curl tar zip unzip \
    binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat \
    libatomic1 libsdl1.2debian libsdl2-2.0-0 libfontconfig libicu67 \
    icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev \
    libmariadbclient-dev-compat libduktape205 locales ffmpeg \
    libz-dev rapidjson-dev tzdata libevent-dev libzip4 \
    libprotobuf23 nano vim p7zip psmisc  \
    xvfb \
    x11-apps \
    xorg && \ 
    # Wine repository setup
    wget -qO- https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    # WineTricks
    wget -q -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/bin/winetricks && \
    # Xvfb setup
    apt-get install -y xvfb x11-apps xauth mesa-utils procps && \
    # Cleanup to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Wine-GE-Proton installation with improved error handling
RUN mkdir -p /usr/share/Proton && \
    wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/${WINE_GE_VERSION}/wine-lutris-${WINE_GE_VERSION}-x86_64.tar.xz -O /tmp/WGEP.tar.xz && \
    tar -xvf /tmp/WGEP.tar.xz -C /usr/share/Proton --strip-components=1 && \
    rm /tmp/WGEP.tar.xz

RUN mkdir -p /home/container/.wine && \
    Xvfb :99 & \
    export DISPLAY=:99 && \
    WINEARCH=win64 WINEPREFIX=/home/container/.wine wine wineboot -i && \
    WINEARCH=win64 WINEPREFIX=/home/container/.wine winetricks -q --force vcrun2013 vcrun2017 vcrun2019 dotnet48 && \
    chown -R container:container /home/container/.wine 

# Explicitly set Wine paths and configurations
ENV PATH="$PROTON/bin:$PATH" \
    LD_LIBRARY_PATH="$PROTON/lib:$LD_LIBRARY_PATH" \
    WINESERVER="$PROTON/bin/wineserver" \
    WINELOADER="$PROTON/bin/wine" \
    WINEDLLPATH="$PROTON/lib/wine" \
    WINEDLLOVERRIDES="mscoree,mshtml=;winemenubuilder.exe=d" 

# SteamCMD installation
RUN mkdir -p /usr/local/games/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O /tmp/steamcmd.tar.gz && \
    tar -xvzf /tmp/steamcmd.tar.gz -C /usr/local/games/steamcmd && \
    chown -R container:container /usr/local/games && \
    chmod +x /usr/local/games/steamcmd/steamcmd.sh && \
    rm /tmp/steamcmd.tar.gz && \
    /usr/local/games/steamcmd/steamcmd.sh +login anonymous +quit && \
    mkdir -p /usr/local/games/dsp/.steam/sdk32 && \
    cp -v /usr/local/games/steamcmd/linux32/steamclient.so /usr/local/games/dsp/.steam/sdk32/steamclient.so && \
    mkdir -p /usr/local/games/dsp/.steam/sdk64 && \
    cp -v /usr/local/games/steamcmd/linux64/steamclient.so /usr/local/games/dsp/.steam/sdk64/steamclient.so

COPY ./entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

COPY ./install-script.sh /install-script.sh
RUN chmod +x /install-script.sh

RUN echo $(uuidgen) > /etc/machine-id

RUN chown -R container:container /tmp && chmod 1777 /tmp

USER container
WORKDIR /home/container



CMD [ "/bin/bash", "/entry-point.sh" ]