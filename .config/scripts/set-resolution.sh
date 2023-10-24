WIDTH=$1
HEIGHT=$2
MODE=${WIDTH}x${HEIGHT}

# Add resolution mode
xrandr --newmode $MODE $(cvt $WIDTH $HEIGHT | tail -n 1 | cut -d' ' -f3-)

# Get display output
OUTPUT=$(xrandr | grep " connected" | cut -d' ' -f1)

# Add display mode
xrandr --addmode $OUTPUT $MODE

# Set display mode
xrandr --output $OUTPUT --mode $MODE
