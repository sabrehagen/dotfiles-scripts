ls $HOME/.config/scripts | \
  grep dmenu- | \
  grep -v dmenu-scripts | \
  sed -E 's/dmenu-(.*).sh/\1/' | \
  $HOME/.config/scripts/dmenu.sh | \
  xargs -I@ /bin/sh $HOME/.config/scripts/dmenu-@.sh &
