# Pterodactyl Egg - Dyson Sphere Program / Nebula Multiplayer Mod

*Based on [this existing attempt by AlienXAXS](https://github.com/AlienXAXS/DSPNebulaDocker).*

An attempt at getting Dyson Sphere Program Nebula Mod working on Docker using Wine.

I am no way a Docker expert or know how to use Wine. I cobbled together this script that does run a DSP Headless Client within Pter (https://pterodactyl.io)

# Egg Use in Pterodactyl:
1. The only file you care about as a user is `./egg/egg-dyson-sphere-program-nebula.json` - import this file as an egg into a nest in the Pterodactyl admin panel.
2. The default port for the Nebula mod is `8469`. Configure this as an allocation if you wish to use it, otherwise we will adjust the port later.
3. Create a new server using the egg you imported.
4. Wait for the server installation to complete, this can take a long time.
5. Optionally upload saves to the "Dyson Sphere Program" folder.
6. Modify the nebula.cfg files HostPort setting to your allocation port if you are not using the default.
7. Start the server.

# Things I've Tested:
*TBD.*

# Current Issues:
*TBD.*

# Want to help?
*TBD.*