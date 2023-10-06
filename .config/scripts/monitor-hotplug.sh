udevadm monitor --subsystem-match=drm --property --udev | \
  grep -E --line-buffered "UDEV .*card0" | \
  xargs -L 1 $HOME/.config/scripts/autorandr.sh
