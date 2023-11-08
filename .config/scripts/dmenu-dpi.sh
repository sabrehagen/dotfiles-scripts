CURRENT_DPI=$(cat ~/.Xresources | sed -n 's/Xft.dpi: //p')
DPI_OPTIONS="96 144 192 254"
NEW_DPI=$(echo $DPI_OPTIONS | tr ' ' \\n | $HOME/.config/scripts/dmenu.sh -p "Set DPI ($CURRENT_DPI):")

if [ -n "$NEW_DPI" ]; then
  sed -iE "s/Xft.dpi.*/Xft.dpi: $NEW_DPI/" $HOME/.Xresources
  xrdb -merge $HOME/.Xresources
  i3-msg restart
fi
