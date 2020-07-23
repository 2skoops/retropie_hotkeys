# retropie_hotkeys
Detect player controller input on boot and do things

I'll be adding a better base script later so you can make your own.

# SCRIPTS:

skip_intro.sh - skips video splashscreen when button(s) are pressed



# HOW TO: 

Just add the scripts to your rc.local files like so:

sudo nano /etc/rc.local
Add "/home/pi/scripts/Hotkeys.sh &" (replace the location/name of script) before the final "exit 0" line so your rc.local file looks like this:

/home/pi/scripts/Hotkeys.sh &
exit 0


