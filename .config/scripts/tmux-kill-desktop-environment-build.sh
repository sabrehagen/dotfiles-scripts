# Kill any previous desktop environment builds
tmux list-sessions | \
  grep desktop-environment-build | \
  cut -d: -f1 | \
  xargs -n1 tmux kill-session -t nonexistent-target-to-avoid-empty-desktop-environment-build-clean-session-list -t \
  2>/dev/null
