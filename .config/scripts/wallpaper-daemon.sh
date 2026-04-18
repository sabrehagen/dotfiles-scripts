# Start mpv wallpaper per monitor with window enhancements for picom shading
monitors=$(xrandr --listmonitors | awk 'NR>1 {sub(/\/[0-9]+/, "", $3); sub(/\/[0-9]+/, "", $3); print $3, $4}')
IFS='
'
for line in $monitors; do
  geom=${line% *}
  name=${line##* }
  xwinwrap -b -s -st -sp -nf -ov -fdt -g $geom -- \
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
    --input-ipc-server=$HOME/.cache/wal/mpv-ipc-$name \
    $(cat $HOME/.cache/wal/wal) &
done

# Keep script alive so tmux session and child mpv instances persist
wait
