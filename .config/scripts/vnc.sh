# Start vnc server
tmux new-session \
  -d \
  -s vnc-server \
  x0vncserver -SecurityTypes none \
  2>/dev/null

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  sudo /opt/noVNC/utils/launch.sh --listen 80 --vnc localhost:5900 \
  2>/dev/null
