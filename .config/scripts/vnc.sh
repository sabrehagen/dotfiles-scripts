# Start vnc server
tmux new-session \
  -d \
  -s vnc-server \
  x11vnc -forever \
  2>/dev/null

# Retain vnc server logs after exit
tmux set-hook \
  -t vnc-server \
  window-linked \
  'set remain-on-exit on'

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  sudo /opt/noVNC/utils/launch.sh --listen 80 \
  2>/dev/null
