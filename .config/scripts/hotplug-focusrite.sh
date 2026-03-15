udevadm monitor | \
  grep -E --line-buffered 'change.*usb.*sound/card' | \
  xargs -L 1 sh -c 'sleep 2 && alsactl -f $HOME/.config/alsa/focusrite-direct.state restore'
