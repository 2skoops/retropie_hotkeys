#!/usr/bin/env bash
# skip_intro.sh
#############################################
# Skip intro video if button is pressed on Player 1
#############################################
OMXPLAYER_PID=""

# Exit if splash isn't enabled
if ! [ -f /etc/systemd/system/sysinit.target.wants/asplashscreen.service ]; then
	exit
	#echo Exiting
else
# Wait for splash to start if it hasn't already
	while [ "$OMXPLAYER_PID" == "" ]; do
		OMXPLAYER_PID=$(ps -e | grep -F omxplayer.bin | grep -P -o '\d\d\d(\d|)')
		#echo $OMXPLAYER_PID
		##### Exit script if an image is being displayed instead of a video file
		OMXIV_PID=$(ps -e | grep -F omxiv | grep -P -o '\d\d\d(\d|)')
		#echo $OMXIV_PID
		if ! [ "$OMXIV_PID" == "" ]; then
			exit
		#echo Exiting
		fi
		#######################################################################
		sleep 1
	done
fi

#Keep script running while OMXPLAYER is playing splashscreen
if ! [ "$OMXPLAYER_PID" == "" ]; then
	while [ -e /proc/$OMXPLAYER_PID ]; do
		# All of Controller 1's button presses
		# Captures controller output
		P1_BUTTONS_RAW=$(timeout 0.1s jstest /dev/input/js0)
		#echo $P1_BUTTONS_RAW
		# Remove all but the last line of button presses
		P1_BUTTONS_LIST=$(echo "$P1_BUTTONS_RAW" | grep -P -o 'Buttons:(?:.(?!Buttons:))+$')
		#echo $P1_BUTTONS_LIST
		# Counts the amount of ":on"'s and displays it as a number 
		P1_BUTTONS_PRESSED=$(echo "$P1_BUTTONS_LIST" | grep -o ':on' | wc -l)
		#echo $P1_BUTTONS_PRESSED Buttons Pressed

		#One (or more) buttons are being pressed
		if (( $P1_BUTTONS_PRESSED >= 1 )); then
			sudo kill $OMXPLAYER_PID > /dev/null
			exit
		fi
		sleep 0.1
	done
fi
