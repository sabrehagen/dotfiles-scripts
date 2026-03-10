CURRENT_DPI=$(cat ~/.Xresources | sed -n 's/Xft.dpi: //p')
DPI_OPTIONS="96 144 192 254"
NEW_DPI=$(echo $DPI_OPTIONS | tr ' ' \\n | $HOME/.config/scripts/dmenu.sh -p "Set DPI ($CURRENT_DPI):")

if [ -n "$NEW_DPI" ]; then
  # Update xresources and apply to x server
  sed -iE "s/Xft.dpi.*/Xft.dpi: $NEW_DPI/" $HOME/.Xresources
  xrdb -merge $HOME/.Xresources

  # Set resolution based on DPI
  if [ $NEW_DPI = "96" ]; then
    xrandr --size 1920x1080
  elif [ $NEW_DPI = "144" ]; then
    xrandr --size 3840x2160
  fi

  # Update i3
  i3-msg restart >/dev/null

  # Update wallpaper window to match resolution
  xdotool windowsize $(xdotool search --class xwinwrap) 100% 100%
fi
