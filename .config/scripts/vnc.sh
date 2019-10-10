# Start vnc server
tmux new-session \
  -d \
  -s vnc-server \
  x11vnc -forever -noxdamage \
  2>/dev/null

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  sudo /opt/noVNC/utils/launch.sh --listen 80 \
  2>/dev/null
