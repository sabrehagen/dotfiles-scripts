# Launch alacritty
nohup alacritty "$@" >/dev/null 2>&1 &

# Wait for alacritty window to appear
xdotool search --pid $! --sync

# Apply terminal colours
wal -Retn
