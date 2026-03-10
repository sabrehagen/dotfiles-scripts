NEW_DPI=$1

set -eu pipefail

# Set resolution and i3blocks spacing based on DPI
if [ $NEW_DPI = "96" ]; then
  xrandr --size 1920x1080
  sed -i -e 's/^separator_block_width=.*/separator_block_width=18/' $HOME/.config/i3blocks/config
elif [ $NEW_DPI = "144" ]; then
  xrandr --size 3840x2160
  sed -i -e 's/^separator_block_width=.*/separator_block_width=22/' $HOME/.config/i3blocks/config
fi

# Update i3
i3-msg restart >/dev/null

# Update wallpaper window to match resolution
xdotool windowsize $(xdotool search --class xwinwrap) 100% 100%

# Update xresources and apply to x server
sed -iE "s/Xft.dpi.*/Xft.dpi: $NEW_DPI/" $HOME/.Xresources
xrdb -merge $HOME/.Xresources
