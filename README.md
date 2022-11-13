# DSPNebulaDocker
An attempt at getting Dyson Sphere Program Nebula Mod working on Docker using Wine.

I am no way a Docker expert or know how to use Wine. I cobbled together this script that does run a DSP Headless Client within Pter (https://pterodactyl.io)

# How To use this in Pter:
1. You first need to import the egg into your Pter Install using the Nests area
2. Install a new server using the new egg you have just imported
3. Wait for the server setup to complete, this can take a long time.
4. Once the server install process is finished go to the Settings tab for your server and connect using SCP (WinSCP is what i use), create a directory called "game"
5. Upload the whole of your DSP Headless Client directory here.
6. Go back to the root directory and copy your "Dyson Sphere Program" folder from your Documents to this root directory.

It should look like this:

![image](https://user-images.githubusercontent.com/1773445/201533782-3f4792a8-e614-45fb-9803-11f237bb40df.png)
