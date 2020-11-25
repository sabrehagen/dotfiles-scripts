#!/bin/zsh

# to add new mode run:
# cvt width height refreshrate
# this will output Modeline
# insert modeline values into 2 commands below


function set_res(){

echo "setting resolution for Width: ${1}, Height ${2}, RefreshRate ${3}"
MODE="${1}x${2}_${3}"
MODELINE=$(cvt $1 $2 $3)
# create mode
xrandr --newmode $MODELINE

# Add mode
xrandr --addmode Virtual1 $MODE

# Apply mode
xrandr --output Virtual1 --primary --mode 1920x1080_60.02

}

# If vmware machine
if [ -c /dev/vsock ]; then
    echo "you are using a vmware machine u little fucker"

elif [ -c /dev/vhost-vsock ]; then
    echo "you are using a virtualbox machine u little cunt"
    set_res 1920 1080 60.02
else
    echo "you are using a host machine u braggart"
fi



