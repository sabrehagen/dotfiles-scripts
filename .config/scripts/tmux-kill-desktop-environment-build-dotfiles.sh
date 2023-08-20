# Kill any previous dotfiles builds
tmux ls | \
  grep build-dotfiles | \
  cut -f1 -d: | \
  xargs -n1 tmux kill-session -t nonexistent-target-to-avoid-empty-build-dotfiles-session-list -t \
  2>/dev/null
