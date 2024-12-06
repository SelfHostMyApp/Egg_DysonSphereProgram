#!/bin/bash
cd /home/container

/install-script.sh

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Verbose Wine initialization logging
echo "Initializing Wine Environment..."
echo "Wine Version: $(wine --version)"
echo "Wine Prefix: $WINEPREFIX"

# Ensure Wine prefix is properly initialized
wine wineboot -i

if [[ ! -z "$ADDITIONAL_WINETRICKS" ]]; then
        echo "Running additional winetricks: $ADDITIONAL_WINETRICKS"
        for trick in $ADDITIONAL_WINETRICKS; do
                winetricks -q "$trick"
        done
fi

# Steam/Game Update logic remains the same as in previous version
if [ -z ${AUTO_UPDATE} ] || [ "${AUTO_UPDATE}" == "1" ]; then
        if [ ! -z ${SRCDS_APPID} ]; then
                ./steamcmd/steamcmd.sh +force_install_dir /home/container +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} $([[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows') +app_update ${SRCDS_APPID} $([[ ! -z ${SRCDS_BETAID} ]] && printf %s "-beta ${SRCDS_BETAID}") $([[ ! -z ${SRCDS_BETAPASS} ]] && printf %s "-betapassword ${SRCDS_BETAPASS}") $([[ ! -z ${HLDS_GAME} ]] && printf %s "+app_set_config 90 mod ${HLDS_GAME}") $([[ ! -z ${VALIDATE} ]] && printf %s "validate") +quit
        else
                echo -e "No appid set. Starting Server"
        fi
else
        echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi

# Start Xvfb if enabled
if [[ $XVFB == 1 ]]; then
        Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH} &
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
