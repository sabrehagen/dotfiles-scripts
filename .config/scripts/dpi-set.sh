NEW_DPI=$1

# Set resolution and i3blocks spacing based on DPI
if [ $NEW_DPI = "96" ]; then
  RESOLUTION=1920x1080
  I3_BLOCKS_SEPARATOR_WIDTH=18
elif [ $NEW_DPI = "144" ]; then
  RESOLUTION=3840x2160
  I3_BLOCKS_SEPARATOR_WIDTH=22
fi

# Set resolution
xrandr --size $RESOLUTION || exit $?

# Set i3blocks separator width matching resolution
sed -i -e s/^separator_block_width=.*/separator_block_width=$I3_BLOCKS_SEPARATOR_WIDTH/ $HOME/.config/i3blocks/config

# Update xresources and apply to x server
sed -iE "s/Xft.dpi.*/Xft.dpi: $NEW_DPI/" $HOME/.Xresources
xrdb -merge $HOME/.Xresources

# Update i3 to use new dpi
i3-msg restart >/dev/null

# Set wallpaper to resolution size
xdotool windowsize $(xdotool search --class xwinwrap) 100% 100% 2>/dev/null
