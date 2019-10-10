udevadm monitor --subsystem-match=drm --property --udev | \
  grep -E --line-buffered "UDEV .*card0" | \
  xargs -L 1 autorandr --change
