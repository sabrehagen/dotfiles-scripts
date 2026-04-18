udevadm monitor | \
  grep -E --line-buffered 'drm/card[0-9]' | \
  xargs -L 1 $HOME/.config/scripts/autorandr.sh
