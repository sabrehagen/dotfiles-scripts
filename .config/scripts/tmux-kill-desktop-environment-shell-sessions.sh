# kill all desktop-environment-shell sessions
tmux ls | \
  grep shell- | \
  cut -d: -f1 | \
  xargs -n 1 tmux kill-session -t
