# Kill all desktop-environment-shell sessions
tmux ls | \
  grep shell- | \
  cut -f1 -d: | \
  xargs -n 1 tmux kill-session -t

