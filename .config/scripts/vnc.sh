# Start vnc server
tmux new-session \
  -d \
  -s vnc-server \
  x0vncserver -SecurityTypes none \
  2>/dev/null
