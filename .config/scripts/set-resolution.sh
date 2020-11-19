# to add new mode run:
# cvt width height refreshrate
# this will output Modeline
# insert modeline values into 2 commands below


# create mode
xrandr --newmode "1920x1080_60.02" 173.00 1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

# Add mode
xrandr --addmode Virtual1 1920x1080_60.02

# Apply moder
xrandr --output Virtual1 --primary --mode 1920x1080_60.02
