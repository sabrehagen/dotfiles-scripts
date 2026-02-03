WALL_CACHE=$HOME/.cache/wal

# Start mpv with window enhancements for picom shading
xwinwrap -b -s -fs -st -sp -nf -ovr -fdt -- \
  /usr/bin/mpv \
  -wid WID \
  --no-config \
  --no-input-default-bindings \
  --input-vo-keyboard=no \
  --input-terminal=no \
  --no-osc \
  --no-terminal \
  --framedrop=vo \
  --no-audio \
  --panscan=1.0 \
  --image-display-duration=inf \
  --loop-file=inf \
  --keep-open=always \
  --idle=yes \
  --force-window=yes \
  --input-ipc-server=$WALL_CACHE/mpv-ipc \
  $(cat $WALL_CACHE/wal)
