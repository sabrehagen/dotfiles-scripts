# Start vnc server
tmux new-session \
  -d \
  -s vnc-server \
  x0vncserver -rfbport 5901 -SecurityTypes none \
  2>/dev/null
