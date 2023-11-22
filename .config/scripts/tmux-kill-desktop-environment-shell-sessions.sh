# kill all desktop-environment-shell sessions
tmux list-sessions | \
  grep shell- | \
  cut -d: -f1 | \
  xargs -n1 tmux kill-session -t
