# Kill any previous desktop environment dotfiles builds
tmux list-sessions | \
  grep desktop-environment-build-dotfiles | \
  cut -d: -f1 | \
  xargs -n1 tmux kill-session -t nonexistent-target-to-avoid-empty-desktop-environment-build-dotfiles-session-list -t \
  2>/dev/null
