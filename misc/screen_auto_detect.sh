#!/bin/bash

# List and turn all available displays

# get info from xrandr
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

execute="xrandr "

previous=""

# iterate through connected displays
for display in $connectedOutputs
do
	# display mode: auto
	execute="${execute}--output ${display} --auto "
	# set position: on the right of previous screen
	if [ "$previous" != "" ]; then
		execute="${execute}--right-of ${previous}"
	fi
	previous=$display
done

eval $execute
