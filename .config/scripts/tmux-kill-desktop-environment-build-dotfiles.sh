# Kill any previous dotfiles builds
tmux list-sessions | \
  grep build-dotfiles | \
  cut -d: -f1 | \
  xargs -n1 tmux kill-session -t nonexistent-target-to-avoid-empty-build-dotfiles-session-list -t \
  2>/dev/null
